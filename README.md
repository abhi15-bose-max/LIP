# Local Interaction Processor (LIP)

A lightweight FPGA-first image morphology accelerator built around local neighborhood interactions.

LIP performs useful computations using only immediate neighbours and tiny arithmetic operations.

The architecture avoids global memory-heavy algorithms and instead focuses on deterministic, scalable local processing.

---

## Core Idea

Each Processing Element (PE) only sees a 3×3 neighbourhood.

```

NW N NE

W C E

SW S SE

```

Every PE independently performs local operations.

Multiple PEs are tiled together into an NxN array.

---

## Supported Operations

| Opcode | Operation | Description |
|-------|-----------|-------------|
|000|Pass|Output center pixel|
|001|Erosion|Local minimum|
|010|Dilation|Local maximum|
|011|Opening|Erosion → Dilation|
|100|Closing|Dilation → Erosion|
|101|Uniformity|Detect smooth regions|
|110|Roughness|Detect irregular regions|

---

## Structuring Element Masks

LIP supports dynamic 3×3 masks.

Examples:

### Full

111

111

111

### Cross

010

111

010

### X

101

010

101

### Horizontal

000

111

000

### Vertical

010

010

010

Any arbitrary 3×3 mask is supported.

---

## Uniformity

Measures local smoothness.

```

uniformity = (max-min) <= threshold

```

Applications:

- background detection
- healthy regions
- stable surfaces

---

## Roughness

Measures local variation.

```

roughness = (max-min) > threshold

```

Applications:

- anomaly detection
- crack detection
- texture changes
- defect localization

---

## Repository Structure

```

LIP/

rtl/
├── pe/
├── array/
└── top/

tb/
├── tb_top.v
├── tb_master.v
├── tb_masks.v
└── tb_open_close.v

```

---

## Running Simulations

### Master Demo

```bash
iverilog \
-o master_sim \
rtl/pe/*.v \
rtl/array/*.v \
rtl/top/*.v \
tb/tb_master.v

vvp master_sim
```

### Structuring Element Demo

```bash
iverilog \
-o masks_sim \
rtl/pe/*.v \
rtl/array/*.v \
rtl/top/*.v \
tb/tb_masks.v

vvp masks_sim
```

### Opening / Closing Demo

```bash
iverilog \
-o oc_sim \
rtl/pe/*.v \
rtl/array/*.v \
rtl/top/*.v \
tb/tb_open_close.v

vvp oc_sim
```

---

## Current Status

LIP V1

Implemented:

- 16-bit grayscale processing
- Dynamic structuring elements
- NxN PE arrays
- Erosion
- Dilation
- Opening
- Closing
- Uniformity
- Roughness

Next:

- Yosys synthesis
- FPGA implementation
- OpenLane ASIC flow

---

## Philosophy

If a problem can be solved using only local neighbourhood interactions and tiny arithmetic operations, it belongs on this chip.

```

