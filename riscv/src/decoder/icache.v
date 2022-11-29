module ICache#(parameter TAG_WIDTH = 20,
                   parameter INDEX_WIDTH = 10 )(
                       input wire clk_in,
                       input wire rst_in,
                       input wire rdy_in,

                       input wire input_enable,  // 0-invalid, 1-valid
                       input wire request_enable,  // 0-invalid, 1-valid
                       // addr = tag + index
                       input wire [31: 0] input_addr,
                       input wire [31: 0] input_instr,

                       input wire [31: 0] require_addr,
                       output wire [31: 0] output_instr,
                       output wire output_enable
                   );
    reg [31: 0] instr_cache[2 ** INDEX_WIDTH - 1: 0];
    reg [TAG_WIDTH - 1: 0] tag_cache[2 ** INDEX_WIDTH - 1: 0];
    reg [2 ** INDEX_WIDTH - 1: 0] valid;

    wire [INDEX_WIDTH - 1: 0] index_input;
    wire [TAG_WIDTH - 1: 0] tag_input;
    assign tag_input = input_addr[31: 32 - TAG_WIDTH];
    assign index_input = input_addr[31 - TAG_WIDTH: 32 - TAG_WIDTH - INDEX_WIDTH];

    wire [TAG_WIDTH - 1: 0] tag_request;
    wire [INDEX_WIDTH - 1: 0] index_request;
    assign tag_request = require_addr[31: 32 - TAG_WIDTH];
    assign index_request = require_addr[31 - TAG_WIDTH: 32 - TAG_WIDTH - INDEX_WIDTH];

    assign output_enable = request_enable && valid[index_request] && (tag_request == tag_cache[index_request]);
    assign output_instr = instr_cache[index_request];

    always @(posedge clk_in) begin
        if (rst_in) begin
            valid <= 0;
        end
        else if (rdy_in) begin
            if (input_enable) begin
                instr_cache[index_input] <= input_instr;
                tag_cache[index_input] <= input_addr[31: 32 - TAG_WIDTH];
                valid[index_input] <= 1;
            end
        end
    end

endmodule
