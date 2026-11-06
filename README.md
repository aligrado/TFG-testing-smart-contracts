# Mutation-Based Fuzzing for Smart Contracts: Echidna and Foundry

## Introduction

This repository contains the code developed for my Final Degree Project focused on testing Ethereum smart contracts using **mutation-based fuzzing**.

Fuzzing is a software testing technique that automatically generates inputs and executes them against a program to identify unexpected behaviours, errors, or vulnerabilities. In particular, mutation-based fuzzing uses existing inputs or sequences of function calls and modifies them through different mutation operations to explore new execution paths and increase code coverage.

The objective of this project is to explore how mutation-based fuzzing can be used to test smart contracts and to compare two tools designed for this purpose:

- **[Echidna](https://github.com/crytic/echidna):** a property-based fuzzing tool for Ethereum smart contracts. It generates and mutates sequences of transactions to check whether specified properties or assertions hold.
- **[Foundry](https://github.com/foundry-rs/foundry):** a development framework for Ethereum smart contracts that includes testing and fuzzing capabilities. It automatically generates input values to execute tests against the contracts.

The repository is divided into two main directories, corresponding to the experiments carried out with each tool:

- `pruebas-echidna/`: contains the contracts and tests developed for Echidna.
- `pruebas-foundry/`: contains the contracts and tests developed for Foundry.

## Smart Contracts and Functions

The project uses different smart contracts to explore the testing capabilities of both tools.

### Counter contract

The `Counter` contract contains the following functions:

- **`setNumber(uint256 num)`**: sets the contract's number to the value provided as input. Time complexity: O(1).
- **`increment(uint256 num, uint256 times)`**: increments the number according to the input parameters. Time complexity: O(n).
- **`double(uint256 num)`**: doubles the value provided. Time complexity: O(n²).
- **`checkcalldata(...)`**: checks the calldata passed to the contract, allowing the gas cost associated with zero and non-zero bytes to be examined.

The Counter functions are used in both functional and gas consumption tests. Functional tests check whether the implemented operations produce the expected outputs, helping to identify unexpected behaviours. Gas consumption tests use the same functions to measure the gas required for their execution and analyse how it varies depending on the input values.

Additionally, the contract includes a specific function, checkcalldata, designed to analyse the gas cost of transaction calldata. Calldata contains the function identifier and the encoded parameters passed to the contract. Its gas cost depends on its byte contents: zero bytes cost 4 gas, while non-zero bytes cost 16 gas. This function is used to investigate how different calldata contents affect gas consumption and how the fuzzing tools handle these costs.

### Reentrancy contracts

The repository also includes contracts designed to test reentrancy vulnerabilities:

- **`VulnerableBank`**: implements a bank-like contract that allows users to deposit and withdraw funds. Its withdrawal logic is vulnerable because the external transfer is performed before the user's balance is updated.
- **`MaliciousAttacker`**: interacts with the vulnerable contract to exploit the reentrancy vulnerability by repeatedly invoking the withdrawal function before the balance update is completed.

These contracts are used to check whether Echidna and Foundry can detect the vulnerability through automated testing.

## Running the Tests

### Echidna

To execute the Echidna tests, navigate to the `pruebas-echidna` directory and run the corresponding command.

For the gas consumption test, the command used is:

```bash
echidna echidna/CounterGasEchidna.sol --contract EchidnaGasCounterTest --test-mode assertion --test-limit 5000
```

The command specifies the Solidity file, the contract to test, the assertion testing mode, and a limit of 5,000 tests.

### Foundry

To execute the Foundry tests, navigate to the `pruebas-foundry` directory and run:

```bash
forge test
```

To execute the tests and display the gas consumption report, use:

```bash
forge test --gas-report
```

For further information about the tools, consult their official documentation:

- [Echidna documentation](https://github.com/crytic/echidna)
- [Foundry documentation](https://book.getfoundry.sh/)
