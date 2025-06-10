`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2025 09:35:33
// Design Name: 
// Module Name: tb
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

`define PERIOD 4340
module tb;
    reg clk_115200 = 0;
    reg rst = 1;
    reg rx = 1;
    
    uart_fsm DUT(clk_115200, rst, rx);
    
    always #(`PERIOD) clk_115200 =~ clk_115200;
    
    task sen_uart_byte;
        input [7:0] data;
        integer i;
        begin
            rx <= 0;
            #(`PERIOD*2);
            for (i = 0; i < 8; i = i + 1)
            begin
                rx <= data[i];
                #(`PERIOD*2);
            end
            
            rx <= 1;
            #(`PERIOD*2);
        end
    endtask
    
    initial begin
        #100;
        rst = 0;
        
        #10000;
        
        send_uart_byte(8'h41);
        send_uart_byte(8'h42);
        send_uart_byte(8'h43);
        
        #50000;
        
        $writememh("rom_output.hex", DUT.rom);
        $display("Simulation complete. Check rom_output.hex");
        $stop;
    end  
    
endmodule
