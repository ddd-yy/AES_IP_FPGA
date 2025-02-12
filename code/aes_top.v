module AES128(
    input clk,
    input rstn,
    input en, // AES����ʹ���ź�(key�Ƿ����??ʼgenerate)

    input data_in_valid, // ���������Ƿ���Ч
    input [127:0] data_in, // �������??

    output aes_state, // AES����״???
    output rk_ready, // ��Կ׼����������ʾ���Կ�ʼ��??

    output data_out_valid, // ��������Ƿ���Ч
    output [127:0] data_out, // �������??

    input [127:0] key_in, // �������??

    input slt_module // ѡ�����/����ģʽ��Ĭ�ϼ��ܣ�������ʱû����ɽ��ܣ��ݲ�???�ǽ���ģʽ??
    
);

reg rk_ready_reg;
wire data_out_valid_reg;
wire [127:0] data_out_reg;

reg aes_state_reg;

assign rk_ready = rk_ready_reg;
assign data_out_valid = data_out_valid_reg;
assign data_out = data_out_reg;

assign aes_state = aes_state_reg;

reg [127:0] ROUND_KEY [0:9];
reg [127:0] NEXT_KEY [0:10];


//��״̬��ʵ����Կ��չ,����??
parameter IDLE =2'b00,GENERATING=2'b01,DONE=2'b10 ;
reg [1:0] current_state,next_state;
reg [3:0] i;
reg [127:0]in_key;
wire [127:0]out_key;
reg [3:0]round;

always @(posedge clk or negedge rstn) begin
    if(!rstn)begin
        current_state<=IDLE;
    end
    else begin
        current_state<=next_state;
    end
end
//always @(posedge clk or negedge rstn) begin
//    if(!rstn)next_state<=IDLE;
//    else begin
//        next_state<=next_state;
//    end
//end
always @(posedge clk or negedge rstn) begin
    if(!rstn)i<=0;
    else if(current_state==GENERATING)begin
        if(NEXT_KEY[i+1]&&i<10)i<=i+1;
    end
end
always @(*) begin
    case(current_state)
        IDLE:begin
            if(en&&i==0)begin
                next_state=GENERATING;
            end
            else next_state=IDLE;
        end
        GENERATING:begin
            if(i<10) begin
                next_state=GENERATING;
            end
            else begin
                next_state=DONE;
            end
        end
        DONE:begin
            next_state=IDLE;
        end
        default:next_state=next_state;
    endcase
end
//����߼���case, ifĬ���������ȼ���
always @(*) begin
    NEXT_KEY[0]=key_in;
    case(current_state)
        GENERATING:begin
        NEXT_KEY[i+1]=out_key;
        ROUND_KEY[i]=NEXT_KEY[i+1];
        in_key=NEXT_KEY[i];
        round=i;
        end
    endcase
end
GENERATE_KEY K_inst(
    .ROUND_KEY(round),
    .IN_KEY(in_key),
    .OUT_KEY(out_key)
);

//��Կ׼��״???
always @(posedge clk or negedge rstn) begin
    if(!rstn)rk_ready_reg<=1'b0;
    else if(current_state==DONE)begin
        rk_ready_reg<=1'b1;
    end
    else begin
        rk_ready_reg<=rk_ready_reg;
    end
end

// AES״???����???��
always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        aes_state_reg <= 1'b0;
    end else if (rk_ready_reg && data_in_valid) begin
        aes_state_reg <= 1'b1;
    end else begin
        aes_state_reg <= aes_state_reg; // ���� aes_state_reg ?? 0
    end
end

//��Կ׼��״???
//always @(posedge clk or negedge rstn) begin
//    if(!rstn)rk_ready_reg<=1'b0;
//    else if(current_state==DONE)begin
//        rk_ready_reg<=1'b1;
//    end
//    else if(current_state==GENERATING)begin
//        rk_ready_reg<=1'b0;
//    end
//    else begin
//        rk_ready_reg<=rk_ready_reg;
//    end
//end

//// AES״???����???��  ��Կ������������������ʱ������δ������1����Կ��������������������0
//always @(posedge clk or negedge rstn) begin
//    if (!rstn) begin
//        aes_state_reg <= 1'b0;
//    end else if (rk_ready==1'b1&&data_out_valid==1'b0&&data_in_valid==1'b1) begin
//        aes_state_reg <= 1'b1;
//     end else if(data_out_valid==1'b1&&rk_ready==1'b1) begin
//         aes_state_reg <= 1'b0; 
//    end
//    else begin
//        aes_state_reg <= aes_state_reg; 
//    end
//end

//��ˮ��ʵ�ּ�??
parameter PIPLINE_DEPTH = 10;
wire [127:0] pip_data_in [0:PIPLINE_DEPTH];
wire flag [0:PIPLINE_DEPTH-1];
reg [127:0] pip_data_in_reg [0:PIPLINE_DEPTH-1];
reg [127:0]ROUND_KEY_reg [0:PIPLINE_DEPTH-1];
reg flag_reg [0:PIPLINE_DEPTH-1];
reg valid [0:PIPLINE_DEPTH-1];

//�������
assign data_out_valid_reg=valid[PIPLINE_DEPTH-1];
assign data_out_reg=data_out_valid?pip_data_in[PIPLINE_DEPTH]:128'b0;

//��������
assign pip_data_in[0] = (data_in_valid&&rk_ready)?data_in^key_in:128'bx;

generate
    genvar R2;
    for(R2=0;R2<PIPLINE_DEPTH;R2=R2+1)begin:R_inst
        assign flag[R2]=(R2==PIPLINE_DEPTH-1)?1'b1:1'b0;
        always @(posedge clk) begin
            if(!rstn)begin
                pip_data_in_reg[R2]<=128'b0;
                ROUND_KEY_reg[R2]<=128'b0;
                flag_reg[R2]<=1'b0;
                valid[R2]<=1'b0;
            end
            else begin
                pip_data_in_reg[R2]<=pip_data_in[R2];
                ROUND_KEY_reg[R2]<=ROUND_KEY[R2];
                flag_reg[R2]<=flag[R2];
                if(R2==0)begin
                    valid[R2]<=data_in_valid;
                end
                else begin
                    valid[R2]<=valid[R2-1];
                end
            end
        end
        ROUND_ITERATION inst(
            .IN_DATA(pip_data_in_reg[R2]),
            .IN_KEY(ROUND_KEY_reg[R2]),
            .LAST_ROUND_FLAG(flag_reg[R2]), // ��־�Ƿ������һ??
            .OUT_DATA(pip_data_in[R2+1])
        ); 
    end
endgenerate

endmodule