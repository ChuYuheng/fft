module adder(clk,str_sig,rst_n,da_in1,da_in2,da_out,done_sig,error);

	input clk;
	input rst_n;
	input str_sig;//开始信号
	input [31:0] da_in1;//[31]Sign [30:23]Exponent [22:0]Mantissa 
	input [31:0] da_in2;
	output reg [31:0] da_out;
	output reg done_sig;//结束信号
	output reg error;

	reg [3:0] i;
	reg [56:0] r_da_in1;//[56]Sign [55:48]Exponent [47:46]Hidden Bit [45:23]Mantissa [22:0]M'Backup
	reg [56:0] r_da_in2;
	reg [48:0] temp,temp_da_in1,temp_da_in2;//[48]Sign [47:46]Hidden Bit [45:23]Mantissa [22:0]M'Backup
	reg [9:0] r_Exp;//[9:8]溢出检查  [7:0]阶码之差
	reg [9:0] r_Exp_dif;//[7:0]阶码之差
	reg is_Sign;
	reg is_Over;//上溢
	reg is_Under;//下溢
	//reg is_Zero;
	
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
				r_da_in1<=57'b0;
				r_da_in2<=57'b0;
				temp<=49'b0;
				temp_da_in1<=49'b0;
				temp_da_in2<=49'b0;
				r_Exp<=10'b0;
				r_Exp_dif<=8'b0;
				is_Sign<=1'b0;
				is_Over<=1'b0;
				is_Under<=1'b0;
				//is_Zero<=1'b0;
				da_out<=1'b0;
				done_sig<=1'b0;
                error<=1'b0;
			end
		else if(r_str_sig)
			case(i)
			4'b0000://extended sign bit 加符号位进行溢出判断
			begin
				r_da_in1<={da_in1[31],da_in1[30:23],2'b01,da_in1[22:0],23'd0};
			   r_da_in2<={da_in2[31],da_in2[30:23],2'b01,da_in2[22:0],23'd0};
				is_Over<=1'b0;
				is_Under<=1'b0;
				//is_Zero<=1'b0;
			   i<=i+1'b1;
			end
			4'b0001://diffrence between order codes
			begin
				r_Exp=da_in1[30:23]-da_in2[30:23];
				if(r_Exp[8]==1)
					r_Exp_dif<=~r_Exp+1'b1;
				else
					r_Exp_dif<=r_Exp;
				i<=i+1'b1;
			end
			4'b0010://阶码对齐即使其阶码相同
			begin
				if(r_Exp[8]==1)
					begin
						r_da_in1[47:0]<=r_da_in1[47:0]>>r_Exp_dif;
						r_da_in1[55:48]<=r_da_in2[55:48];
					end
				else 
					begin
						r_da_in2[47:0]<=r_da_in2[47:0]>>r_Exp_dif;
						r_da_in2[55:48]<=r_da_in1[55:48];
					end
				i<=i+1'b1;
			end
			4'b0011://尾数运算预处理
			begin
				temp_da_in1<=r_da_in1[56]?{r_da_in1[56],(~r_da_in1[47:0]+1'b1)}:{r_da_in1[56],r_da_in1[47:0]};
				temp_da_in2<=r_da_in2[56]?{r_da_in2[56],(~r_da_in2[47:0]+1'b1)}:{r_da_in2[56],r_da_in2[47:0]};
				i<=i+1'b1;
			end
			4'b0100://addition
			begin
				temp<=temp_da_in1+temp_da_in2;//符号位放到尾数之前，求尾数之和
				i<=i+1'b1;
			end
			4'b0101://结果预处理
			begin
				is_Sign<=temp[48];
				if(temp[48]==1'b1)
					temp<=~temp+1'b1;
				r_Exp<={2'b00,r_da_in1[55:48]};//阶码
				i<=i+1'b1;
			end
			4'b0110://通过隐藏位对结果规格化
			begin
				if(temp[47:46]==2'b10||temp[47:46]==2'b11)begin temp<=temp>>1;r_Exp<=r_Exp+1'b1; end
				else if(temp[47:46]==2'b00&&temp[45])begin temp<=temp<<1;r_Exp<=r_Exp-5'd1; end
				else if(temp[47:46]==2'b00&&temp[44])begin temp<=temp<<2;r_Exp<=r_Exp-5'd2; end
			   else if(temp[47:46]==2'b00&&temp[43])begin temp<=temp<<3;r_Exp<=r_Exp-5'd3; end
				else if(temp[47:46]==2'b00&&temp[42])begin temp<=temp<<4;r_Exp<=r_Exp-5'd4; end
				else if(temp[47:46]==2'b00&&temp[41])begin temp<=temp<<5;r_Exp<=r_Exp-5'd5; end
				else if(temp[47:46]==2'b00&&temp[40])begin temp<=temp<<6;r_Exp<=r_Exp-5'd6; end
				else if(temp[47:46]==2'b00&&temp[39])begin temp<=temp<<7;r_Exp<=r_Exp-5'd7; end
				else if(temp[47:46]==2'b00&&temp[38])begin temp<=temp<<8;r_Exp<=r_Exp-5'd8; end
				else if(temp[47:46]==2'b00&&temp[37])begin temp<=temp<<9;r_Exp<=r_Exp-5'd9; end
				else if(temp[47:46]==2'b00&&temp[36])begin temp<=temp<<10;r_Exp<=r_Exp-5'd10; end
				else if(temp[47:46]==2'b00&&temp[35])begin temp<=temp<<11;r_Exp<=r_Exp-5'd11; end
				else if(temp[47:46]==2'b00&&temp[34])begin temp<=temp<<12;r_Exp<=r_Exp-5'd12; end
				else if(temp[47:46]==2'b00&&temp[33])begin temp<=temp<<13;r_Exp<=r_Exp-5'd13; end
				else if(temp[47:46]==2'b00&&temp[32])begin temp<=temp<<14;r_Exp<=r_Exp-5'd14; end
				else if(temp[47:46]==2'b00&&temp[31])begin temp<=temp<<15;r_Exp<=r_Exp-5'd15; end
				else if(temp[47:46]==2'b00&&temp[30])begin temp<=temp<<16;r_Exp<=r_Exp-5'd16; end
				else if(temp[47:46]==2'b00&&temp[29])begin temp<=temp<<17;r_Exp<=r_Exp-5'd17; end
				else if(temp[47:46]==2'b00&&temp[28])begin temp<=temp<<18;r_Exp<=r_Exp-5'd18; end
				else if(temp[47:46]==2'b00&&temp[27])begin temp<=temp<<19;r_Exp<=r_Exp-5'd19; end
				else if(temp[47:46]==2'b00&&temp[26])begin temp<=temp<<20;r_Exp<=r_Exp-5'd20; end
				else if(temp[47:46]==2'b00&&temp[25])begin temp<=temp<<21;r_Exp<=r_Exp-5'd21; end
				else if(temp[47:46]==2'b00&&temp[24])begin temp<=temp<<22;r_Exp<=r_Exp-5'd22; end
				else if(temp[47:46]==2'b00&&temp[23])begin temp<=temp<<23;r_Exp<=r_Exp-5'd23; end
				i<=i+1'b1;
			end
			4'b0111://舍入处理
			begin
				if((da_in1[30:0]==31'b0)&&(da_in2[30:0]==31'b0))//两数为零
					begin
						da_out<=32'b0;
					end
                    else if((da_in1[30:0]==31'b0)&&(da_in2[30:0]!=31'b0)) begin
                        da_out<=da_in2;
                    end
                    else if((da_in1[30:0]!=31'b0)&&(da_in2[30:0]==31'b0)) begin
                        da_out<=da_in1;
                    end
				else if(r_Exp[9:8]==2'b01)//上溢  双符号位计算加减时，01代表加法结果为正数，阶码大于11111110，产生上溢
					begin
						is_Over<=1'b1;
						da_out<={1'b0,8'd127,23'd0};
					end
				else if(r_Exp[9:8]==2'b11)//下溢  双符号位计算加减时，11代表减法结果为负数，阶码小于00000001，产生下溢
					begin
						is_Under<=1'b1;
						da_out<={1'b0,8'd127,23'd0};
					end
					else if(temp[22]==1'b1)//舍入处理
					begin
						da_out<={is_Sign,r_Exp[7:0],temp[45:23]+1'b1};//这里加一可能导致尾数溢出，没有解决
					end
				else
						da_out<={is_Sign,r_Exp[7:0],temp[45:23]};
				i<=i+1'b1;
			end
			4'b1000:
			begin
				done_sig<=1'b1;
				i<=i+1'b1;
			end
			4'b1001:
			begin
				done_sig<=1'b0;
				i<=i+1'b1;
			end
			4'b1010:
			begin
				i<=i+1'b1;
			end
			4'b1011:
			begin
				i<=1'b0;
			end
			endcase
		
	end 
endmodule
