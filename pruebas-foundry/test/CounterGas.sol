// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {CounterGas} from "../src/CounterGas.sol";

contract CounterGasTest is Test {
    CounterGas public counter;


    function setUp() public {
        counter = new CounterGas();
    }

    // Gas limits
    uint256 constant MAX_GAS_SETNUMBER = 100000;
    uint256 constant MAX_GAS_INCREMENT = 50000000;
    uint256 constant MAX_GAS_DOUBLE = 100000000;
    

    function testGasSetNumber(uint16 x) public {
        uint256 gasStart = gasleft();
        counter.setNumber(x);
        uint256 gasUsed = gasStart - gasleft();

        // Verify gas used doesnt exceed gas limit
        assertLe(gasUsed, MAX_GAS_SETNUMBER);
    }

    function testGasIncrement(uint16 x, uint8 times) public {
        counter.setNumber(x);

        //Overflow
        vm.assume(uint256(x) + uint256(times) <= type(uint16).max);

        uint256 gasStart = gasleft();
        counter.increment(times);
        uint256 gasUsed = gasStart - gasleft();

        // Verify gas used doesnt exceed gas limitS
        assertLe(gasUsed, MAX_GAS_INCREMENT);
    }

    function testGasDouble(uint16 x, uint8 a, uint8 b) public{
        counter.setNumber(x);

        uint256 mult = uint256(a) * uint256(b);

        //Overflow
        vm.assume(mult <= type(uint16).max);
        vm.assume(uint256(x) + mult <= type(uint16).max);

        uint256 gasStart = gasleft();
        counter.double(a, b);
        uint gasUsed = gasStart - gasleft();

        assertLe(gasUsed, MAX_GAS_DOUBLE);
    }

    function testGasCallData() public {
        // warm-up
        counter.checkcalldata(0);

        uint256 gas1 = gasleft();
        counter.checkcalldata(0);
        uint256 gas2 = gasleft();

        counter.checkcalldata(1);
        uint256 gas3 = gasleft();

        uint256 gasUsed1 = gas1 - gas2;
        uint256 gasUsed2 = gas2 - gas3;

        // First call should use less gas than the second one
        assertEq(gasUsed2, gasUsed1);
    }
    
}