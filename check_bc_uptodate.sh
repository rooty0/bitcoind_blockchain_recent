#!/usr/bin/env bash

# Mac users! Make sure you have file "~/Library/Application Support/Bitcoin/bitcoin.conf" created
# and the content below is in the file
#   rpcuser=user
#   rpcpassword=secret
#   rpcport=port_if_not_default
#   rpcconnect=ip

###########################

#  (!) There is no way for checking whether syncing is done, simply because it isn't known.
#
#  Technically a client is always syncing: there is no real difference between "having all blocks" and "not having all blocks" - it always has all blocks that it knows about, and doesn't know whether there are blocks which it misses.
#
#  What the GUI shows you is a guess. It checks the age of the last known block, and if it is (IIRC) more than 90 minutes ago, it assumes it's out of sync. This is usually a good indicator, but it will rarely yet certainly randomly fail from time to time.
#
#  The core code has another heuristic built-in, which uses block heights reported by other nodes (without verifying that information in any way, so it's easily cheated). This information is used to determine whether it should optimize cache behaviour for many fast operations, or reliability. It's not exposed directly either, but the getwork() and getblocktemplate() RPCs will fail in this mode.
#
#  The implementation below is simply takes data from http://blockchain.info/q/getblockcount and compares it to the existing data from bitcoind

if ! bitcoin-cli uptime >/dev/null
then
  echo "$(tput setaf 1)Looks like configuration of bitcoin-cli is wrong or bitcoind is down or warming up. Fix it first$(tput sgr 0)"
  exit 1
fi

blockCount=$(bitcoin-cli getblockcount)
blockChain=$(curl -s https://blockchain.info/q/getblockcount)
blockDiff=$((blockChain - blockCount))

echo -n "Blockchain is "
if [[ $blockDiff == 0 ]]
then
    echo "$(tput bold setaf 2)UP TO DATE$(tput sgr 0)"
else
    echo "$(tput setaf 1)$blockDiff$(tput sgr 0) blocks behind"
fi

echo Bitcoin blocks: "$(tput bold)${blockCount}$(tput sgr 0)/${blockChain}" \
  synced "$(awk "BEGIN { pc=100*${blockCount}/${blockChain}; i=int(pc); print (pc-i<0.5)?i:i+1 }")%"

