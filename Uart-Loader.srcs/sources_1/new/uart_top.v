`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.06.2025 20:57:39
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input clk_100MHz,
    input rst,
    input rx,
    output [7:0] led
    );
    
    wire clk_115200;    
    
    baudrate_hz uart_baud(
        .clk_100MHz(clk_100MHz),
        .rst(rst),
        .clk_115200(clk_115200)
    );
    
    uart_fsm u_fsm(
        .clk_115200(clk_115200),
        .rst(rst),
        .rx(rx),
        .addr(addr),
        .addr_byte(addr_byte),
        .shift_reg(led),
        .state(state),
        .rom_addr(rom_addr)
    );
    
    
endmodule
