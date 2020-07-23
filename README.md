# bitcoind_blockchain_recent
Check if the block chain is up to date with bitcoind

See content of **check_bc_uptodate.sh** for more details

## Sample output

![sampleone](https://github.com/rooty0/bitcoind_blockchain_recent/blob/master/sample1.png?raw=true)

## Dependencies

Make sure [bitcoin-cli](https://bitcoin.org/en/download) is installed and configured

## FYI

If you see following error:
```
Looks like configuration of bitcoin-cli is wrong or bitcoind is down or warming up. Fix it first
```
Make sure your bitcoind:
- Is up and running and it's API port accessible from your network
- Is warmed up. When you just start the daemon, you need to wait a few minutes before API port becomes reachable

There is no way for checking whether syncing is done, simply because it isn't known.

Technically a client is always syncing: there is no real difference between "having all blocks" and "not having all blocks" - it always has all blocks that it knows about, and doesn't know whether there are blocks which it misses.

What the GUI shows you is a guess. It checks the age of the last known block, and if it is (IIRC) more than 90 minutes ago, it assumes it's out of sync. This is usually a good indicator, but it will rarely yet certainly randomly fail from time to time.

The core code has another heuristic built-in, which uses block heights reported by other nodes (without verifying that information in any way, so it's easily cheated). This information is used to determine whether it should optimize cache behaviour for many fast operations, or reliability. It's not exposed directly either, but the getwork() and getblocktemplate() RPCs will fail in this mode.

The implementation below is simply takes data from http://blockchain.info/q/getblockcount and compares it to the existing data from bitcoind
