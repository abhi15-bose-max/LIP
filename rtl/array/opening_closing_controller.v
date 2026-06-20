module opening_closing_controller(

    input clk,

    input start,

    input [2:0] opcode,

    output reg [2:0] pe_opcode,

    output reg select_stage,

    output reg busy,

    output reg done

);

reg phase;

always @(posedge clk)

begin

    done <= 1'b0;

    if(!start)

    begin

        phase <= 1'b0;

        busy <= 1'b0;

        select_stage <= 1'b0;

        pe_opcode <= opcode;

    end

    else

    begin

        case(opcode)

        3'b011: begin

            busy <= 1'b1;

            if(!phase)

            begin

                pe_opcode <= 3'b001;

                select_stage <= 1'b0;

                phase <= 1'b1;
            end

            else

            begin

                pe_opcode <= 3'b010;

                select_stage <= 1'b1;

                busy <= 1'b0;

                done <= 1'b1;

                phase <= 1'b0;
            end

        end

        3'b100: begin

            busy <= 1'b1;

            if(!phase)

            begin

                pe_opcode <= 3'b010;

                select_stage <= 1'b0;

                phase <= 1'b1;
            end

            else

            begin

                pe_opcode <= 3'b001;

                select_stage <= 1'b1;

                busy <= 1'b0;

                done <= 1'b1;

                phase <= 1'b0;
            end

        end

        default:

        begin

            pe_opcode <= opcode;

            busy <= 1'b0;

            done <= 1'b1;

            select_stage <= 1'b0;

        end

        endcase

    end

end

endmodule
