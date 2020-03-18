`timescale 1ns/1ns

module tb_butterfly();

reg clk,rst_n,str_sig;
reg [31 : 0] real_x0,imag_x0;
reg [31 : 0] real_x1,imag_x1;
reg [31 : 0] real_w,imag_w;


wire [31 : 0] real_y0,imag_y0;
wire [31 : 0] real_y1,imag_y1;
wire done_sig;

butterfly U10(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .real_x0(real_x0),
    .imag_x0(imag_x0),
    .real_x1(real_x1),
    .imag_x1(imag_x1),

    .real_w(real_w),
    .imag_w(imag_w),


    .real_y0(real_y0),
    .imag_y0(imag_y0),
    .real_y1(real_y1),
    .imag_y1(imag_y1),
    .done_sig(done_sig)
);

initial
    fork
        clk=0;
        rst_n=0;
        #600 rst_n=1;

        str_sig=0;
        #1000 str_sig=1;
        #1200 str_sig=0;

        #1000 real_x0=32'b01000000010000000000000000000000;//3
        #1000 imag_x0=32'b00111111100000000000000000000000;//1

        #1000 real_x1=32'b01000000100000000000000000000000;//4
        #1000 imag_x1=32'b11000000000000000000000000000000;//-2

        #1000 real_w=32'b00111111100000000000000000000000;//1
        #1000 imag_w=32'b00000000000000000000000000000000;//0

        #7000 str_sig=1;
        #7200 str_sig=0;

        #7000 imag_w=32'b00111111100000000000000000000000;//1
        #7000 real_w=32'b00000000000000000000000000000000;//0

        //===================

        #13000 str_sig=1;
        #13200 str_sig=0;

        #13000 real_x1=32'b01000000010100110011001100110011;//3.3
        #13000 imag_x1=32'b01000000100100000000000000000000;//4.5

        #13000 real_x0=32'b01000000000001100110011001100110;//2.1
        #13000 imag_x0=32'b01000000111001100110011001100110;//7.2

        #13000 real_w=32'b00111111100000000000000000000000;//1
        #13000 imag_w=32'b00000000000000000000000000000000;//0

        #19000 str_sig=1;
        #19200 str_sig=0;

        #19000 imag_w=32'b00111111100000000000000000000000;//1
        #19000 real_w=32'b00000000000000000000000000000000;//0

        //=====================

        #25000 str_sig=1;
        #25200 str_sig=0;

        #25000 real_x1=32'b10111110011000010100011110101110;//-0.22
        #25000 imag_x1=32'b01000000010010010010011011101001;//3.143

        #25000 real_x0=32'b11000000011010011100101011000001;//-3.653
        #25000 imag_x0=32'b11000001010000011100001010001111;//-12.11

        #25000 real_w=32'b00111111100000000000000000000000;//1
        #25000 imag_w=32'b00000000000000000000000000000000;//0

        #31000 str_sig=1;
        #31200 str_sig=0;

        #31000 imag_w=32'b00111111100000000000000000000000;//1
        #31000 real_w=32'b00000000000000000000000000000000;//0


        //================
        //=====================

        #37000 str_sig=1;
        #37200 str_sig=0;

        #37000 real_x1=32'b00111111110001010001111010111000;//1.54
        #37000 imag_x1=32'b11000000001000001010001111010111;//-2.51

        #37000 real_x0=32'b01000001000111011110101110000101;//9.87
        #37000 imag_x0=32'b10111110101011110001101010100000;//-0.342

        #37000 real_w=32'b00111111100000000000000000000000;//1
        #37000 imag_w=32'b00000000000000000000000000000000;//0

        #43000 str_sig=1;
        #43200 str_sig=0;

        #43000 imag_w=32'b00111111100000000000000000000000;//1
        #43000 real_w=32'b00000000000000000000000000000000;//0

    join

always #(200/2) clk = ~clk;

endmodule
