`timescale 1ns/1ps

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

wire [15:0] m_nw;
wire [15:0] m_n;
wire [15:0] m_ne;

wire [15:0] m_w;
wire [15:0] m_self;
wire [15:0] m_e;

wire [15:0] m_sw;
wire [15:0] m_s;
wire [15:0] m_se;

wire [15:0] min_val;
wire [15:0] max_val;

wire uniformity;
wire roughness;

se_mask sm (

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

    .m_nw(m_nw),
    .m_n(m_n),
    .m_ne(m_ne),

    .m_w(m_w),
    .m_self(m_self),
    .m_e(m_e),

    .m_sw(m_sw),
    .m_s(m_s),
    .m_se(m_se)

);

minmax_engine mm (

    .nw(m_nw),
    .n(m_n),
    .ne(m_ne),

    .w(m_w),
    .self(m_self),
    .e(m_e),

    .sw(m_sw),
    .s(m_s),
    .se(m_se),

    .min_val(min_val),
    .max_val(max_val)

);

threshold_engine te (

    .min_val(min_val),
    .max_val(max_val),

    .threshold(threshold),

    .uniformity(uniformity),
    .roughness(roughness)

);

always @(posedge clk) begin

    case(opcode)

        3'b000: out <= self;

        3'b001: out <= min_val;

        3'b010: out <= max_val;

        3'b101: out <= {15'b0,uniformity};

        3'b110: out <= {15'b0,roughness};

        default: out <= 16'd0;

    endcase

end

endmodule
