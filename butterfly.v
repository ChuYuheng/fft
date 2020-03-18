module butterfly(
    input wire clk,
    input wire rst_n,
    input wire str_sig,
    input wire [31 : 0] real_x0,
    input wire [31 : 0] imag_x0,
    input wire [31 : 0] real_x1,
    input wire [31 : 0] imag_x1,

    input wire [31 : 0] real_w,
    input wire [31 : 0] imag_w,


    output wire [31 : 0] real_y0,
    output wire [31 : 0] imag_y0,
    output wire [31 : 0] real_y1,
    output wire [31 : 0] imag_y1,
    output wire done_sig,
    output wire error
);


wire [31 : 0] y1,y2,y3,y4,z1,z2;
wire done_m1,error_m1,
     done_m2,error_m2,
     done_m3,error_m3,
     done_m4,error_m4,
     done_a1,error_a1,
     done_a2,error_a2,
     error_c1,error_c2,
     error_c3,eror_c4;




multiplier m1(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .da_in1(real_x1),
    .da_in2(real_w),
    .da_out(y1),
    .done_sig(done_m1),
    .error(error_m1)
);

multiplier m2(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .da_in1(imag_x1),
    .da_in2(imag_w),
    .da_out(y2),
    .done_sig(done_m2),
    .error(error_m2)
);

multiplier m3(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .da_in1(real_x1),
    .da_in2(imag_w),
    .da_out(y3),
    .done_sig(done_m3),
    .error(error_m3)
);

multiplier m4(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .da_in1(imag_x1),
    .da_in2(real_w),
    .da_out(y4),
    .done_sig(done_m4),
    .error(error_m4)
);

adder a1(
    .clk(clk),
    .str_sig(done_m1),
    .rst_n(rst_n),
    .da_in1(y1),
    .da_in2({~y2[31] , y2[30 : 0]}),
    .da_out(z1),
    .done_sig(done_a1),
    .error(error_a1)
);

adder a2(
    .clk(clk),
    .str_sig(done_m1),
    .rst_n(rst_n),
    .da_in1(y3),
    .da_in2(y4),
    .da_out(z2),
    .done_sig(done_a2),
    .error(error_a2)
);

adder c1(
    .clk(clk),
    .str_sig(done_a2),
    .rst_n(rst_n),
    .da_in1(real_x0),
    .da_in2(z1),
    .da_out(real_y0),
    .done_sig(),
    .error(error_c1)
);

adder c2(
    .clk(clk),
    .str_sig(done_a2),
    .rst_n(rst_n),
    .da_in1(imag_x0),
    .da_in2(z2),
    .da_out(imag_y0),
    .done_sig(),
    .error(error_c2)
);

adder c3(
    .clk(clk),
    .str_sig(done_a2),
    .rst_n(rst_n),
    .da_in1(real_x0),
    .da_in2({~z1[31] , z1[30 : 0]}),
    .da_out(real_y1),
    .done_sig(),
    .error(error_c3)
);

adder c4(
    .clk(clk),
    .str_sig(done_a2),
    .rst_n(rst_n),
    .da_in1(imag_x0),
    .da_in2({~z2[31] , z2[30 : 0]}),
    .da_out(imag_y1),
    .done_sig(done_sig),
    .error(error_c4)
);

assign error=error_m1 | error_m2 | error_a1 | error_a2 | error_c1 | error_c2 | error_c3 | error_c4;


endmodule
