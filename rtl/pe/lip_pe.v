`timescale 1ns/1ps

// ============================================================================
// Local Interaction Processor (LIP)
// Processing Element
// ============================================================================

module lip_pe (

    input clk,

    input [15:0] nw,
    input [15:0] n,
    input [15:0] ne,

    input [15:0] w,
    input [15:0] self,
    input [15:0] e,

    input [15:0] sw,
    input [15:0] s,
    input [15:0] se,

    input [8:0] se_mask,

    input [2:0] opcode,

    input [15:0] threshold,

    output reg [15:0] out

);

// ============================================================
// Internal Signals
// ============================================================

wire [15:0] min_val;

wire [15:0] max_val;

wire uniformity;

wire roughness;

// ============================================================
// Min / Max Engine
// ============================================================

minmax_engine mm (

    .nw(nw),
    .n(n),
    .ne(ne),

    .w(w),
    .self(self),
    .e(e),

    .sw(sw),
    .s(s),
    .se(se),

    .se_mask(se_mask),

    .min_val(min_val),

    .max_val(max_val)

);

// ============================================================
// Threshold Engine
// ============================================================

threshold_engine te (

    .min_val(min_val),

    .max_val(max_val),

    .threshold(threshold),

    .uniformity(uniformity),

    .roughness(roughness)

);

// ============================================================
// Opcode Selection
// ============================================================

always @(posedge clk)

begin

    case(opcode)

        // PASS

        3'b000:

            out <= self;

        // EROSION

        3'b001:

            out <= min_val;

        // DILATION

        3'b010:

            out <= max_val;

        // UNIFORMITY

        3'b101:

            out <= {15'd0, uniformity};

        // ROUGHNESS

        3'b110:

            out <= {15'd0, roughness};

        default:

            out <= 16'd0;

    endcase

end

endmodule
