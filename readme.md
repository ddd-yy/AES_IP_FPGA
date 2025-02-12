# AES_IP_FPGA

## Project Introduction

AES_IP_FPGA is an open-source project focused on designing and implementing an efficient AES-128 encryption IP core suitable for FPGA platforms. This project utilizes Verilog for programming, employs a pipeline structure to enhance data processing efficiency, and defines custom IP interfaces for flexible integration with other FPGA components.

## Project Goals

- Implement an efficient AES-128 encryption IP core.
- Ensure encrypted data can be completely recovered through software decryption.
- Design a pipeline structure to improve data processing speed.
- Define custom IP interfaces for easy integration on FPGA platforms.

## Project Structure

- `AES_IP_FPGA/`
  - `code/` _Stores the project's Verilog code_
  - `ipaes/` _Vivado IP project containing the implementation of the AES encryption core_
  - `system_aes/` _The entire SOC project, integrating the AES IP core and performing system_ verification
  - `testAES.py` _Python script for verifying the AES algorithm's encryption results on the_ software side
  - `testEncryption.txt` _Contains plaintext and ciphertext information for verification_

## Main Work

### AES Encryption IP Core Design

- **Implementation of AES-128 Algorithm**: The AES-128 encryption algorithm is implemented using Verilog, ensuring the security and reliability of the algorithm.
- **Pipeline Structure**: A pipeline structure is adopted to improve overall data processing speed by breaking down the encryption process into multiple stages, each processing data in parallel.

### IP Interface Definition

- **Custom IP Interface**: A custom IP interface is designed to allow the AES IP core to integrate flexibly with other components on the FPGA platform, enhancing the system's scalability and flexibility.

### System Integration

- **Integration in SOC Environment**: The AES IP core is integrated into the SOC environment and synthesized and implemented through Vivado, ensuring the IP core's performance and stability in the actual hardware environment.
- **System Verification**: A small-scale SOC system is built for verification to ensure the correctness and effectiveness of the AES IP core within the system.

### Software Verification

- **Python Script Verification**: Python scripts are written to verify the AES encryption results, simulating the encryption process through software to ensure the correctness and consistency of the encryption results.

### Performance Optimization

- **Resource Utilization Optimization**: The design is optimized based on Vivado's synthesis report to improve FPGA resource utilization, achieving the best balance between cost-effectiveness and performance.
- **Performance Evaluation**: Performance evaluation is conducted to ensure that the AES IP core meets performance requirements while also having good resource utilization efficiency.

## Usage Instructions

### Simulation Verification

- **Vivado Simulation**: Open the project file in the `system_aes` directory in Vivado and run the simulation to verify the correctness of the AES encryption algorithm. During the simulation, you can observe the various stages of the AES encryption algorithm and the final encryption results.

### Software Verification

- **Running Python Scripts**: Run the `testAES.py` script to verify whether the AES encryption results are correct. The script simulates the AES encryption process, generates encryption results, and compares them with the hardware encryption results to verify the algorithm's correctness.

### Resource Optimization

- **Vivado Synthesis Report**: Analyze the resource utilization of the AES IP core, including LUTs, FFs, BRAMs, etc., based on Vivado's synthesis report.
- **Design Optimization**: Optimize the design based on the results of the synthesis report to improve resource utilization and performance. Optimizations may include modifying algorithm implementations and adjusting pipeline structures.

## Contribution Guide

Contributions to this project are welcome. You can submit bug reports, feature requests, or directly submit code changes. When submitting code, please ensure that you follow the project's coding style and provide corresponding test cases.

## Copyright Notice

This project is licensed under the MIT License. For details, see the LICENSE file. Copyright (c) DongYu 2025.1. All rights reserved.
