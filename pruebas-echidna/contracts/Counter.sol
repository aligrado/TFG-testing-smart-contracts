// Archivo: src/Counter.sol
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.34;

contract Counter {
    uint16 public number;

    
    function setNumber(uint16 newNumber) public virtual {
        number = newNumber;
    }
    
    function increment(uint16 times) public virtual {
        require(uint256(number) + uint256(times) <= type(uint16).max, "Overflow");

        for (uint16 i = 0; i < times; i++) {
            number++;
        }
    }

    function double(uint16 a, uint16 b) public virtual{
        uint256 total = uint256(a) * uint256(b);
        require(total <= type(uint16).max, "Overflow");
        require(number + total <= type(uint16).max, "Overflow");

        for (uint16 i = 0; i < a; i++) {
            for (uint16 j = 0; j < b; j++) {
                number++;
            }
        }
    }

    function checkcalldata(uint256 a) public virtual{
        // Esta función está vacía para medir solo el coste de enviar los datos (calldata)
    }
}