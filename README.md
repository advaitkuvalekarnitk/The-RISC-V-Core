# RISC-V Single-Cycle Core

A fully functional, 32-bit RISC-V ISA Single-Cycle processor core implemented in Verilog. This implementation successfully executes the complete RV32I base integer instruction set (37 total instructions), encompassing R, I, J, U, B, and S-type instruction formats.

---

## Architecture Overview
The core is designed using a modular approach to ensure clean data paths and straightforward control logic.



### Module Definitions
* **`Top_module.v`**: The central integration layer. It instantiates all sub-modules and handles the global interconnection. It includes a dedicated `PC + 4` adder block to facilitate link-register updates for unconditional jumps.
* **`alu.v`**: The Arithmetic Logic Unit. Performs all computational tasks (bitwise, arithmetic, comparisons). It outputs critical status flags (`zero` and `less_than`) used by the branch logic.
* **`control_unit.v`**: The "brain" of the core. It decodes instructions and generates the necessary control signals (mux selects, write enables, reset lines) to orchestrate the datapath.
* **`data_memory.v`**: A 32-bit byte-addressable RAM (1024 words deep) used for Load/Store operations.
* **`instruction_memory.v`**: A 32x1024 read-only instruction array where the program resides and the PC iterates.
* **`program_counter.v`**: Manages the instruction flow by providing the address of the next instruction, enabling sequential, branch, and jump navigation.
* **`program_counter_target.v`**: Handles PC-relative address calculations by adding the sign-extended immediate offset to the current PC.
* **`register_memory.v`**: A 32x32 register file. Includes logic to ensure `x0` is hardwired to zero.
* **`sign_extender.v`**: Standardizes all immediate values (I, S, B, U, J-type) to 32-bit formats for internal ALU operations.
* **`testbench.v`**: Provides the clock, global reset, and top-level simulation stimulus.

---

## Supported Instruction Set (RV32I)
The core supports the following 37 instructions, grouped by type:

| Category | Instructions |
| :--- | :--- |
| **Arithmetic & Logic (R)** | ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND |
| **Immediate Arithmetic (I)** | ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI |
| **Load/Store (I & S)** | LW, LH, LHU, LB, LBU, SW, SH, SB |
| **Branches (B)** | BEQ, BNE, BLT, BGE, BLTU, BGEU |
| **Jumps & U-Immediates (J & U)** | JAL, JALR, LUI, AUIPC |

---

## Simulation & Demo
The current `instruction_memory.v` contains a test program that exercises every implemented instruction type.
* **Demo:** Refer to the included `simulation.mp4` for a walk-through of the waveform execution.

## How to Simulate
1. Fork this repository and download the files locally.
2. Import all files (excluding `README.md` and `testbench.v`) into your HDL simulation software (e.g., Vivado, ModelSim, Icarus Verilog) as design sources.
3. Add `testbench.v` as the simulation source.
4. Update the instruction content in `instruction_memory.v` as needed.
5. Set the simulation runtime in your testbench, run the simulation, and add the desired signals to the waveform viewer.

---

## Future Roadmap
- [ ] Pipelining integration (5-stage)
- [ ] Hazard detection and forwarding unit
- [ ] Interrupt and exception handling
- [ ] Branch prediction algorithms
- [ ] Floating-point unit (FPU) support
- [ ] Encryption acceleration core integration
