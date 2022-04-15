// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.12;

import {XConsole} from "./utils/Console.sol";
import {DSTest} from "@ds/test.sol";
import {ERCIDK} from "../ERCIDK.sol";
import "../interfaces/Base64.sol";
import "@std/stdlib.sol";
import {Vm} from "@std/Vm.sol";

contract ERCIDKTest is DSTest, stdCheats {
    using stdStorage for StdStorage;
    XConsole console = new XConsole();

    /// @dev Use forge-std Vm logic
    Vm public constant vm = Vm(HEVM_ADDRESS);
    StdStorage public stdStore;

    ERCIDK public ercIDK;
    Base64 public base64;

    function setUp() public {
        base64 = new Base64();
        ercIDK = new ERCIDK("GM", "GN", base64);
    }

    function testMintTo() public {
        for (uint256 i = 0; i < 10000; ++i) {
        ercIDK.mintTo(address(1));
        }
    }

    function testFailMaxSupplyReach() public {
        uint256 slot = stdStore
            .target(address(ercIDK))
            .sig("currentTokenId()")
            .find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCurrentTokenId = bytes32(abi.encode(10000));
        vm.store(address(ercIDK), loc, mockedCurrentTokenId);
        ercIDK.mintTo(address(1));
    }

    function testFailMintToZeroAddress() public {
        ercIDK.mintTo(address(0));
    }

    function testBalanceIncremented() public {
        ercIDK.mintTo(address(1));
    }

    function testSafeContractReceiver() public {
        Receiver receiver = new Receiver();
        ercIDK.mintTo(address(receiver));
        uint256 slotBalance = stdStore
            .target(address(ercIDK))
            .sig(ercIDK.balanceOf.selector)
            .with_key(address(receiver))
            .find();
    }

    function testFailUnsafeContractReceiver() public {
        vm.etch(address(1), bytes("mock code"));
        ercIDK.mintTo(address(1));
    }

    function testTransfer() public {
        ercIDK.mintTo(address(1));
        vm.startPrank(address(1));

        ercIDK._transfer(address(2), uint256(0));
    }

    function testFailTransfer() public {
        ercIDK.mintTo(address(1));
        ercIDK._transfer(address(2), uint256(0));
    }

    function testFailPrepayGas() public {
        ercIDK.prepayGas(uint256(10001));
    }

    function testPrepayGas() public {
        ercIDK.prepayGas(uint256(10000));
        ercIDK.mintTo(address(1));
    }

}

contract Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 id,
        bytes calldata data
    ) external returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
