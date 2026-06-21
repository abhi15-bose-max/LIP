`timescale 1ns/1ps

// ============================================================================
// Local Interaction Processor (LIP)
// Min/Max Engine
//
// Computes MIN and MAX over enabled neighbours only.
//
// SE mask layout:
//
// 8 7 6
// 5 4 3
// 2 1 0
//
// NW N NE
// W  C E
// SW S SE
// ============================================================================

module minmax_engine(

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

    output reg [15:0] min_val,

    output reg [15:0] max_val

);

// ============================================================
// Internal storage
// ============================================================

reg [15:0] values [0:8];

integer i;

// ============================================================
// Min / Max computation
// ============================================================

always @(*)

begin

    // --------------------------------------------------------
    // Neighbour ordering
    // --------------------------------------------------------

    values[0] = nw;
    values[1] = n;
    values[2] = ne;

    values[3] = w;
    values[4] = self;
    values[5] = e;

    values[6] = sw;
    values[7] = s;
    values[8] = se;

    // --------------------------------------------------------
    // Initialize
    // --------------------------------------------------------

    min_val = 16'hFFFF;

    max_val = 16'h0000;

    // --------------------------------------------------------
    // Compute only enabled neighbours
    // --------------------------------------------------------

    for(i=0;i<9;i=i+1)

    begin

        if(se_mask[8-i])

        begin

            if(values[i] < min_val)

                min_val = values[i];

            if(values[i] > max_val)

                max_val = values[i];

        end

    end

end

endmodule
