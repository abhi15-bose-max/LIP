// ============================================================================
// Local Interaction Processor (LIP)
// Top Level
// ============================================================================
`timescale 1ns/1ps

module lip_top #

(

parameter SIZE       = 8,
parameter PIXEL_BITS = 16

)

(

input clk,

input [2:0] opcode,

input [8:0] se_mask,

input [PIXEL_BITS-1:0] threshold,

input [(SIZE*SIZE*PIXEL_BITS)-1:0] frame_in,

output [(SIZE*SIZE*PIXEL_BITS)-1:0] frame_out

);

// ============================================================
// Array
// ============================================================

lip_array #

(

.SIZE(SIZE),

.PIXEL_BITS(PIXEL_BITS)

)

u_array(

.clk(clk),

.opcode(opcode),

.se_mask(se_mask),

.threshold(threshold),

.frame_in(frame_in),

.frame_out(frame_out)

);

endmodule
