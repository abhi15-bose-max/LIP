`timescale 1ns/1ps

module threshold_engine (

    input [15:0] min_val,
    input [15:0] max_val,

    input [15:0] threshold,

    output uniformity,
    output roughness

);

wire [15:0] range;

assign range = max_val - min_val;

assign uniformity = (range < threshold);

assign roughness = (range > threshold);

endmodule
