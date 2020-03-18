module fft(
    input wire clk,
    input wire rst_n,
    input wire str_sig,
    input wire switch,  //  1:fft  0:ifft
    input wire [31 : 0] real_x0,
    input wire [31 : 0] imag_x0,
    input wire [31 : 0] real_x1,
    input wire [31 : 0] imag_x1,
    input wire [31 : 0] real_x2,
    input wire [31 : 0] imag_x2,
    input wire [31 : 0] real_x3,
    input wire [31 : 0] imag_x3,
    input wire [31 : 0] real_x4,
    input wire [31 : 0] imag_x4,
    input wire [31 : 0] real_x5,
    input wire [31 : 0] imag_x5,
    input wire [31 : 0] real_x6,
    input wire [31 : 0] imag_x6,
    input wire [31 : 0] real_x7,
    input wire [31 : 0] imag_x7,

    output wire [31 : 0] real_y0,
    output wire [31 : 0] imag_y0,
    output wire [31 : 0] real_y1,
    output wire [31 : 0] imag_y1,
    output wire [31 : 0] real_y2,
    output wire [31 : 0] imag_y2,
    output wire [31 : 0] real_y3,
    output wire [31 : 0] imag_y3,
    output wire [31 : 0] real_y4,
    output wire [31 : 0] imag_y4,
    output wire [31 : 0] real_y5,
    output wire [31 : 0] imag_y5,
    output wire [31 : 0] real_y6,
    output wire [31 : 0] imag_y6,
    output wire [31 : 0] real_y7,
    output wire [31 : 0] imag_y7,

    output wire done_sig,
    output wire error

);

    parameter [31 : 0] real_w0=32'b00111111100000000000000000000000;
    parameter [31 : 0] imag_w0=32'h0000;
    parameter [31 : 0] real_w1=32'b00111111001101001111110111110100;
    parameter [31 : 0] imag_w1=32'b10111111001101001111110111110100;
    parameter [31 : 0] real_w2=32'h0000;
    parameter [31 : 0] imag_w2=32'b10111111100000000000000000000000;
    parameter [31 : 0] real_w3=32'b10111111001101001111110111110100;
    parameter [31 : 0] imag_w3=32'b10111111001101001111110111110100;

    parameter [31 : 0] pa_N=32'b00111110000000000000000000000000;

    wire [31 : 0] u1_real_x1,u1_imag_x1,
                  u1_real_x2,u1_imag_x2,
                  u1_real_x3,u1_imag_x3,
                  u1_real_x4,u1_imag_x4,
                  u1_real_x5,u1_imag_x5,
                  u1_real_x6,u1_imag_x6,
                  u1_real_x7,u1_imag_x7,
                  u1_real_x8,u1_imag_x8;

    wire [31 : 0] u2_real_x1,u2_imag_x1,
                  u2_real_x2,u2_imag_x2,
                  u2_real_x3,u2_imag_x3,
                  u2_real_x4,u2_imag_x4,
                  u2_real_x5,u2_imag_x5,
                  u2_real_x6,u2_imag_x6,
                  u2_real_x7,u2_imag_x7,
                  u2_real_x8,u2_imag_x8;

    wire u1_error1,u1_done1,
         u1_error2,u1_done2,
         u1_error3,u1_done3,
         u1_error4,u1_done4,
         u1_error5,u1_done5,
         u1_error6,u1_done6,
         u1_error7,u1_done7,
         u1_error8,u1_done8;

    wire u2_error1,u2_done1,
         u2_error2,u2_done2,
         u2_error3,u2_done3,
         u2_error4,u2_done4,
         u2_error5,u2_done5,
         u2_error6,u2_done6,
         u2_error7,u2_done7,
         u2_error8,u2_done8;

    wire u3_error1,
         u3_error2,
         u3_error3,
         u3_error4,
         u3_error5,
         u3_error6,
         u3_error7,
         u3_error8;


wire [31 : 0] conj_imag_x0,
     conj_imag_x1,
     conj_imag_x2,
     conj_imag_x3,
     conj_imag_x4,
     conj_imag_x5,
     conj_imag_x6,
     conj_imag_x7;


wire [31 : 0] t_real_y0;
wire [31 : 0] t_imag_y0;
wire [31 : 0] t_real_y1;
wire [31 : 0] t_imag_y1;
wire [31 : 0] t_real_y2;
wire [31 : 0] t_imag_y2;
wire [31 : 0] t_real_y3;
wire [31 : 0] t_imag_y3;
wire [31 : 0] t_real_y4;
wire [31 : 0] t_imag_y4;
wire [31 : 0] t_real_y5;
wire [31 : 0] t_imag_y5;
wire [31 : 0] t_real_y6;
wire [31 : 0] t_imag_y6;
wire [31 : 0] t_real_y7;
wire [31 : 0] t_imag_y7;

wire [31 : 0] r_real_y0;
wire [31 : 0] r_imag_y0;
wire [31 : 0] r_real_y1;
wire [31 : 0] r_imag_y1;
wire [31 : 0] r_real_y2;
wire [31 : 0] r_imag_y2;
wire [31 : 0] r_real_y3;
wire [31 : 0] r_imag_y3;
wire [31 : 0] r_real_y4;
wire [31 : 0] r_imag_y4;
wire [31 : 0] r_real_y5;
wire [31 : 0] r_imag_y5;
wire [31 : 0] r_real_y6;
wire [31 : 0] r_imag_y6;
wire [31 : 0] r_real_y7;
wire [31 : 0] r_imag_y7;



wire [31 : 0] conj_imag_y0,
     conj_imag_y1,
     conj_imag_y2,
     conj_imag_y3,
     conj_imag_y4,
     conj_imag_y5,
     conj_imag_y6,
     conj_imag_y7;

wire u3_done1,u4_done1,N_str_sig;


assign conj_imag_x0=switch ? imag_x0 : {~imag_x0[31] , imag_x0[30 : 0]};
assign conj_imag_x1=switch ? imag_x1 : {~imag_x1[31] , imag_x1[30 : 0]};
assign conj_imag_x2=switch ? imag_x2 : {~imag_x2[31] , imag_x2[30 : 0]};
assign conj_imag_x3=switch ? imag_x3 : {~imag_x3[31] , imag_x3[30 : 0]};
assign conj_imag_x4=switch ? imag_x4 : {~imag_x4[31] , imag_x4[30 : 0]};
assign conj_imag_x5=switch ? imag_x5 : {~imag_x5[31] , imag_x5[30 : 0]};
assign conj_imag_x6=switch ? imag_x6 : {~imag_x6[31] , imag_x6[30 : 0]};
assign conj_imag_x7=switch ? imag_x7 : {~imag_x7[31] , imag_x7[30 : 0]};


assign t_imag_y0=switch ? conj_imag_y0 : {~conj_imag_y0[31] , conj_imag_y0[30 : 0]};
assign t_imag_y1=switch ? conj_imag_y1 : {~conj_imag_y1[31] , conj_imag_y1[30 : 0]};
assign t_imag_y2=switch ? conj_imag_y2 : {~conj_imag_y2[31] , conj_imag_y2[30 : 0]};
assign t_imag_y3=switch ? conj_imag_y3 : {~conj_imag_y3[31] , conj_imag_y3[30 : 0]};
assign t_imag_y4=switch ? conj_imag_y4 : {~conj_imag_y4[31] , conj_imag_y4[30 : 0]};
assign t_imag_y5=switch ? conj_imag_y5 : {~conj_imag_y5[31] , conj_imag_y5[30 : 0]};
assign t_imag_y6=switch ? conj_imag_y6 : {~conj_imag_y6[31] , conj_imag_y6[30 : 0]};
assign t_imag_y7=switch ? conj_imag_y7 : {~conj_imag_y7[31] , conj_imag_y7[30 : 0]};

//-----------------------one

butterfly U1_1(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .real_x0(real_x0),
    .imag_x0(conj_imag_x0),
    .real_x1(real_x4),
    .imag_x1(conj_imag_x4),

    .real_w(real_w0),
    .imag_w(imag_w0),

    .real_y0(u1_real_x1),
    .imag_y0(u1_imag_x1),
    .real_y1(u1_real_x2),
    .imag_y1(u1_imag_x2),
    .done_sig(u1_done1),
    .error(u1_error1)
);

butterfly U1_2(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .real_x0(real_x2),
    .imag_x0(conj_imag_x2),
    .real_x1(real_x6),
    .imag_x1(conj_imag_x6),

    .real_w(real_w0),
    .imag_w(imag_w0),

    .real_y0(u1_real_x3),
    .imag_y0(u1_imag_x3),
    .real_y1(u1_real_x4),
    .imag_y1(u1_imag_x4),
    .done_sig(u1_done2),
    .error(u1_error2)
);

butterfly U1_3(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .real_x0(real_x1),
    .imag_x0(conj_imag_x1),
    .real_x1(real_x5),
    .imag_x1(conj_imag_x5),

    .real_w(real_w0),
    .imag_w(imag_w0),

    .real_y0(u1_real_x5),
    .imag_y0(u1_imag_x5),
    .real_y1(u1_real_x6),
    .imag_y1(u1_imag_x6),
    .done_sig(u1_done3),
    .error(u1_error3)
);

butterfly U1_4(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(str_sig),
    .real_x0(real_x3),
    .imag_x0(conj_imag_x3),
    .real_x1(real_x7),
    .imag_x1(conj_imag_x7),

    .real_w(real_w0),
    .imag_w(imag_w0),

    .real_y0(u1_real_x7),
    .imag_y0(u1_imag_x7),
    .real_y1(u1_real_x8),
    .imag_y1(u1_imag_x8),
    .done_sig(u1_done4),
    .error(u1_error4)
);

//-----------------------two

butterfly U2_1(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u1_done1),
    .real_x0(u1_real_x1),
    .imag_x0(u1_imag_x1),
    .real_x1(u1_real_x3),
    .imag_x1(u1_imag_x3),

    .real_w(real_w0),
    .imag_w(imag_w0),

    .real_y0(u2_real_x1),
    .imag_y0(u2_imag_x1),
    .real_y1(u2_real_x3),
    .imag_y1(u2_imag_x3),
    .done_sig(u2_done1),
    .error(u2_error1)
);

butterfly U2_2(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u1_done1),
    .real_x0(u1_real_x2),
    .imag_x0(u1_imag_x2),
    .real_x1(u1_real_x4),
    .imag_x1(u1_imag_x4),

    .real_w(real_w2),
    .imag_w(imag_w2),

    .real_y0(u2_real_x2),
    .imag_y0(u2_imag_x2),
    .real_y1(u2_real_x4),
    .imag_y1(u2_imag_x4),
    .done_sig(u2_done2),
    .error(u2_error2)
);

butterfly U2_3(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u1_done1),
    .real_x0(u1_real_x5),
    .imag_x0(u1_imag_x5),
    .real_x1(u1_real_x7),
    .imag_x1(u1_imag_x7),

    .real_w(real_w0),
    .imag_w(imag_w0),

    .real_y0(u2_real_x5),
    .imag_y0(u2_imag_x5),
    .real_y1(u2_real_x7),
    .imag_y1(u2_imag_x7),
    .done_sig(u2_done3),
    .error(u2_error3)
);

butterfly U2_4(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u1_done1),
    .real_x0(u1_real_x6),
    .imag_x0(u1_imag_x6),
    .real_x1(u1_real_x8),
    .imag_x1(u1_imag_x8),

    .real_w(real_w2),
    .imag_w(imag_w2),

    .real_y0(u2_real_x6),
    .imag_y0(u2_imag_x6),
    .real_y1(u2_real_x8),
    .imag_y1(u2_imag_x8),
    .done_sig(u2_done4),
    .error(u2_error4)
);

//-----------------------three

butterfly U3_1(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u2_done1),
    .real_x0(u2_real_x1),
    .imag_x0(u2_imag_x1),
    .real_x1(u2_real_x5),
    .imag_x1(u2_imag_x5),

    .real_w(real_w0),
    .imag_w(imag_w0),

    .real_y0(t_real_y0),
    .imag_y0(conj_imag_y0),
    .real_y1(t_real_y4),
    .imag_y1(conj_imag_y4),
    .done_sig(),
    .error(u3_error1)
);

butterfly U3_2(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u2_done1),
    .real_x0(u2_real_x2),
    .imag_x0(u2_imag_x2),
    .real_x1(u2_real_x6),
    .imag_x1(u2_imag_x6),

    .real_w(real_w1),
    .imag_w(imag_w1),

    .real_y0(t_real_y1),
    .imag_y0(conj_imag_y1),
    .real_y1(t_real_y5),
    .imag_y1(conj_imag_y5),
    .done_sig(),
    .error(u3_error2)
);

butterfly U3_3(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u2_done1),
    .real_x0(u2_real_x3),
    .imag_x0(u2_imag_x3),
    .real_x1(u2_real_x7),
    .imag_x1(u2_imag_x7),

    .real_w(real_w2),
    .imag_w(imag_w2),

    .real_y0(t_real_y2),
    .imag_y0(conj_imag_y2),
    .real_y1(t_real_y6),
    .imag_y1(conj_imag_y6),
    .done_sig(),
    .error(u3_error3)
);

butterfly U3_4(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(u2_done1),
    .real_x0(u2_real_x4),
    .imag_x0(u2_imag_x4),
    .real_x1(u2_real_x8),
    .imag_x1(u2_imag_x8),

    .real_w(real_w3),
    .imag_w(imag_w3),

    .real_y0(t_real_y3),
    .imag_y0(conj_imag_y3),
    .real_y1(t_real_y7),
    .imag_y1(conj_imag_y7),
    .done_sig(u3_done1),
    .error(u3_error4)
);

//----------------------  1/N

multiplier U4_1(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y0),
    .da_in2(pa_N),
    .da_out(r_real_y0),
    .done_sig(u4_done1),
    .error()
);

multiplier U4_2(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y0),
    .da_in2(pa_N),
    .da_out(r_imag_y0),
    .done_sig(),
    .error()
);

multiplier U4_3(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y1),
    .da_in2(pa_N),
    .da_out(r_real_y1),
    .done_sig(),
    .error()
);

multiplier U4_4(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y1),
    .da_in2(pa_N),
    .da_out(r_imag_y1),
    .done_sig(),
    .error()
);

multiplier U4_5(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y2),
    .da_in2(pa_N),
    .da_out(r_real_y2),
    .done_sig(),
    .error()
);

multiplier U4_6(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y2),
    .da_in2(pa_N),
    .da_out(r_imag_y2),
    .done_sig(),
    .error()
);

multiplier U4_7(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y3),
    .da_in2(pa_N),
    .da_out(r_real_y3),
    .done_sig(),
    .error()
);

multiplier U4_8(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y3),
    .da_in2(pa_N),
    .da_out(r_imag_y3),
    .done_sig(),
    .error()
);

multiplier U4_9(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y4),
    .da_in2(pa_N),
    .da_out(r_real_y4),
    .done_sig(),
    .error()
);

multiplier U4_10(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y4),
    .da_in2(pa_N),
    .da_out(r_imag_y4),
    .done_sig(),
    .error()
);

multiplier U4_11(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y5),
    .da_in2(pa_N),
    .da_out(r_real_y5),
    .done_sig(),
    .error()
);

multiplier U4_12(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y5),
    .da_in2(pa_N),
    .da_out(r_imag_y5),
    .done_sig(),
    .error()
);

multiplier U4_13(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y6),
    .da_in2(pa_N),
    .da_out(r_real_y6),
    .done_sig(),
    .error()
);

multiplier U4_14(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y6),
    .da_in2(pa_N),
    .da_out(r_imag_y6),
    .done_sig(),
    .error()
);

multiplier U4_15(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_real_y7),
    .da_in2(pa_N),
    .da_out(r_real_y7),
    .done_sig(),
    .error()
);

multiplier U4_16(
    .clk(clk),
    .rst_n(rst_n),
    .str_sig(N_str_sig),
    .da_in1(t_imag_y7),
    .da_in2(pa_N),
    .da_out(r_imag_y7),
    .done_sig(),
    .error()
);


//--------------------------


assign N_str_sig=switch ? 1'b0 : u3_done1;
assign done_sig=switch ? u3_done1 : u4_done1;

assign real_y0=switch ? t_real_y0 : r_real_y0;
assign real_y1=switch ? t_real_y1 : r_real_y1;
assign real_y2=switch ? t_real_y2 : r_real_y2;
assign real_y3=switch ? t_real_y3 : r_real_y3;
assign real_y4=switch ? t_real_y4 : r_real_y4;
assign real_y5=switch ? t_real_y5 : r_real_y5;
assign real_y6=switch ? t_real_y6 : r_real_y6;
assign real_y7=switch ? t_real_y7 : r_real_y7;

assign imag_y0=switch ? t_imag_y0 : r_imag_y0;
assign imag_y1=switch ? t_imag_y1 : r_imag_y1;
assign imag_y2=switch ? t_imag_y2 : r_imag_y2;
assign imag_y3=switch ? t_imag_y3 : r_imag_y3;
assign imag_y4=switch ? t_imag_y4 : r_imag_y4;
assign imag_y5=switch ? t_imag_y5 : r_imag_y5;
assign imag_y6=switch ? t_imag_y6 : r_imag_y6;
assign imag_y7=switch ? t_imag_y7 : r_imag_y7;



assign error=u1_error1 | u1_error2 | u1_error3 | u1_error4 |
             u2_error1 | u2_error2 | u2_error3 | u2_error4 |
             u3_error1 | u3_error2 | u3_error3 | u3_error4;



endmodule
