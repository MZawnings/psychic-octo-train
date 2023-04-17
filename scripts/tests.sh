#!/usr/bin/env bash

#------------------------------------------------------------------------------
# Bash script to execute the Solidity tests.
#
# The documentation for solidity is hosted at:
#
#     https://solidity.readthedocs.org
#
# ------------------------------------------------------------------------------
# This file is part of solidity.
#
# solidity is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# solidity is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with solidity.  If not, see <http://www.gnu.org/licenses/>
#
# (c) 2016 solidity contributors.
#------------------------------------------------------------------------------

set -e

REPO_ROOT="$(dirname "$0")"/..

if [ "$1" = --junit_report ]
then
    if [ -z "$2" ]
    then
        echo "Usage: $0 [--junit_report <report_directory>]"
        exit 1
    fi
    testargs_no_opt="--logger=JUNIT,test_suite,$2/no_opt.xml"
    testargs_opt="--logger=JUNIT,test_suite,$2/opt.xml"
else
    testargs_no_opt=''
    testargs_opt=''
fi

echo "Running commandline tests..."
"$REPO_ROOT/test/cmdlineTests.sh"

# This conditional is only needed because we don't have a working Homebrew
# install for `eth` at the time of writing, so we unzip the ZIP file locally
# instead.  This will go away soon.
if [[ "$OSTYPE" == "darwin"* ]]; then
    ETH_PATH="$REPO_ROOT/eth"
elif [ -z $CI ]; then
    ETH_PATH="eth"
else
    mkdir -p /tmp/test
    ETH_BINARY=eth_byzantium_artful
    ETH_HASH="e527dd3e3dc17b983529dd7dcfb74a0d3a5aed4e"
    if grep -i trusty /etc/lsb-release >/dev/null 2>&1
    then
        ETH_BINARY=eth_byzantium2
        ETH_HASH="4dc3f208475f622be7c8e53bee720e14cd254c6f"
    fi
    wget -q -O /tmp/test/eth https://github.com/ethereum/cpp-ethereum/releases/download/solidityTester/$ETH_BINARY
    test "$(shasum /tmp/test/eth)" = "$ETH_HASH  /tmp/test/eth"
    sync
    chmod +x /tmp/test/eth
    sync # Otherwise we might get a "text file busy" error
    ETH_PATH="/tmp/test/eth"
fi

# This trailing ampersand directs the shell to run the command in the background,
# that is, it is forked and run in a separate sub-shell, as a job,
# asynchronously. The shell will immediately return the return status of 0 for
# true and continue as normal, either processing further commands in a script
# or returning the cursor focus back to the user in a Linux terminal.
$ETH_PATH --test -d /tmp/test &
ETH_PID=$!

# Wait until the IPC endpoint is available.  That won't be available instantly.
# The node needs to get a little way into its startup sequence before the IPC
# is available and is ready for the unit-tests to start talking to it.
while [ ! -S /tmp/test/geth.ipc ]; do sleep 2; done
echo "--> IPC available."
sleep 2
# And then run the Solidity unit-tests (once without optimization, once with),
# pointing to that IPC endpoint.
echo "--> Running tests without optimizer..."
  "$REPO_ROOT"/build/test/soltest --show-progress $testargs_no_opt -- --ipcpath /tmp/test/geth.ipc && \
  echo "--> Running tests WITH optimizer..." && \
  "$REPO_ROOT"/build/test/soltest --show-progress $testargs_opt -- --optimize --ipcpath /tmp/test/geth.ipc
ERROR_CODE=$?
pkill "$ETH_PID" || true
sleep 4
pgrep "$ETH_PID" && pkill -9 "$ETH_PID" || true
exit $ERROR_CODE
