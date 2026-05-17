// Archivo: src/CounterGas.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

contract CounterGas {
    uint16 public number;

    function setNumber(uint16 newNumber) public {
        number = newNumber;
    }

    function increment(uint8 times) public {
        require(uint256(number) + uint256(times) <= type(uint16).max, "Overflow");

        for (uint8 i = 0; i < times; i++) {
            number++;
        }
    }

    function double(uint8 a, uint8 b) public {
        uint256 total = uint256(a) * uint256(b);
        require(total <= type(uint16).max, "Overflow");
        require(uint256(number) + total <= type(uint16).max, "Overflow");

        for (uint8 i = 0; i < a; i++) {
            for (uint8 j = 0; j < b; j++) {
                number++;
            }
        }
    }

    function checkcalldata(uint256 a) public {
        // This function is empty to measure only the cost of sending the data (calldata)
    }
}