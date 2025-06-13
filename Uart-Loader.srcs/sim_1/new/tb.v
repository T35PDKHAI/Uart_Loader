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
//////////////////////////////////////////////////////////////////////////////////
// Testbench cho UART FSM
// Mô phỏng quá trình truyền dữ liệu UART và kiểm tra dữ liệu lưu trữ trong ROM
//////////////////////////////////////////////////////////////////////////////////

`define PERIOD 10   

module tb;
    reg clk_115200 = 0;
    reg rst = 1;
    reg rx = 1;
    reg [7:0] addr = 0;
    wire [7:0] addr_byte;
    wire [7:0] shift_reg;
    wire [1:0] state;
    wire [7:0] rom_addr;
    
    integer j;
    reg [7:0] expected_values [0:2]; // Mảng chứa giá trị mong đợi

    // Kết nối module DUT (Device Under Test)
    uart_fsm DUT (
        .clk_115200(clk_115200),
        .rst(rst),
        .rx(rx),
        .addr(addr),
        .addr_byte(addr_byte),
        .shift_reg(shift_reg),
        .state(state),
        .rom_addr(rom_addr)
    );

    // Tạo xung clock ~115200Hz
    always #(`PERIOD/2) clk_115200 = ~clk_115200;

    // Task gửi UART 1 byte (8N1)
    task send_uart_byte;
        input [7:0] data;
        integer i;
        begin
            $display(">> Send byte: %h (%c)", data, data);
            rx <= 0; // Start bit
            #(`PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx <= data[i]; // Gửi từng bit
                #(`PERIOD);
            end

            rx <= 1; // Stop bit
            #(`PERIOD);
            $display(">> Byte send: %h (%c)", data, data);
        end
    endtask

    initial begin
        // Thiết lập giá trị mong đợi
        expected_values[0] = 8'h41; // 'A'
        expected_values[1] = 8'h42; // 'B'
        expected_values[2] = 8'h43; // 'C'

        $display("\n===== START SIMULATION =====");

        #100;
        rst = 0;
        #10000;

        // Gửi 3 ký tự: A, B, C
        send_uart_byte(8'h41); // 'A'
        send_uart_byte(8'h42); // 'B'
        send_uart_byte(8'h43); // 'C'

        // Chờ để FSM xử lý xong
        #50000;

        // Kiểm tra dữ liệu trong ROM
        $display("\n===== Check data in ROM =====");
        for (j = 0; j < 3; j = j + 1) begin
            addr = j;
            #100;
            if (addr_byte !== expected_values[j]) begin
                $display("Error: ROM[%d] false! Receive: %h, expect: %h", j, addr_byte, expected_values[j]);
            end else begin
                $display("ROM[%d] true! (%c)", j, addr_byte);
            end
        end
        $display("\n===== FINISH SIMULATION =====");
        $stop;
    end
endmodule

