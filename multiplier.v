module multiplier(clk,rst_n,str_sig,da_in1,da_in2,da_out,done_sig,error);

	input clk;
	input rst_n;
	input str_sig;//开始信号
	input [31:0] da_in1;//[31]Sign [30:23]Exponent [22:0]Mantissa 
	input [31:0] da_in2;
	output reg [31:0] da_out;
	output reg done_sig;//结束信号
	output reg error;
	
	reg [32:0] r_da_in1;//[32]Sign [31:24]Exponent [23]Hidden Bit [22:0]Mantissa
	reg [32:0] r_da_in2;
	reg [47:0] temp;// result Mantissa
	reg [3:0] i;
	reg is_Sign;
	reg is_Over;//上溢
	reg is_Under;//下溢
	reg [9:0] r_da_in2_diff;
	reg [9:0] r_Exp;
	
	reg str1;
	reg str2;
	reg done1;
	reg done2;
	
	reg r_str_sig;
	
	//assign error=is_Over||is_Under;
	
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				str1<=1'b0;
				str2<=1'b0;
				done1<=1'b0;
				done2<=1'b0;
				r_str_sig<=1'b0;
			end
		else 
			begin
				str1<=str_sig;
				str2<=str1;
				done1<=done_sig;
				done2<=done1;
				if((!str2)&&str1)
					r_str_sig<=1'b1;
				else if((!done1)&&done2)
					r_str_sig<=1'b0;
			end
	end
always@(posedge clk or negedge rst_n)
	begin
		if(!rst_n)
			begin
				i<=4'd0;
				r_da_in1<=33'd0;
				r_da_in2<=33'd0;
				done_sig<=1'd0;
				da_out<=32'd0;
				is_Sign<=1'b0;
				is_Over<=1'b0;
				is_Under<=1'b0;
				r_Exp<=10'd0;
                error<=1'b0;
			end
		else if(r_str_sig)
			case(i)
			4'b0000://符号位计算及扩展
			begin
				r_da_in1<={da_in1[31:23],1'b1,da_in1[22:0]};
				r_da_in2<={da_in2[31:23],1'b1,da_in2[22:0]};
				is_Sign<=da_in1[31]^da_in2[31];
				is_Over<=1'b0;
				is_Under<=1'b0;
			   i<=i+1'b1;
			end
			4'b0001://如果两数 阶码相同&&尾数不为零||两数符号位相反 则 阶码加一 尾数右规使r_da_in2变为0.1M 保证尾数相乘后变为1.xxxxxxx
			begin
				if(r_da_in1[31:24]==r_da_in2[31:24]&&(r_da_in1[22:0]!=23'b0&r_da_in2[22:0]!=23'b0)||r_da_in1[32]^r_da_in2[32])
					begin
						r_da_in2[31:24]<=r_da_in2[31:24]+1'b1;
						r_da_in2[23:0]<=r_da_in2[23:0]>>1;
					end
				i<=i+1'b1;
			end
			4'b0010:
			begin
				r_da_in2_diff=r_da_in2[31:24]-8'd127;
				r_Exp<=r_da_in1[31:24]+r_da_in2_diff;//结果阶码 E1+E2-127
				i<=i+1'b1;
			end
			4'b0011://尾数乘法
			begin
				temp<=r_da_in1[23:0]*r_da_in2[23:0];
				i<=i+1'b1;
			end
			4'b0100://规格化处理
			begin
				if(temp[47]==1'b1) temp<=temp;
				else if(temp[46]==1'b1)begin temp<=temp<<1; r_Exp<=r_Exp-5'd1; end
				else if(temp[45]==1'b1)begin temp<=temp<<2; r_Exp<=r_Exp-5'd2; end
				else if(temp[44]==1'b1)begin temp<=temp<<3; r_Exp<=r_Exp-5'd3; end
				else if(temp[43]==1'b1)begin temp<=temp<<4; r_Exp<=r_Exp-5'd4; end
				else if(temp[42]==1'b1)begin temp<=temp<<5; r_Exp<=r_Exp-5'd5; end
				else if(temp[41]==1'b1)begin temp<=temp<<6; r_Exp<=r_Exp-5'd6; end
				else if(temp[40]==1'b1)begin temp<=temp<<7; r_Exp<=r_Exp-5'd7; end
				else if(temp[39]==1'b1)begin temp<=temp<<8; r_Exp<=r_Exp-5'd8; end
				else if(temp[38]==1'b1)begin temp<=temp<<9; r_Exp<=r_Exp-5'd9; end
				else if(temp[37]==1'b1)begin temp<=temp<<10; r_Exp<=r_Exp-5'd10; end
				else if(temp[36]==1'b1)begin temp<=temp<<11; r_Exp<=r_Exp-5'd11; end
				else if(temp[35]==1'b1)begin temp<=temp<<12; r_Exp<=r_Exp-5'd12; end
				else if(temp[34]==1'b1)begin temp<=temp<<13; r_Exp<=r_Exp-5'd13; end
				else if(temp[33]==1'b1)begin temp<=temp<<14; r_Exp<=r_Exp-5'd14; end
				else if(temp[32]==1'b1)begin temp<=temp<<15; r_Exp<=r_Exp-5'd15; end
				else if(temp[31]==1'b1)begin temp<=temp<<16; r_Exp<=r_Exp-5'd16; end
				else if(temp[30]==1'b1)begin temp<=temp<<17; r_Exp<=r_Exp-5'd17; end
				else if(temp[29]==1'b1)begin temp<=temp<<18; r_Exp<=r_Exp-5'd18; end
				else if(temp[28]==1'b1)begin temp<=temp<<19; r_Exp<=r_Exp-5'd19; end
				else if(temp[27]==1'b1)begin temp<=temp<<20; r_Exp<=r_Exp-5'd20; end
				else if(temp[26]==1'b1)begin temp<=temp<<21; r_Exp<=r_Exp-5'd21; end
				else if(temp[25]==1'b1)begin temp<=temp<<22; r_Exp<=r_Exp-5'd22; end
				else if(temp[24]==1'b1)begin temp<=temp<<23; r_Exp<=r_Exp-5'd23; end
				i<=i+1'b1;
			end
			4'b0101:
			begin
				if((da_in1[30:0]==31'b0) | (da_in2[30:0]==31'b0))//zero
					begin
						da_out<=32'b0;
					end
					else if(r_Exp[9:8]==2'b01)//上溢
					begin
						is_Over<=1'b1;
						da_out<={1'b1,8'd127,23'd0};
					end
				else if(r_Exp[9:8]==2'b11)//下溢
					begin
						is_Under<=1'b1;
						da_out<={1'b1,8'd127,23'd0};
					end
					else if(temp[23]==1'b1)//舍入处理
					begin
						da_out<={is_Sign,r_Exp[7:0]+1'b1,temp[46:24]+1'b1};
					end
				else
						da_out<={is_Sign,r_Exp[7:0]+1'b1,temp[46:24]};
				i<=i+1'b1;
			end
			4'b0110:
			begin
				done_sig<=1'b1;
				i<=i+1'b1;
			end
			4'b0111:
			begin
				done_sig<=1'b0;
				i<=i+1'b1;
			end
			4'b1000:
			begin
				i<=i+1'b1;
			end
			4'b1001:
			begin
				i<=1'b0;
			end
			endcase
	end
endmodule
