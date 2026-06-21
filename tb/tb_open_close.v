`timescale 1ns/1ps

module tb_open_close;

parameter SIZE=8;

parameter PIXEL_BITS=16;

localparam FRAME_BITS=SIZE*SIZE*PIXEL_BITS;

reg clk;

reg [2:0] opcode;

reg [8:0] se_mask;

reg [15:0] threshold;

reg [FRAME_BITS-1:0] frame_in;

wire [FRAME_BITS-1:0] frame_out;

reg [FRAME_BITS-1:0] stage_buffer;

// ============================================================
// DUT
// ============================================================

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

endtask;

// ============================================================
// OPENING DEMO
// ============================================================

task run_opening;

begin

$display("");
$display("=================================");
$display("OPENING");
$display("Remove isolated noise");
$display("=================================");

frame_in=0;

// central object

frame_in[27*16 +:16]=1000;

frame_in[28*16 +:16]=1000;

frame_in[35*16 +:16]=1000;

frame_in[36*16 +:16]=1000;

// isolated noise

frame_in[5*16 +:16]=1000;

frame_in[58*16 +:16]=1000;

$display("Input:");

opcode=3'b000;

#20;

print_frame();

// erosion

opcode=3'b001;

#20;

stage_buffer=frame_out;

// dilation

frame_in=stage_buffer;

opcode=3'b010;

#20;

$display("Output:");

print_frame();

end

endtask

// ============================================================
// CLOSING DEMO
// ============================================================

task run_closing;

begin

$display("");
$display("=================================");
$display("CLOSING");
$display("Fill holes");
$display("=================================");

frame_in=0;

// 3x3 object

frame_in[18*16 +:16]=1000;
frame_in[19*16 +:16]=1000;
frame_in[20*16 +:16]=1000;

frame_in[26*16 +:16]=1000;
// hole here
frame_in[28*16 +:16]=1000;

frame_in[34*16 +:16]=1000;
frame_in[35*16 +:16]=1000;
frame_in[36*16 +:16]=1000;

$display("Input:");

opcode=3'b000;

#20;

print_frame();

// dilation

opcode=3'b010;

#20;

stage_buffer=frame_out;

// erosion

frame_in=stage_buffer;

opcode=3'b001;

#20;

$display("Output:");

print_frame();

end

endtask

// ============================================================

initial

begin

$dumpfile("openclose.vcd");

$dumpvars(0,tb_open_close);

clk=0;

threshold=16'd100;

se_mask=9'b111111111;

#10;

run_opening();

#20;

run_closing();

#20;

$finish;

end

endmodule
