`timescale 1ns/1ps

module se_mask (

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

    output [15:0] m_nw,
    output [15:0] m_n,
    output [15:0] m_ne,

    output [15:0] m_w,
    output [15:0] m_self,
    output [15:0] m_e,

    output [15:0] m_sw,
    output [15:0] m_s,
    output [15:0] m_se

);

assign m_nw   = se_mask[8] ? nw   : 16'hFFFF;
assign m_n    = se_mask[7] ? n    : 16'hFFFF;
assign m_ne   = se_mask[6] ? ne   : 16'hFFFF;

assign m_w    = se_mask[5] ? w    : 16'hFFFF;
assign m_self = se_mask[4] ? self : 16'hFFFF;
assign m_e    = se_mask[3] ? e    : 16'hFFFF;

assign m_sw   = se_mask[2] ? sw   : 16'hFFFF;
assign m_s    = se_mask[1] ? s    : 16'hFFFF;
assign m_se   = se_mask[0] ? se   : 16'hFFFF;

endmodule
