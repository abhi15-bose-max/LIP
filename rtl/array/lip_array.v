// ============================================================================
// Local Interaction Processor (LIP)
// Parameterized Array
// ============================================================================

module lip_array #

(

parameter SIZE=8,

parameter PIXEL_BITS=16

)

(

input clk,

input [2:0] opcode,

input [8:0] se_mask,

input [PIXEL_BITS-1:0] threshold,

input [(SIZE*SIZE*PIXEL_BITS)-1:0] frame_in,

output reg [(SIZE*SIZE*PIXEL_BITS)-1:0] frame_out

);

localparam NUM_PE = SIZE*SIZE;

localparam FRAME_BITS = NUM_PE*PIXEL_BITS;

wire [FRAME_BITS-1:0] pe_outputs;

genvar r,c;

generate

for(r=0;r<SIZE;r=r+1)

begin:rows

for(c=0;c<SIZE;c=c+1)

begin:cols

localparam integer IDX=r*SIZE+c;

wire [PIXEL_BITS-1:0] self;

wire [PIXEL_BITS-1:0] north;
wire [PIXEL_BITS-1:0] south;

wire [PIXEL_BITS-1:0] east;
wire [PIXEL_BITS-1:0] west;

wire [PIXEL_BITS-1:0] nw;
wire [PIXEL_BITS-1:0] ne;

wire [PIXEL_BITS-1:0] sw;
wire [PIXEL_BITS-1:0] se;

assign self =
frame_in[IDX*PIXEL_BITS +: PIXEL_BITS];

assign north =
(r==0)
?
{PIXEL_BITS{1'b0}}
:
frame_in[((r-1)*SIZE+c)*PIXEL_BITS +: PIXEL_BITS];

assign south =
(r==SIZE-1)
?
{PIXEL_BITS{1'b0}}
:
frame_in[((r+1)*SIZE+c)*PIXEL_BITS +: PIXEL_BITS];

assign west =
(c==0)
?
{PIXEL_BITS{1'b0}}
:
frame_in[(r*SIZE+(c-1))*PIXEL_BITS +: PIXEL_BITS];

assign east =
(c==SIZE-1)
?
{PIXEL_BITS{1'b0}}
:
frame_in[(r*SIZE+(c+1))*PIXEL_BITS +: PIXEL_BITS];

assign nw =
(r==0 || c==0)
?
{PIXEL_BITS{1'b0}}
:
frame_in[((r-1)*SIZE+(c-1))*PIXEL_BITS +: PIXEL_BITS];

assign ne =
(r==0 || c==SIZE-1)
?
{PIXEL_BITS{1'b0}}
:
frame_in[((r-1)*SIZE+(c+1))*PIXEL_BITS +: PIXEL_BITS];

assign sw =
(r==SIZE-1 || c==0)
?
{PIXEL_BITS{1'b0}}
:
frame_in[((r+1)*SIZE+(c-1))*PIXEL_BITS +: PIXEL_BITS];

assign se =
(r==SIZE-1 || c==SIZE-1)
?
{PIXEL_BITS{1'b0}}
:
frame_in[((r+1)*SIZE+(c+1))*PIXEL_BITS +: PIXEL_BITS];

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

.opcode(opcode),

.threshold(threshold),

.out(pe_outputs[IDX*PIXEL_BITS +: PIXEL_BITS])

);

end

end

endgenerate

always @(posedge clk)

begin

frame_out <= pe_outputs;

end

endmodule
