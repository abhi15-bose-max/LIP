module minmax_engine (

    input [15:0] nw,
    input [15:0] n,
    input [15:0] ne,

    input [15:0] w,
    input [15:0] self,
    input [15:0] e,

    input [15:0] sw,
    input [15:0] s,
    input [15:0] se,

    output [15:0] min_val,
    output [15:0] max_val

);

reg [15:0] min_r;
reg [15:0] max_r;

always @(*) begin

    min_r = nw;
    max_r = nw;

    if(n < min_r) min_r = n;
    if(ne < min_r) min_r = ne;
    if(w < min_r) min_r = w;
    if(self < min_r) min_r = self;
    if(e < min_r) min_r = e;
    if(sw < min_r) min_r = sw;
    if(s < min_r) min_r = s;
    if(se < min_r) min_r = se;

    if(n > max_r) max_r = n;
    if(ne > max_r) max_r = ne;
    if(w > max_r) max_r = w;
    if(self > max_r) max_r = self;
    if(e > max_r) max_r = e;
    if(sw > max_r) max_r = sw;
    if(s > max_r) max_r = s;
    if(se > max_r) max_r = se;

end

assign min_val = min_r;
assign max_val = max_r;

endmodule
