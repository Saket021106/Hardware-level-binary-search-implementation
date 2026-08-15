# Hardware-Level Binary Search Implementation

## Overview
This repository contains a hardware-level implementation of the binary search algorithm written in Verilog/SystemVerilog. The design executes the search operation sequentially across clock cycles, making it suitable for integration into digital circuits and embedded hardware systems where efficient data searching is required.

## Features
* **Sequential Execution:** Utilizes a clock-driven approach to divide the search space, evaluating one midpoint per clock cycle.
* **Handshaking Signals:** Includes `start` and `done` signals to easily interface with other hardware modules or state machines.
* **Synchronous Design:** All internal state changes (adjusting left and right bounds) occur on the positive edge of the clock.
* **Configurable Data:** Currently designed to search through an array of eight 32-bit signed integers, which can be scaled as needed.

## Repository Structure
* `design.sv`: The core Verilog module (`binary_search_seq`) containing the binary search logic.
* `testbench.sv`: The simulation testbench used to verify the functionality of the search module.
* `waveform.pdf`: Visual representation of the simulation waveforms, detailing clock cycles, inputs, and the state of output flags.
* `result.pdf`: Documentation of the simulation results and verification tests.
* `README.md`: Project documentation.

## Module Interface

### Inputs
| Port | Width | Description |
| :--- | :--- | :--- |
| `clk` | 1 bit | System clock signal. |
| `rst` | 1 bit | Active-high reset signal. Initializes all internal registers. |
| `start` | 1 bit | Control signal to initiate the search operation. |
| `in` | 32 bits x 8 | The sorted input array of 32-bit values to be searched. |
| `key` | 32 bits | The target value to search for within the input array. |

### Outputs
| Port | Width | Description |
| :--- | :--- | :--- |
| `out` | 1 bit | Goes high (1) if the `key` is found in the array, otherwise remains low (0). |
| `done` | 1 bit | Goes high (1) to indicate that the search operation has concluded. |

## How It Works
1. **Reset State:** When `rst` is asserted, the internal bounds (`left` and `right`) are initialized to the start and end indices of the array (0 and 7, respectively). The `out` and `done` flags are cleared.
2. **Initiation:** The search begins when the `start` signal is high and `done` is low.
3. **Search Logic:** On each clock cycle, the module calculates the `mid` index. 
    * If `in[mid]` matches the `key`, the `out` and `done` flags are asserted.
    * If the `key` is greater than `in[mid]`, the `left` bound is shifted to `mid + 1`.
    * If the `key` is less than `in[mid]`, the `right` bound is shifted to `mid - 1`.
4. **Termination:** If the `left` bound exceeds the `right` bound without a match, the `done` flag is asserted, and `out` remains low, indicating the key is not present. To perform a new search, `start` must be toggled low and then high again to reset the internal pointers.

## Simulation
To simulate this design, you can use any standard Verilog simulator (such as ModelSim, Vivado, or EDA Playground). 
1. Compile both `design.sv` and `testbench.sv`.
2. Run the simulation.
3. Observe the generated waveforms to verify the timing of the `done` and `out` signals relative to the `start` signal and clock edges. You can refer to `waveform.pdf` for the expected output behavior.
