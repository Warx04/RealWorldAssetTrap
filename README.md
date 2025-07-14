# 🏠 Real World Asset NFT Minting Trap

A fully on-chain automation system for minting NFTs that represent real-world assets (RWA) using Drosera Traps. This project allows users to register and tokenize their physical assets by submitting IPFS-based metadata and letting the trap validate and mint NFTs autonomously.

## ⚙️ How It Works

1. User uploads RWA metadata to IPFS.
2. Calls `setPending()` to register the intent.
3. Drosera Trap runs `collect()` and validates.
4. If valid, `respond()` triggers NFT minting.

## 📦 Project Structure

- `contracts/`: `Trap.sol`, `RWAResponse.sol`
- `script/`: `Deploy.s.sol`
- `test/`: unit tests using Forge
- `.env`: contains RPC + private key

## 🚀 Deployment

```bash
forge build
forge script script/Deploy.s.sol --broadcast --rpc-url $HOODI_RPC --private-key $PK
drosera apply
