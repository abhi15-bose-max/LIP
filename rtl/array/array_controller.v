// ============================================================================
// Local Interaction Processor (LIP)
// Array Controller
//
// Controls multi-pass operations.
//
// 000 PASS
// 001 EROSION
// 010 DILATION
// 011 OPENING
// 100 CLOSING
// 101 UNIFORMITY
// 110 ROUGHNESS
// ============================================================================

module array_controller(

    input clk,

    input [2:0] opcode,

    output reg [2:0] pe_opcode,

    output reg use_stage_buffer

);

reg phase;

always @(posedge clk)

begin

    case(opcode)

    // =========================================================
    // OPENING
    // =========================================================

    3'b011:

    begin

        if(!phase)

        begin

            pe_opcode <= 3'b001;

            use_stage_buffer <= 1'b0;

            phase <= 1'b1;
        end

        else

        begin

            pe_opcode <= 3'b010;

            use_stage_buffer <= 1'b1;

            phase <= 1'b0;
        end

    end

    // =========================================================
    // CLOSING
    // =========================================================

    3'b100:

    begin

        if(!phase)

        begin

            pe_opcode <= 3'b010;

            use_stage_buffer <= 1'b0;

            phase <= 1'b1;
        end

        else

        begin

            pe_opcode <= 3'b001;

            use_stage_buffer <= 1'b1;

            phase <= 1'b0;
        end

    end

    // =========================================================
    // SINGLE PASS OPS
    // =========================================================

    default:

    begin

        phase <= 1'b0;

        pe_opcode <= opcode;

        use_stage_buffer <= 1'b0;

    end

    endcase

end

endmodule
