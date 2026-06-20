// ============================================================================
// Local Interaction Processor (LIP)
// Parameterized PE Array
// Supports NxN arrays
// ============================================================================

module lip_array #

(

parameter SIZE       = 8,
parameter PIXEL_BITS = 16

)

(

input clk,

input start,

input [2:0] opcode,

input [8:0] se_mask,

input [PIXEL_BITS-1:0] threshold,

input [(SIZE*SIZE*PIXEL_BITS)-1:0] frame_in,

output reg [(SIZE*SIZE*PIXEL_BITS)-1:0] frame_out,

output busy,

output done

);

// ============================================================
// Parameters
// ============================================================

localparam NUM_PE     = SIZE*SIZE;

localparam FRAME_BITS = NUM_PE*PIXEL_BITS;

// ============================================================
// Controller signals
// ============================================================

wire [2:0] pe_opcode;

wire use_stage_buffer;

// ============================================================
// Internal frame storage
// ============================================================

reg [FRAME_BITS-1:0] stage_buffer;

wire [FRAME_BITS-1:0] active_frame;

wire [FRAME_BITS-1:0] pe_outputs;

// ============================================================
// Controller
// ============================================================

array_controller ctrl(

    .clk(clk),

    .start(start),

    .opcode(opcode),

    .pe_opcode(pe_opcode),

    .use_stage_buffer(use_stage_buffer),

    .busy(busy),

    .done(done)

);

// ============================================================
// Frame selection
// ============================================================

assign active_frame =

    use_stage_buffer

    ?

    stage_buffer

    :

    frame_in;

// ============================================================
// PE Array
// ============================================================

genvar r,c;

generate

for(r=0;r<SIZE;r=r+1)

begin : rows

    for(c=0;c<SIZE;c=c+1)

    begin : cols

        localparam integer IDX = r*SIZE+c;

        wire [PIXEL_BITS-1:0] self;

        wire [PIXEL_BITS-1:0] north;
        wire [PIXEL_BITS-1:0] south;

        wire [PIXEL_BITS-1:0] east;
        wire [PIXEL_BITS-1:0] west;

        wire [PIXEL_BITS-1:0] nw;
        wire [PIXEL_BITS-1:0] ne;

        wire [PIXEL_BITS-1:0] sw;
        wire [PIXEL_BITS-1:0] se;

        // ====================================================
        // Center
        // ====================================================

        assign self =

            active_frame[IDX*PIXEL_BITS +: PIXEL_BITS];

        // ====================================================
        // Cardinal neighbours
        // ====================================================

        assign north =

            (r==0)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[((r-1)*SIZE+c)*PIXEL_BITS +: PIXEL_BITS];

        assign south =

            (r==SIZE-1)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[((r+1)*SIZE+c)*PIXEL_BITS +: PIXEL_BITS];

        assign west =

            (c==0)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[(r*SIZE+(c-1))*PIXEL_BITS +: PIXEL_BITS];

        assign east =

            (c==SIZE-1)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[(r*SIZE+(c+1))*PIXEL_BITS +: PIXEL_BITS];

        // ====================================================
        // Diagonals
        // ====================================================

        assign nw =

            (r==0 || c==0)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[((r-1)*SIZE+(c-1))*PIXEL_BITS +: PIXEL_BITS];

        assign ne =

            (r==0 || c==SIZE-1)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[((r-1)*SIZE+(c+1))*PIXEL_BITS +: PIXEL_BITS];

        assign sw =

            (r==SIZE-1 || c==0)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[((r+1)*SIZE+(c-1))*PIXEL_BITS +: PIXEL_BITS];

        assign se =

            (r==SIZE-1 || c==SIZE-1)

            ?

            {PIXEL_BITS{1'b0}}

            :

            active_frame[((r+1)*SIZE+(c+1))*PIXEL_BITS +: PIXEL_BITS];

        // ====================================================
        // Processing Element
        // ====================================================

        lip_pe pe(

            .clk(clk),

            .nw(nw),
            .n(north),
            .ne(ne),

            .w(west),
            .self(self),
            .e(east),

            .sw(sw),
            .s(south),
            .se(se),

            .se_mask(se_mask),

            .opcode(pe_opcode),

            .threshold(threshold),

            .out(pe_outputs[IDX*PIXEL_BITS +: PIXEL_BITS])

        );

    end

end

endgenerate

// ============================================================
// Internal storage
// ============================================================

always @(posedge clk)

begin

    stage_buffer <= pe_outputs;

    if(done)

    begin

        frame_out <= pe_outputs;
    end

end

endmodule
