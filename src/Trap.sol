// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

interface IRWAResponse {
    function hasPending(address user) external view returns (bool);
    function getPendingMetadata(address user) external view returns (string memory);
    function mintRWA(
        string calldata metadataURI,
        string calldata assetName,
        string calldata location,
        string calldata assetType,
        string calldata legalStatus,
        uint256 marketValue
    ) external;
}

contract Trap is ITrap {
    address public constant RESPONSE_CONTRACT = 0xd22EaE6A80719D474659737c5C0F3eeB48Eb4517;

    function collect() external view returns (bytes memory) {
        address user = msg.sender;
        bool has = IRWAResponse(RESPONSE_CONTRACT).hasPending(user);
        string memory metadata = IRWAResponse(RESPONSE_CONTRACT).getPendingMetadata(user);

        string memory assetName = "YourRwaName"; // change what you want
        string memory location = "YourRWALocation"; // change what you want
        string memory assetType = "TypeRWA"; // change what you want
        string memory legalStatus = "RWALegalStatus"; // change what you want
        uint256 marketValue =  Price; // change what you want

        return abi.encode(user, has, metadata, assetName, location, assetType, legalStatus, marketValue);
    }

    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        (
            address user,
            bool hasPending,
            string memory metadataURI,
            string memory assetName,
            string memory location,
            string memory assetType,
            string memory legalStatus,
            uint256 marketValue
        ) = abi.decode(data[0], (address, bool, string, string, string, string, string, uint256));

        // ✅ Always return true to allow Drosera to trigger (even if dummy)
        if (!hasPending || bytes(metadataURI).length == 0) {
            return (true, abi.encode(
                "ipfs://Qmf..............",
                "YourRwaName", // same on top
                "YourRWALocation", // same on top
                "TypeRWA", // same on top
                "RWALegalStatus", // same on top
                Price // same on top
            ));
        }

        return (true, abi.encode(metadataURI, assetName, location, assetType, legalStatus, marketValue));
    }

    function respond(bytes calldata data) external {
        (
            string memory metadataURI,
            string memory assetName,
            string memory location,
            string memory assetType,
            string memory legalStatus,
            uint256 marketValue
        ) = abi.decode(data, (string, string, string, string, string, uint256));

        IRWAResponse(RESPONSE_CONTRACT).mintRWA(
            metadataURI,
            assetName,
            location,
            assetType,
            legalStatus,
            marketValue
        );
    }
}
