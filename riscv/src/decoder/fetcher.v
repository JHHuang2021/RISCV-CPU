module Fetcher(
    input wire clk,
    input wire rst,
    input wire rdy,

    input wire read_enable;
  );

  reg [1:0] counter;
  reg [31:0] val_tmp;
  always @(posedge clk_in)
  begin
    if (read_enable)
    begin
      if (counter==0)
        val_tmp[7:0]   <= mem_din;
      if (counter==1)
        val_tmp[15:8]  <= mem_din;
      if (counter==2)
        val_tmp[23:16] <= mem_din;
      if (counter==3)
        val_tmp[31:24] <= mem_din;
      counter <= counter + 1;
      if (counter==target_counter)
      begin
        counter <= 0;
        rd_en   <= 1;
      end
    end
  end

endmodule
