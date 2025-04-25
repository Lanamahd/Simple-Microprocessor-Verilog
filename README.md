# Verilog-Based Microprocessor System

This project implements a basic **microprocessor system** using Verilog, consisting of an **Arithmetic Logic Unit (ALU)** and a **Register File**. It was developed for the *Advanced Digital Systems Design* course (ENCS3310).

---

## Project Structure

- `alu.v`: Implements arithmetic and logical operations based on a 6-bit opcode.
- `reg_file.v`: Implements a 32x32-bit fast register file with read/write logic.
- `mp_top.v`: Integrates the ALU and Register File into a functioning microprocessor.
- `alu_tb.v`, `regFile_tb.v`: Testbenches for verifying the correctness of the ALU and Register File respectively.
- `report.pdf`: Full documentation, diagrams, test results, and implementation discussion.

---

## Features

### Arithmetic Logic Unit (ALU)
- Supports operations: `ADD`, `SUB`, `ABS`, `INVERSE`, `MAX`, `MIN`, `AVG`, `NOT`, `AND`, `OR`, `XOR`.
- Operates on two 32-bit signed inputs.
- Controlled via a 6-bit opcode.

### Register File
- Holds 32 registers, each 32 bits wide.
- Supports dual-read and single-write operations.
- Controlled with an enable signal `valid_opcode` and synchronized using a clock signal.

### Simple Microprocessor Integration
- Instruction format: 32-bit wide with defined opcode, source registers, and destination register.
- Executes instructions on the rising edge of the clock.
- Writes results back into the Register File for further operations.

---

## How to Run

### Prerequisites
- Any Verilog simulation tool such as **Active-HDL** by Aldec.

### Simulation Steps
1. Compile all `.v` files:
    ```bash
   iverilog -o processor_tb alu.v reg_file.v mp_top.v alu_tb.v regFile_tb.v

3.   Run simulation:
      ```bash
     vvp processor_tb

 ## Testing

 Testbenches:
- alu_tb.v tests all supported operations with predefined input/output expectations.

- regFile_tb.v tests read/write logic and control signals.

Each instruction is checked against expected values using functions and conditions to validate correctness.

## Conclusion

This project successfully demonstrates the implementation of a simple microprocessor using Verilog, composed of two core components: the Arithmetic Logic Unit (ALU) and the Register File. The design emphasizes modularity, synchronization using clock edges, and opcode-based instruction execution. Through comprehensive testing using dedicated testbenches, the microprocessor was validated for correctness across various scenarios.

