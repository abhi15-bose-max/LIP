`timescale 1ns/1ps

module tb_master;

parameter SIZE=8;

parameter PIXEL_BITS=16;

localparam FRAME_BITS=SIZE*SIZE*PIXEL_BITS;

// ============================================================
// DUT
// ============================================================

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

// ============================================================

always #5 clk=~clk;

// ============================================================

integer r;

integer c;

integer idx;

// ============================================================

task print_frame;

begin

$display("");

for(r=0;r<SIZE;r=r+1)

begin

    for(c=0;c<SIZE;c=c+1)

    begin

        idx=r*SIZE+c;

        $write("%5d ",

        frame_out[idx*PIXEL_BITS +: PIXEL_BITS]);

    end

    $display("");

end

$display("----------------------------------------");

end

endtask

// ============================================================

task load_image;

begin

frame_in=0;

// row 1

frame_in[ 9*16 +:16]=50;
frame_in[10*16 +:16]=100;
frame_in[11*16 +:16]=200;
frame_in[12*16 +:16]=200;
frame_in[13*16 +:16]=100;
frame_in[14*16 +:16]=50;

// row 2

frame_in[17*16 +:16]=100;
frame_in[18*16 +:16]=400;
frame_in[19*16 +:16]=700;
frame_in[20*16 +:16]=700;
frame_in[21*16 +:16]=400;
frame_in[22*16 +:16]=100;

// row 3

frame_in[25*16 +:16]=200;
frame_in[26*16 +:16]=700;
frame_in[27*16 +:16]=1000;
frame_in[28*16 +:16]=1000;
frame_in[29*16 +:16]=700;
frame_in[30*16 +:16]=200;

// row 4

frame_in[33*16 +:16]=200;
frame_in[34*16 +:16]=700;
frame_in[35*16 +:16]=1000;
frame_in[36*16 +:16]=1000;
frame_in[37*16 +:16]=700;
frame_in[38*16 +:16]=200;

// row 5

frame_in[41*16 +:16]=100;
frame_in[42*16 +:16]=400;
frame_in[43*16 +:16]=700;
frame_in[44*16 +:16]=700;
frame_in[45*16 +:16]=400;
frame_in[46*16 +:16]=100;

// row 6

frame_in[49*16 +:16]=50;
frame_in[50*16 +:16]=100;
frame_in[51*16 +:16]=200;
frame_in[52*16 +:16]=200;
frame_in[53*16 +:16]=100;
frame_in[54*16 +:16]=50;

end

endtask

// ============================================================

initial

begin

$dumpfile("master.vcd");

$dumpvars(0,tb_master);

clk=0;

threshold=16'd250;

se_mask=9'b111111111;

// ========================================================
// PASS
// ========================================================

load_image();

opcode=3'b000;

#20;

$display("=== PASS ===");

print_frame();

// ========================================================
// EROSION
// ========================================================

load_image();

opcode=3'b001;

#20;

$display("=== EROSION ===");

print_frame();

// ========================================================
// DILATION
// ========================================================

load_image();

opcode=3'b010;

#20;

$display("=== DILATION ===");

print_frame();

// ========================================================
// UNIFORMITY
// ========================================================

load_image();

opcode=3'b101;

#20;

$display("=== UNIFORMITY ===");

print_frame();

// ========================================================
// ROUGHNESS
// ========================================================

load_image();

opcode=3'b110;

#20;

$display("=== ROUGHNESS ===");

print_frame();

#20;

$finish;

end

endmodule
