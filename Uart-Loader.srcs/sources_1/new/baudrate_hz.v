`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 20:39:28
// Design Name: 
// Module Name: baudrate_hz
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baudrate_hz(
    input clk_100MHz,
    input rst,
    output clk_115200
    );
    
    reg[15:0] counter_reg;
    reg clk_out_reg = 1'b0;
    
    always@(posedge clk_100MHz or posedge rst) begin
        if(rst) 
        begin
            counter_reg <= 0;
            clk_out_reg <= 0;
        end else 
        begin    
        if(counter_reg == 15'd433) begin
        counter_reg <= 15'd0;
        clk_out_reg <= ~clk_out_reg;
     end
     else begin
        counter_reg <= counter_reg + 15'd1;
        end
    end
end
    assign clk_115200 = clk_out_reg;
endmodule
