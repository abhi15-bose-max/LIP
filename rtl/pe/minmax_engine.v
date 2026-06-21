`timescale 1ns/1ps

// ============================================================================
// Local Interaction Processor (LIP)
// Min/Max Engine
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

always @(*)

begin

    // initialize

    min_val = 16'hFFFF;

    max_val = 16'h0000;

    // NW

    if(se_mask[8])

    begin

        if(nw < min_val)
            min_val = nw;

        if(nw > max_val)
            max_val = nw;

    end

    // N

    if(se_mask[7])

    begin

        if(n < min_val)
            min_val = n;

        if(n > max_val)
            max_val = n;

    end

    // NE

    if(se_mask[6])

    begin

        if(ne < min_val)
            min_val = ne;

        if(ne > max_val)
            max_val = ne;

    end

    // W

    if(se_mask[5])

    begin

        if(w < min_val)
            min_val = w;

        if(w > max_val)
            max_val = w;

    end

    // SELF

    if(se_mask[4])

    begin

        if(self < min_val)
            min_val = self;

        if(self > max_val)
            max_val = self;

    end

    // E

    if(se_mask[3])

    begin

        if(e < min_val)
            min_val = e;

        if(e > max_val)
            max_val = e;

    end

    // SW

    if(se_mask[2])

    begin

        if(sw < min_val)
            min_val = sw;

        if(sw > max_val)
            max_val = sw;

    end

    // S

    if(se_mask[1])

    begin

        if(s < min_val)
            min_val = s;

        if(s > max_val)
            max_val = s;

    end

    // SE

    if(se_mask[0])

    begin

        if(se < min_val)
            min_val = se;

        if(se > max_val)
            max_val = se;

    end

end

endmodule
