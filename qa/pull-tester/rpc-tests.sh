#!/bin/bash
set -e

CURDIR=$(cd $(dirname "$0"); pwd)
# Get BUILDDIR and REAL_BITCOIND
. "${CURDIR}/tests-config.sh"

export NAMECOINCLI=${BUILDDIR}/qa/pull-tester/run-bitcoin-cli
export NAMECOIND=${REAL_NAMECOIND}

if [ "x${EXEEXT}" = "x.exe" ]; then
  echo "Win tests currently disabled"
  exit 0
fi

#Run the tests

testScripts=(
    'wallet.py'
    'listtransactions.py'
    'mempool_resurrect_test.py'
    'txn_doublespend.py'
    'txn_doublespend.py --mineblock'
    'getchaintips.py'
    'rawtransactions.py'
    'rest.py'
    'mempool_spendcoinbase.py'
    'mempool_coinbase_spends.py'
    'httpbasics.py'
    'zapwallettxes.py'
    'proxy_test.py'
    'merkle_blocks.py'
    'signrawtransactions.py'
    'maxblocksinflight.py'
    'invalidblockrequest.py'
    'rawtransactions.py'
#    'forknotify.py'

    # auxpow tests
    'getauxblock.py'

    # name tests
    'name_expiration.py'
    'name_list.py'
    'name_multisig.py'
    'name_rawtx.py'
    'name_registration.py'
    'name_reorg.py'
    'name_scanning.py'
    'name_wallet.py'
);
if [ "x${ENABLE_BITCOIND}${ENABLE_UTILS}${ENABLE_WALLET}" = "x111" ]; then
    for (( i = 0; i < ${#testScripts[@]}; i++ ))
    do
        if [ -z "$1" ] || [ "$1" == "${testScripts[$i]}" ] || [ "$1.py" == "${testScripts[$i]}" ]
        then
            echo -e "Running testscript \033[1m${testScripts[$i]}...\033[0m"
            ${BUILDDIR}/qa/rpc-tests/${testScripts[$i]} --srcdir "${BUILDDIR}/src"
        fi
    done
else
  echo "No rpc tests to run. Wallet, utils, and bitcoind must all be enabled"
fi
