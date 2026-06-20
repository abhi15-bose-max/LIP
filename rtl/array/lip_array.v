module lip_array #

(

parameter SIZE=8

)

(

input clk,

input start,

input [2:0] opcode,

input [8:0] se_mask,

input [15:0] threshold,

input [(SIZE*SIZE*16)-1:0] frame_in,

output reg [(SIZE*SIZE*16)-1:0] frame_out,

output busy,

output done

);

wire [2:0] pe_opcode;

wire select_stage;

reg [(SIZE*SIZE*16)-1:0] stage_buffer;

wire [(SIZE*SIZE*16)-1:0] pe_outputs;

opening_closing_controller ctrl(

    .clk(clk),

    .start(start),

    .opcode(opcode),

    .pe_opcode(pe_opcode),

    .select_stage(select_stage),

    .busy(busy),

    .done(done)

);

wire [(SIZE*SIZE*16)-1:0] active_frame;

assign active_frame =
select_stage
?
stage_buffer
:
frame_in;

genvar r,c;

generate

for(r=0;r<SIZE;r=r+1)

begin:rows

for(c=0;c<SIZE;c=c+1)

begin:cols

localparam integer idx = r*SIZE+c;

wire [15:0] self;

wire [15:0] north;
wire [15:0] south;

wire [15:0] east;
wire [15:0] west;

wire [15:0] nw;
wire [15:0] ne;

wire [15:0] sw;
wire [15:0] se;

assign self =
active_frame[idx*16 +:16];

assign north =
(r==0)
?
16'd0
:
active_frame[((r-1)*SIZE+c)*16 +:16];

assign south =
(r==SIZE-1)
?
16'd0
:
active_frame[((r+1)*SIZE+c)*16 +:16];

assign west =
(c==0)
?
16'd0
:
active_frame[(r*SIZE+(c-1))*16 +:16];

assign east =
(c==SIZE-1)
?
16'd0
:
active_frame[(r*SIZE+(c+1))*16 +:16];

assign nw =
(r==0 || c==0)
?
16'd0
:
active_frame[((r-1)*SIZE+(c-1))*16 +:16];

assign ne =
(r==0 || c==SIZE-1)
?
16'd0
:
active_frame[((r-1)*SIZE+(c+1))*16 +:16];

assign sw =
(r==SIZE-1 || c==0)
?
16'd0
:
active_frame[((r+1)*SIZE+(c-1))*16 +:16];

assign se =
(r==SIZE-1 || c==SIZE-1)
?
16'd0
:
active_frame[((r+1)*SIZE+(c+1))*16 +:16];

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

.out(pe_outputs[idx*16 +:16])

);

end

end

endgenerate

always @(posedge clk)

begin

    stage_buffer <= pe_outputs;

    frame_out <= pe_outputs;

end

endmodule
