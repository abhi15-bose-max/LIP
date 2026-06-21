`timescale 1ns/1ps

module tb_top;

parameter SIZE = 8;

parameter PIXEL_BITS = 16;

localparam FRAME_BITS = SIZE*SIZE*PIXEL_BITS;

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

always #5 clk = ~clk;

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

        $write("%4d ",

        frame_out[idx*PIXEL_BITS +: PIXEL_BITS]);

    end

    $display("");

end

$display("-----------------------------");

end

endtask

initial

begin

$dumpfile("lip.vcd");

$dumpvars(0,tb_top);

clk=0;

// ===================================================
// Build a simple diagonal image
// ===================================================

frame_in=0;

frame_in[0*16 +:16]=1000;

frame_in[9*16 +:16]=1000;

frame_in[18*16 +:16]=1000;

frame_in[27*16 +:16]=1000;

frame_in[36*16 +:16]=1000;

frame_in[45*16 +:16]=1000;

frame_in[54*16 +:16]=1000;

frame_in[63*16 +:16]=1000;

// Full mask

se_mask=9'b111111111;

threshold=16'd100;

// ===================================================
// PASS
// ===================================================

opcode=3'b000;

#10;

$display("=== PASS ===");

print_frame();

// ===================================================
// DILATION
// ===================================================

opcode=3'b010;

#10;

$display("=== DILATION ===");

print_frame();

// ===================================================
// EROSION
// ===================================================

opcode=3'b001;

#10;

$display("=== EROSION ===");

print_frame();

// ===================================================
// UNIFORMITY
// ===================================================

opcode=3'b101;

#10;

$display("=== UNIFORMITY ===");

print_frame();

// ===================================================
// ROUGHNESS
// ===================================================

opcode=3'b110;

#10;

$display("=== ROUGHNESS ===");

print_frame();

#10;

$finish;

end

endmodule
