To create a new genesis file you also can directly generate it in the source code in chainparams.cpp:

```
// ... snip ...

#include <arith_uint256.h>

// ... snip ...

class CMainParams : public CChainParams {
public:
    CMainParams() {

        // ... snip ...

        uint32_t nTime = 1550490000; // Unixtimestamp of Genesis-Block
        uint32_t nNonce = 0; // set to other value once Block 0 is generated!
        
        if (nNonce == 0)
        {
          while (UintToArith256(genesis.GetHash()) > UintToArith256(consensus.powLimit))
          {
            nNonce++;
            if (nNonce % 1024 == 0) printf("\rnonce %08x", nNonce);
            genesis = CreateGenesisBlock(nTime, nNonce, 0x1f00ffff, 1, 0 * COIN);
          }
          printf("\ngenesis is %s\n", genesis.ToString().c_str());
        }
        else
        {
          genesis = CreateGenesisBlock(nTime, nNonce, 0x1f00ffff, 1, 0 * COIN);
        }
        
        std::cout << "Mainnet ---\n";
        std::cout << "  nonce: " << genesis.nNonce <<  "\n";
        std::cout << "   time: " << genesis.nTime << "\n";
        std::cout << "   hash: " << genesis.GetHash().ToString().c_str() << "\n";
        std::cout << "   merklehash: "  << genesis.hashMerkleRoot.ToString().c_str() << "\n";
        std::cout << std::string("Finished calculating Mainnet Genesis Block:\n");
        
        consensus.hashGenesisBlock = genesis.GetHash();

        // ... snip ...
}

// ... snip ...
```
found at https://gist.github.com/bellflower2015/6f37c3722615be755efdf0f1d465e146 and modified
