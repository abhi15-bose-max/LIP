`timescale 1ns/1ps

module tb_masks;

parameter SIZE=8;

parameter PIXEL_BITS=16;

localparam FRAME_BITS=SIZE*SIZE*PIXEL_BITS;

reg clk;

reg [2:0] opcode;

reg [8:0] se_mask;

reg [15:0] threshold;

reg [FRAME_BITS-1:0] frame_in;

wire [FRAME_BITS-1:0] frame_out;

lip_top #

(

.SIZE(SIZE),

.PIXEL_BITS(PIXEL_BITS)

)

uut(

.clk(clk),

.opcode(opcode),

.se_mask(se_mask),

.threshold(threshold),

.frame_in(frame_in),

.frame_out(frame_out)

);

always #5 clk=~clk;

integer r;

integer c;

integer idx;

task print_frame;

begin

$display("");

for(r=0;r<SIZE;r=r+1)

begin

    for(c=0;c<SIZE;c=c+1)

    begin

        idx=r*SIZE+c;

        $write("%5d ",

        frame_out[idx*16 +:16]);

    end

    $display("");

end

$display("--------------------------------");

end

endtask

initial

begin

$dumpfile("masks.vcd");

$dumpvars(0,tb_masks);

clk=0;

opcode=3'b010;

threshold=16'd100;

frame_in=0;

// center pixel

frame_in[27*16 +:16]=1000;

// =====================================================
// FULL
// =====================================================

$display("=== FULL ===");

se_mask=9'b111111111;

#20;

print_frame();

// =====================================================
// CROSS
// =====================================================

$display("=== CROSS ===");

se_mask=9'b010111010;

#20;

print_frame();

// =====================================================
// X
// =====================================================

$display("=== X ===");

se_mask=9'b101010101;

#20;

print_frame();

// =====================================================
// HORIZONTAL
// =====================================================

$display("=== HORIZONTAL ===");

se_mask=9'b000111000;

#20;

print_frame();

// =====================================================
// VERTICAL
// =====================================================

$display("=== VERTICAL ===");

se_mask=9'b010010010;

#20;

print_frame();

#20;

$finish;

end

endmodule
