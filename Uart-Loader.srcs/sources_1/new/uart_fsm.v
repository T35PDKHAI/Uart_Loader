`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.05.2025 19:17:54
// Design Name: 
// Module Name: uart_fsm
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


module uart_fsm(
    input clk_115200,
    input rst,
    input rx
    
    );
    localparam IDLE = 2'd0;
    localparam RX = 2'd1;
    localparam STOP = 2'd2; 
   
    reg [2:0] state = 0;
    reg [3:0] bit_count = 0;
    reg [7:0] shift_reg;
    reg [7:0] rom_addr;
    reg [7:0] rom [0:255];
    
    always @(posedge clk_115200 or posedge rst) begin
        if(rst) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
        end
        else begin
        case(state)
            IDLE : begin
            if(rx == 0) begin  
                bit_count <= 0;
                state <= RX;
            end
            end
            RX : begin
            shift_reg[bit_count] <= rx;
            bit_count <= bit_count + 1;
            if(bit_count == 3'd7)
                bit_count <= 0;
                state <= STOP;
            end
            STOP : begin
            if(rx == 1) begin
                rom[rom_addr] <= shift_reg;
                rom_addr <= rom_addr + 1;
            end
            end
            default: state <= IDLE;
        endcase
        end
    end
endmodule
