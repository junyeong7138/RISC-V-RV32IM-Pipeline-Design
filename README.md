# RISC-V RV32IM 5-Stage Pipelined CPU

A 5-stage pipelined RV32IM CPU written in SystemVerilog — the
[RV32I pipeline](https://github.com/junyeong7138/RISC-V-RV32I-Pipeline-Design) extended with
the **M standard extension** (integer multiply/divide). Designed and verified for the CPU
Design course at Sangmyung University (2025 Fall) with Synopsys VCS.

Related repositories:
[Single-Cycle version](https://github.com/junyeong7138/RISC-V-RV32I-Single-Cycle-Design) ·
[RV32I Pipeline version](https://github.com/junyeong7138/RISC-V-RV32I-Pipeline-Design)

## Features

Everything from the RV32I pipeline (5-stage, forwarding, load-use stall, branch flush,
CSR, memory-mapped I/O, APB TBMAN/timer peripherals), plus:

- **M extension**: `MUL`, `MULH`, `MULHSU`, `MULHU`, `DIV`, `DIVU`, `REM`, `REMU`
- Extended ALU decoder (`funct7 = 0000001` R-type encodings) and ALU with
  multiply/divide datapaths

## Architecture

**ALU internals with the M-extension multiply/divide hardware:**

![ALU with M extension](hardware/source/5_alu_internal_muldiv_m_extension.png)

**System top** — CPU core + dual-port memory + address decoder + APB peripherals:

![System top](hardware/source/1_system_top_cpu_memory_peripherals.png)

**Pipelined datapath** — pipeline registers, hazard unit, branch logic, tohost CSR:

![Datapath](hardware/source/4_pipeline_datapath_5stage_hazard.png)

<details>
<summary>More diagrams (CPU core, instruction decoder, testbench)</summary>

![CPU core](hardware/source/2_cpu_core_controller_datapath.png)
![Decoder](hardware/source/3_instruction_decoder_control_signals.png)
![Testbench](hardware/source/0_simulation_testbench.png)

</details>

## Verification

| Directory | Contents |
|---|---|
| `hardware/12.RV32IM_isa_tests` | RISC-V ISA suite including the M-extension tests (`mul`, `div`, `rem`, …) |
| `hardware/22.RV32IM_c_tests` | C tests built with the RISC-V GNU toolchain |
| `hardware/32.RV32IM_tbman_tests` | TBMAN peripheral tests (printf over testbench manager) |
| `hardware/34.RV32IM_timer_tests` | Timer peripheral tests + Dhrystone |

Pass/fail is reported through the `tohost` CSR (0x51e), watched by the testbench via
hierarchical paths in `mem_path.vh`.

### Running (Synopsys VCS + Verdi + riscv64-unknown-elf toolchain required)

```sh
cd software/riscv-isa-tests && make          # build test programs

cd hardware/12.RV32IM_isa_tests/sim/func_sim
make run test=all                            # full ISA suite (incl. mul/div)
make verdi                                   # inspect waveforms (FSDB)
```

The RTL lives in `hardware/source/pipeline_async/rev_RV32IM/`; each test environment's
`run.f` pins the compiled file list.

## Acknowledgements

- Course framework based in part on UC Berkeley's EECS151/251A FPGA project
- Reference: Harris & Harris, *Digital Design and Computer Architecture: RISC-V Edition*
