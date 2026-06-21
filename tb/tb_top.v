`timescale 1ns/1ps

module tb_top;

parameter SIZE = 8;

parameter PIXEL_BITS = 16;

localparam FRAME_BITS = SIZE*SIZE*PIXEL_BITS;

// ============================================================
// DUT Signals
// ============================================================

reg clk;

reg [2:0] opcode;

reg [8:0] se_mask;

reg [PIXEL_BITS-1:0] threshold;

reg [FRAME_BITS-1:0] frame_in;

wire [FRAME_BITS-1:0] frame_out;

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
// Clock
// ============================================================

always #5 clk = ~clk;

// ============================================================
// Utilities
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

            idx = r*SIZE+c;

            $write("%5d ",

            frame_out[idx*PIXEL_BITS +: PIXEL_BITS]);

        end

        $display("");

    end

    $display("----------------------------------------");

end

endtask

// ============================================================
// Main Test
// ============================================================

initial

begin

    $dumpfile("lip.vcd");

    $dumpvars(0,tb_top);

    clk = 0;

    opcode = 0;

    frame_in = 0;

    // ========================================================
    // Create diagonal image
    // ========================================================

    frame_in[0*PIXEL_BITS +: PIXEL_BITS]  = 1000;

    frame_in[9*PIXEL_BITS +: PIXEL_BITS]  = 1000;

    frame_in[18*PIXEL_BITS +: PIXEL_BITS] = 1000;

    frame_in[27*PIXEL_BITS +: PIXEL_BITS] = 1000;

    frame_in[36*PIXEL_BITS +: PIXEL_BITS] = 1000;

    frame_in[45*PIXEL_BITS +: PIXEL_BITS] = 1000;

    frame_in[54*PIXEL_BITS +: PIXEL_BITS] = 1000;

    frame_in[63*PIXEL_BITS +: PIXEL_BITS] = 1000;

    // ========================================================
    // Configuration
    // ========================================================

    se_mask = 9'b111111111;

    threshold = 16'd100;

    // ========================================================
    // PASS
    // ========================================================

    opcode = 3'b000;

    #10;

    $display("=== PASS ===");

    print_frame();

    // ========================================================
    // EROSION
    // ========================================================

    opcode = 3'b001;

    #10;

    $display("=== EROSION ===");

    print_frame();

    // ========================================================
    // DILATION
    // ========================================================

    opcode = 3'b010;

    #10;

    $display("=== DILATION ===");

    print_frame();

    // ========================================================
    // UNIFORMITY
    // ========================================================

    opcode = 3'b101;

    #10;

    $display("=== UNIFORMITY ===");

    print_frame();

    // ========================================================
    // ROUGHNESS
    // ========================================================

    opcode = 3'b110;

    #10;

    $display("=== ROUGHNESS ===");

    print_frame();

    #20;

    $finish;

end

endmodule
