# FPGA In-Place Selection Sort System

This project implements a synthesizable SystemVerilog design to sort an 8-element array in place using selection sort. It follows a strict hardware datapath and controller architecture with RAM, registers, and FSM control logic.

## Overview

The design includes:
- A datapath module with RAM, index registers (i, j), and temporary registers (A, B).
- A controller module with an FSM based on the provided ASM chart.
- A top-level module that integrates both.
- A testbench for simulation and validation.

## Modules

### datapath.sv
- 8-element RAM used to store and sort data.
- A and B registers for comparison.
- Implements control signals: EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout, Rd.
- Outputs flags: AgtB (A > B), zi, zj (zero detection on i, j).
- RAM content is exposed for testbench inspection.

### controller.sv
- FSM to manage sorting algorithm based on selection sort pseudocode.
- Issues control signals to datapath.
- Signals completion with `done`.

### top.sv
- Instantiates datapath and controller.
- Connects testbench signals: clk, reset, s (start), done, RAM_out.

### testbench.sv
- Initializes RAM with unsorted values:
  90, 25, 60, 15, 30, 75, 45, 10
- Triggers sort and prints final RAM state.

## Simulation Instructions

1. Open the project in Vivado or another SystemVerilog simulator.
2. Compile and run the simulation using `testbench.sv`.
3. Wait for the `done` signal.
4. View printed sorted output or inspect waveform.

## Expected Output

Sorted array:
10, 15, 25, 30, 45, 60, 75, 90

## File Structure

- datapath.sv
- controller.sv
- top.sv
- testbench.sv
- README.md

## Notes

- This project was designed according to a strict architectural diagram and naming constraints.
- All signals, flags, and structures match the original FPGA sorting task specification.
