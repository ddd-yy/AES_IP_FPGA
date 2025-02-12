module AES_Config_Register (
    input                   s_apb_pclk                  ,
    input                   s_apb_paresetn              ,
    input   [31:0]          s_apb_paddr                 ,
    input                   s_apb_penable               ,
    input                   s_apb_psel                  ,
    input   [31:0]          s_apb_pwdata                ,
    input                   s_apb_pwrite                ,
    output  [31:0]          s_apb_prdata                ,
    output                  s_apb_pready                ,
    output                  s_apb_pslverr               ,
    input                   AES_STATE                   , 

    output                  OPEN_AES                    , 
    output [127:0]          key_out                     , 
    output                  slt_module                  , 
    output [31:0]           write_addr                  , 
    output [31:0]           read_addr                   

);
//************************************************Wire**********************************************// 
wire                        w_access_active                   ;
wire  [127:0]               w_temp_key                        ; 
wire   [127:0]              w_key_out                         ;     
//**********************************************Register********************************************//

reg   [31:0]                r_read_addr                       ; //0x00
reg   [31:0]                r_write_addr                      ; //0x04
//reg                         r_slt_valid                       
reg   [31:0]               r_key_out0                         ; //0x08
reg   [31:0]               r_key_out1                         ; //0x0c
reg   [31:0]               r_key_out2                         ; //0x10
reg   [31:0]               r_key_out3                         ; //0x14

reg                         r_slt_module                      ; //0x18
reg                         aes_state_1st                     ; //0x1c
reg                         r_open                            ; //0x20
reg                         aes_state_2st                     ; 

reg                         r_slt_ready                       ; //0x24       
reg                         r_waddr_ready                     ; //0x28
reg                         r_raddr_ready                     ; //0x2c
reg                         r_key0_ready                      ; //0x30          
reg                         r_key1_ready                      ; //0x34
reg                         r_key2_ready                      ; //0x38
reg                         r_key3_ready                      ; //0x3c
reg                         r_key_valid                       ; 
reg   [31:0]                r_wdata                           ; 
reg                         r_s_apb_pready                    ;

reg                         r_waddr_valid                     ;
reg                         r_raddr_valid                     ; 
reg   [127:0]               r_key_out                         ;



reg  [31:0]                 r_prdata                          ;

wire                        w_key_ready                       ;



//*******************************************STATE MACHINE******************************************//
//*******************************************COMBINE LOGIC******************************************//
assign                      s_apb_pready    =   r_s_apb_pready                                         ;
assign                      read_addr       =   r_read_addr                                            ;
assign                      write_addr      =   r_write_addr                                           ;
assign                      key_out         =   w_key_out                                              ;
assign                      slt_module      =   r_slt_module                                           ;
assign                      OPEN_AES        =   r_open                                                 ;
assign                      waddr_valid     =   r_waddr_valid                                          ;
assign                      raddr_valid     =   r_raddr_valid                                          ;
assign                      s_apb_pslverr   =   0                                                      ;
assign                      s_apb_prdata    =   r_prdata                                               ;
assign                      w_access_active =   s_apb_psel & s_apb_penable                             ;
assign                      w_temp_key      =   r_key_out << 32                                        ;
assign                      w_key_ready     =   r_key0_ready&r_key1_ready&r_key2_ready&r_key3_ready    ;    
assign                      w_key_out       =   {r_key_out0,r_key_out1,r_key_out2,r_key_out3}          ;
//*****************************************SENQUTIAL LOGIC******************************************//
always @(posedge s_apb_pclk) begin
    if(!s_apb_paresetn) begin
        aes_state_1st <= 0;
        aes_state_2st <= 0;
        r_key_out     <= 0;
    end
    else begin
        aes_state_1st <= AES_STATE     ;
        aes_state_2st <= aes_state_1st ;
        r_key_out     <= w_key_out;
    end
end

always @(posedge s_apb_pclk) begin
    if(!s_apb_paresetn) begin
        r_slt_module  <= 0  ;
        r_read_addr   <= 0  ;
        r_write_addr  <= 0  ;
        r_key_out     <= 0  ;
        r_slt_ready   <= 0  ;
        r_waddr_ready <= 0  ;
        r_raddr_ready <= 0  ;
        r_key0_ready  <= 0  ;
        r_key1_ready  <= 0  ;
        r_key2_ready  <= 0  ;
        r_key3_ready  <= 0  ;
    end
    else if(!aes_state_1st & aes_state_2st) begin
        r_slt_ready   <= 0  ;
        r_waddr_ready <= 0  ;
        r_raddr_ready <= 0  ;
        r_key0_ready  <= 0 ;
        r_key1_ready  <= 0 ;
        r_key2_ready  <= 0 ;
        r_key3_ready  <= 0 ;  
    end

    else if(s_apb_psel & s_apb_pwrite) begin
        case (s_apb_paddr[15:0])
            'h0000: begin
                r_read_addr         <= s_apb_pwdata      ;
                r_raddr_ready       <= 1                 ;
            end 
            'h0004: begin
                r_write_addr        <= s_apb_pwdata      ;
                r_waddr_ready       <= 1                 ;
            end
            'h0008: begin
                r_key_out0          <= s_apb_pwdata      ;
                r_key0_ready        <= 1                 ;
            end
            'h000c: begin
                r_key_out1          <= s_apb_pwdata      ;
                r_key1_ready        <= 1                 ;
            end
            'h0010: begin
                r_key_out2          <= s_apb_pwdata      ;
                r_key2_ready        <= 1                 ;
            end
            'h0014: begin
                r_key_out3          <= s_apb_pwdata      ;
                r_key3_ready        <= 1                 ;
            end
            'h0018: begin
                r_slt_module        <= s_apb_pwdata[0]   ;
                r_slt_ready         <= 1                 ;
            end
        endcase
    end
end

always @(posedge s_apb_pclk) begin
    if (!s_apb_paresetn) begin
        r_prdata <= 0;
    end
    else if(s_apb_psel & !s_apb_pwrite) begin
        case (s_apb_paddr[15:0])
        'h0000: begin
            r_prdata <= r_read_addr  ;
        end 
        'h0004: begin
            r_prdata <= r_write_addr ;
        end
        'h0008: begin
            r_prdata <= r_key_out0   ;
        end
        'h000c: begin
            r_prdata <= r_key_out1   ;
        end
        'h0010: begin
            r_prdata <= r_key_out2   ;
        end
        'h0014: begin
            r_prdata <= r_key_out3   ;
        end
        'h0018: begin
            r_prdata <= {31'h0,r_slt_module};
        end
        'h0040:begin
            r_prdata <= {31'h0,aes_state_1st};
        end
        'h0020:begin
            r_prdata <= {31'h0,r_open};
        end
        'h0024:begin
            r_prdata <= {31'h0,r_slt_ready};
        end
        'h0028:begin
            r_prdata <= {31'h0,r_waddr_ready};
        end
        'h002c:begin
            r_prdata <= {31'h0,r_raddr_ready};
        end
        'h0030:begin
            r_prdata <= {31'h0,r_key0_ready};
        end
        'h0034:begin
            r_prdata <= {31'h0,r_key1_ready};
        end
        'h0038:begin
            r_prdata <= {31'h0,r_key2_ready};
        end
        'h003c:begin
            r_prdata <= {31'h0,r_key3_ready};
        end

        endcase
    end
end


always @(posedge s_apb_pclk) begin
    if(!s_apb_paresetn) begin
        r_s_apb_pready <= 0; 
    end
    else if (r_s_apb_pready) begin
        r_s_apb_pready <= 0;
    end
    else if (w_access_active) begin
        r_s_apb_pready <= 1;
    end
    else begin
        r_s_apb_pready <= 0;
    end
end

always @(posedge s_apb_pclk) begin
    if (!s_apb_paresetn) begin        
        r_open        <= 0 ;      
    end
    else if (r_waddr_ready & r_raddr_ready & r_slt_ready & w_key_ready & !AES_STATE) begin
        r_open         <= 1;
    end
    else if (!aes_state_1st & aes_state_2st) begin
        r_open        <= 0 ;  
    end
end



always @(posedge s_apb_pclk) begin
    if (!s_apb_paresetn) begin
        r_wdata <= 0;
    end
    else begin
        r_wdata <= s_apb_pwdata;
    end
end
//*******************************************COMPONENT**********************************************//
endmodule