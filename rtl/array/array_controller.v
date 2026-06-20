// ============================================================================
// Local Interaction Processor (LIP)
// Array Controller
//
// Handles multi-pass operations.
//
// Opcodes
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

    input start,

    input [2:0] opcode,

    output reg [2:0] pe_opcode,

    output reg use_stage_buffer,

    output reg busy,

    output reg done

);

// ============================================================
// Internal state
// ============================================================

reg phase;

// ============================================================
// Controller
// ============================================================

always @(posedge clk)

begin

    // default outputs every clock

    done <= 1'b0;

    // ========================================================
    // idle state
    // ========================================================

    if(!start)

    begin

        phase <= 1'b0;

        busy <= 1'b0;

        use_stage_buffer <= 1'b0;

        pe_opcode <= opcode;

    end

    // ========================================================
    // active state
    // ========================================================

    else

    begin

        case(opcode)

        // ====================================================
        // OPENING
        // erosion -> dilation
        // ====================================================

        3'b011:

        begin

            busy <= 1'b1;

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

                busy <= 1'b0;

                done <= 1'b1;
            end

        end

        // ====================================================
        // CLOSING
        // dilation -> erosion
        // ====================================================

        3'b100:

        begin

            busy <= 1'b1;

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

                busy <= 1'b0;

                done <= 1'b1;
            end

        end

        // ====================================================
        // Single pass operations
        // ====================================================

        default:

        begin

            phase <= 1'b0;

            pe_opcode <= opcode;

            use_stage_buffer <= 1'b0;

            busy <= 1'b0;

            done <= 1'b1;

        end

        endcase

    end

end

endmodule
