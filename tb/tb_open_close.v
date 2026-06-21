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

$display("--------------------------------");

end

endtask

// ============================================================

initial

begin

$dumpfile("openclose.vcd");

$dumpvars(0,tb_open_close);

clk=0;

frame_in=0;

// ========================================================
// Image with noise
// ========================================================

frame_in[27*16 +:16]=1000;

frame_in[28*16 +:16]=1000;

frame_in[35*16 +:16]=1000;

frame_in[36*16 +:16]=1000;

// isolated noise

frame_in[5*16 +:16]=1000;

frame_in[60*16 +:16]=1000;

se_mask=9'b111111111;

threshold=16'd100;

// ========================================================
// OPENING
// ========================================================

$display("=== OPENING ===");

// pass1

opcode=3'b001;

#20;

stage_buffer=frame_out;

// pass2

frame_in=stage_buffer;

opcode=3'b010;

#20;

print_frame();

// ========================================================
// RESET IMAGE
// ========================================================

frame_in=0;

frame_in[27*16 +:16]=1000;

frame_in[28*16 +:16]=1000;

frame_in[35*16 +:16]=1000;

frame_in[36*16 +:16]=1000;

// hole

frame_in[28*16 +:16]=0;

se_mask=9'b111111111;

// ========================================================
// CLOSING
// ========================================================

$display("=== CLOSING ===");

// pass1

opcode=3'b010;

#20;

stage_buffer=frame_out;

// pass2

frame_in=stage_buffer;

opcode=3'b001;

#20;

print_frame();

#20;

$finish;

end

endmodule
