# Wallet-Builder
This script makes building binary wallets easy, just change a few values and let it run.

Tested only under Ubuntu Linux 16.04 64bit, use at your own risk!
I assume that you have installed all needed system packages for compiling. Look at doc/build-unix.md and doc/build-windows.md for these dependencies!

Modify the script and change the following lines to your needs:

```
GIT="https://github.com/UCCNetwork/ucc.git" # this is the git source from the wallet
COINNAME="ucc" # the binary name
NCPU=2 # how much cpu use for compiling
OSX_SDK=10.11 #which version to use; look in depends/hosts/darwin.mk which version should be used
```

These lines represent the platforms to be built:
```
SYSTEMS=(i686-w64-mingw32 x86_64-w64-mingw32 i686-pc-linux-gnu x86_64-unknown-linux-gnu x86_64-apple-darwin11 arm-linux-gnueabihf aarch64-linux-gnu)
FOLDERS=(WIN32 WIN64 LIN32 LIN64 MACOS ARM AARCH64)
MACDIR=MACOS
```
For MACOS cross-compiling you may need to change the x86_64-apple-darwin11 to another value like x86_64-apple-darwin14; look in depends/README.md for that value.



Happy compiling!



Donations are welcome:
```
BTC: 1NEv7hoTMZrYHk7WeHQRmshxZQbKadGj9x
BCH: qqcccgns5uxdpny5aea72hryfpntnaagjqrespwdj0
DASH: Xnzed2r417hGfgLG4DqCCTSNPci6FbvgHW
ETH: 0x5D0F170eBc8caC2db4F9477E26A4858142abDEEB
```
