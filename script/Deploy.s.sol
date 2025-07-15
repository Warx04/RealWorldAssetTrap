// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {RWAResponse} from "./mock/RWAResponse.sol";

contract DeployScript is Script {
    uint256 deployerPrivateKey;

    address constant DROSERA = 0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D;
    address constant TRAP = 0x3242C59db460E91463e4C08908E097de90b02fDA; // ✅ ganti kalau deploy trap baru

    function run() public {
        deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        RWAResponse response = new RWAResponse(DROSERA);
        response.setTrap(TRAP); // ✅ langsung set trusted trap

        console.log("RWAResponse deployed at", address(response));

        vm.stopBroadcast();
    }
}
