`timescale 1ns/1ns

module tb_fft();

reg clk,rst_n,str_sig,switch;  //  1:fft  0:ifft
reg [31 : 0] real_x0,imag_x0,
             real_x1,imag_x1,
             real_x2,imag_x2,
             real_x3,imag_x3,
             real_x4,imag_x4,
             real_x5,imag_x5,
             real_x6,imag_x6,
             real_x7,imag_x7;

     wire [31 : 0] real_y0;
     wire [31 : 0] imag_y0;
     wire [31 : 0] real_y1;
     wire [31 : 0] imag_y1;
     wire [31 : 0] real_y2;
     wire [31 : 0] imag_y2;
     wire [31 : 0] real_y3;
     wire [31 : 0] imag_y3;
     wire [31 : 0] real_y4;
     wire [31 : 0] imag_y4;
     wire [31 : 0] real_y5;
     wire [31 : 0] imag_y5;
     wire [31 : 0] real_y6;
     wire [31 : 0] imag_y6;
     wire [31 : 0] real_y7;
     wire [31 : 0] imag_y7;

     wire done_sig;
     wire error;






fft U_fft(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .switch(switch),  //  1:fft  0:ifft
    .real_x0(real_x0),
    .imag_x0(imag_x0),
    .real_x1(real_x1),
    .imag_x1(imag_x1),
    .real_x2(real_x2),
    .imag_x2(imag_x2),
    .real_x3(real_x3),
    .imag_x3(imag_x3),
    .real_x4(real_x4),
    .imag_x4(imag_x4),
    .real_x5(real_x5),
    .imag_x5(imag_x5),
    .real_x6(real_x6),
    .imag_x6(imag_x6),
    .real_x7(real_x7),
    .imag_x7(imag_x7),

    .real_y0(real_y0),
    .imag_y0(imag_y0),
    .real_y1(real_y1),
    .imag_y1(imag_y1),
    .real_y2(real_y2),
    .imag_y2(imag_y2),
    .real_y3(real_y3),
    .imag_y3(imag_y3),
    .real_y4(real_y4),
    .imag_y4(imag_y4),
    .real_y5(real_y5),
    .imag_y5(imag_y5),
    .real_y6(real_y6),
    .imag_y6(imag_y6),
    .real_y7(real_y7),
    .imag_y7(imag_y7),

    .done_sig(done_sig),
    .error(error)

);

integer fp_w;

initial
fork
clk=0;
rst_n=0;
#600 rst_n=1;
switch=1;
str_sig=0;
#1000 str_sig=1;
#1400 str_sig=0;

#1000 real_x0=32'b01000000010000000000000000000000;//3
#1000 imag_x0=32'b00111111100000000000000000000000;//1

#1000 real_x1=32'b01000000100000000000000000000000;//4
#1000 imag_x1=32'b11000000000000000000000000000000;//-2

#1000 real_x2=32'b01000000000001100110011001100110;//2.1
#1000 imag_x2=32'b01000000111001100110011001100110;//7.2

#1000 real_x3=32'b01000000010100110011001100110011;//3.3
#1000 imag_x3=32'b01000000100100000000000000000000;//4.5

#1000 real_x4=32'b11000000011010011100101011000001;//-3.653
#1000 imag_x4=32'b11000001010000011100001010001111;//-12.11

#1000 real_x5=32'b10111110011000010100011110101110;//-0.22
#1000 imag_x5=32'b01000000010010010010011011101001;//3.143

#1000 real_x6=32'b01000001000111011110101110000101;//9.87
#1000 imag_x6=32'b10111110101011110001101010100000;//-0.342

#1000 real_x7=32'b00111111110001010001111010111000;//1.54
#1000 imag_x7=32'b11000000001000001010001111010111;//-2.51



 
#80000 switch=0;
#80000 str_sig=1;
#80400 str_sig=0;

#80000 real_x0=32'h419f7efa;//3
#80000 imag_x0=32'hbf8f3b64;//1

#80000 real_x1=32'h418a0895;//4
#80000 imag_x1=32'h4100f5a0;//-2

#80000 real_x2=32'hc157851f;//2.1
#80000 imag_x2=32'hc1874396;//7.2

#80000 real_x3=32'hbfa774be;//3.3
#80000 imag_x3=32'h411b44dc;//4.5

#80000 real_x4=32'h402c9ba8;//-3.653
#80000 imag_x4=32'hc0ec51eb;//-12.11

#80000 real_x5=32'h41322c49;//-0.22
#80000 imag_x5=32'h4206ccd5;//3.143

#80000 real_x6=32'hc13c6a7f;//9.87
#80000 imag_x6=32'hc1983958;//-0.342

#80000 real_x7=32'hbef082e8;//1.54
#80000 imag_x7=32'h3f79c6b0;
       
#158200 rst_n=0;
#158600 rst_n=1;
#159000 switch=1;
#159000 str_sig=1;
#159400 str_sig=0;

#159000 real_x0=32'b01000000000100110001010000010010;//3
#159000 imag_x0=32'b00111111111101101101010111010000;//1

#159000 real_x1=32'b00111111000001010101100110110100;//4
#159000 imag_x1=32'b01000000001111010001010011100100;//-2

#159000 real_x2=32'b10111111110000000000000000000000;//2.1
#159000 imag_x2=32'b01000000001001100100011101000101;//7.2

#159000 real_x3=32'b11000000001101000110110000100010;//3.3
#159000 imag_x3=32'b00111111100000110101011100111111;//4.5

#159000 real_x4=32'b01000000001101000110110000100010;//-3.653
#159000 imag_x4=32'b00111111100000110101011100111111;//-12.11

#159000 real_x5=32'b10111111110000000000000000000000;//-0.22
#159000 imag_x5=32'b11000000001001100100011101000101;//3.143

#159000 real_x6=32'b00111111000001010101100110110100;//9.87
#159000 imag_x6=32'b11000000001111010001010011100100;//-0.342

#159000 real_x7=32'b01000000000100110001010000010010;//1.54
#159000 imag_x7=32'b10111111111101101101010111010000;


#238000 switch=0;
#238000 str_sig=1;
#238400 str_sig=0;

#238000 real_x0=32'h4028d4ff;//3
#238000 imag_x0=32'h40035740;//22

#238000 real_x1=32'h4180bd9e;
#238000 imag_x1=32'h40de5ec9;//-2

#238000 real_x2=32'h40eb5b58;//2.1
#238000 imag_x2=32'h407135aa;//7.2

#238000 real_x3=32'hc0a361cb;//3.3
#238000 imag_x3=32'hbf442c5f;//4.5

#238000 real_x4=32'h40b46c23;//-3.653
#238000 imag_x4=32'h40493a93;//-12.11

#238000 real_x5=32'hc0c0f25f;//-0.22
#238000 imag_x5=32'hbf8d244c;//3.143

#238000 real_x6=32'h409ace70;//9.87
#238000 imag_x6=32'h403692a4;//-0.342

#238000 real_x7=32'hc0e1526f;//1.54
#238000 imag_x7=32'hbfbc4663;


fp_w=$fopen("D:/fft.txt","w");
//$fmonitor(fp_w,%h",mem);
#10000000 $fclose(fp_w);

join

always@(negedge done_sig) begin
    $fwrite(fp_w,"%h\n",real_y0);
    $fwrite(fp_w,"%h\n",imag_y0);
    $fwrite(fp_w,"%h\n",real_y1);
    $fwrite(fp_w,"%h\n",imag_y1);
    $fwrite(fp_w,"%h\n",real_y2);
    $fwrite(fp_w,"%h\n",imag_y2);
    $fwrite(fp_w,"%h\n",real_y3);
    $fwrite(fp_w,"%h\n",imag_y3);
    $fwrite(fp_w,"%h\n",real_y4);
    $fwrite(fp_w,"%h\n",imag_y4);
    $fwrite(fp_w,"%h\n",real_y5);
    $fwrite(fp_w,"%h\n",imag_y5);
    $fwrite(fp_w,"%h\n",real_y6);
    $fwrite(fp_w,"%h\n",imag_y6);
    $fwrite(fp_w,"%h\n",real_y7);
    $fwrite(fp_w,"%h\f",imag_y7);

end
    


always #(400/2) clk = ~clk;

endmodule
