// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RWAResponse is ERC721URIStorage, Ownable {
    address public drosera;
    address public trustedTrap; // ✅ Trap yang diizinkan memanggil mintRWA()
    uint256 public nextTokenId;

    mapping(address => string) public pendingSubmissions;

    struct RWASpec {
        string assetName;
        string location;
        string assetType;
        string legalStatus;
        uint256 marketValue;
    }

    mapping(uint256 => RWASpec) public rwaDetails;

    constructor(address _drosera) ERC721("RealWorldAssetNFT", "RWANFT") Ownable(msg.sender) {
        drosera = _drosera;
    }

    // ✅ Diset sekali oleh owner setelah Trap dideploy
    function setTrap(address _trap) external onlyOwner {
        trustedTrap = _trap;
    }

    function submitAssetMetadata(string calldata metadataURI) external {
        pendingSubmissions[msg.sender] = metadataURI;
    }

    function getPendingMetadata(address user) external view returns (string memory) {
        return pendingSubmissions[user];
    }

    function hasPending(address user) external view returns (bool) {
        return bytes(pendingSubmissions[user]).length > 0;
    }

    function mintRWA(
        string calldata metadataURI,
        string calldata assetName,
        string calldata location,
        string calldata assetType,
        string calldata legalStatus,
        uint256 marketValue
    ) external {
        require(msg.sender == trustedTrap, "Only trap can call");

        address owner = tx.origin; // User yang submit metadata
        uint256 tokenId = nextTokenId++;
        _mint(owner, tokenId);
        _setTokenURI(tokenId, metadataURI);

        rwaDetails[tokenId] = RWASpec(
            assetName,
            location,
            assetType,
            legalStatus,
            marketValue
        );

        delete pendingSubmissions[owner];
    }

    function adminMint(
        address to,
        string calldata metadataURI,
        string calldata assetName,
        string calldata location,
        string calldata assetType,
        string calldata legalStatus,
        uint256 marketValue
    ) external onlyOwner {
        uint256 tokenId = nextTokenId++;
        _mint(to, tokenId);
        _setTokenURI(tokenId, metadataURI);

        rwaDetails[tokenId] = RWASpec(
            assetName,
            location,
            assetType,
            legalStatus,
            marketValue
        );
    }
}
