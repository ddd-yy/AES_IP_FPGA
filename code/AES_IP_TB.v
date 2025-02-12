module aes_ip_tb;

parameter  C_M_AXI_BURST_LEN	        = 16                   ;
parameter  C_M_AXI_ID_WIDTH	            = 1                     ;   
parameter  C_M_AXI_ADDR_WIDTH	        = 32                    ;   
parameter  C_M_AXI_DATA_WIDTH	        = 128                   ;   
parameter  C_M_AXI_AWUSER_WIDTH	        = 0                     ;   
parameter  C_M_AXI_ARUSER_WIDTH	        = 0                     ;   
parameter  C_M_AXI_WUSER_WIDTH	        = 0                     ;   
parameter  C_M_AXI_RUSER_WIDTH	        = 0                     ;   
parameter  C_M_AXI_BUSER_WIDTH	        = 0                     ;
reg                                   s_apb_pclk   ;
reg                                   s_apb_paresetn;
reg   [31:0]                          s_apb_paddr  ;
reg                                   s_apb_penable;
reg                                   s_apb_psel   ;
reg   [31:0]                          s_apb_pwdata ;
reg                                   s_apb_pwrite ;
wire  [31:0]                          s_apb_prdata ;
wire                                  s_apb_pready ;
wire                                  s_apb_pslverr;

reg                                   M_AXI_ACLK   ;
reg                                   M_AXI_ARESETN;
wire  [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_AWID   ;
wire  [C_M_AXI_ADDR_WIDTH-1 : 0]      M_AXI_AWADDR ;
wire  [7 : 0]                         M_AXI_AWLEN  ;
wire  [2 : 0]                         M_AXI_AWSIZE ;
wire  [1 : 0]                         M_AXI_AWBURST;
wire                                  M_AXI_AWLOCK ;
wire  [3 : 0]                         M_AXI_AWCACHE;
wire  [2 : 0]                         M_AXI_AWPROT ;
wire  [3 : 0]                         M_AXI_AWQOS  ;
wire  [C_M_AXI_AWUSER_WIDTH-1 : 0]    M_AXI_AWUSER ;
wire                                  M_AXI_AWVALID;
reg                                   M_AXI_AWREADY;

wire  [C_M_AXI_DATA_WIDTH-1 : 0]      M_AXI_WDATA  ;
wire  [C_M_AXI_DATA_WIDTH/8-1 : 0]    M_AXI_WSTRB  ;
wire                                  M_AXI_WLAST  ;
wire  [C_M_AXI_WUSER_WIDTH-1 : 0]     M_AXI_WUSER  ;
wire                                  M_AXI_WVALID ;
reg                                   M_AXI_WREADY ;

reg   [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_BID    ;
reg   [1 : 0]                         M_AXI_BRESP  ;
reg   [C_M_AXI_BUSER_WIDTH-1 : 0]     M_AXI_BUSER  ;
reg                                   M_AXI_BVALID ;
wire                                  M_AXI_BREADY ;

wire  [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_ARID   ;
wire  [C_M_AXI_ADDR_WIDTH-1 : 0]      M_AXI_ARADDR ;
wire  [7 : 0]                         M_AXI_ARLEN  ;
wire  [2 : 0]                         M_AXI_ARSIZE ;
wire  [1 : 0]                         M_AXI_ARBURST;
wire                                  M_AXI_ARLOCK ;
wire  [3 : 0]                         M_AXI_ARCACHE;
wire  [2 : 0]                         M_AXI_ARPROT ;
wire  [3 : 0]                         M_AXI_ARQOS  ;
wire  [C_M_AXI_ARUSER_WIDTH-1 : 0]    M_AXI_ARUSER ;
wire                                  M_AXI_ARVALID;
reg                                   M_AXI_ARREADY;

reg   [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_RID    ;
reg   [C_M_AXI_DATA_WIDTH-1 : 0]      M_AXI_RDATA  ;
reg   [1 : 0]                         M_AXI_RRESP  ;
reg                                   M_AXI_RLAST  ;
reg   [C_M_AXI_RUSER_WIDTH-1 : 0]     M_AXI_RUSER  ;
reg                                   M_AXI_RVALID ;
wire                                  M_AXI_RREADY ;  



reg     [127:0]                  ReadMeM[0:19] ;
reg     [127:0]                  WriteMeM[0:4]; 
reg     [7:0]                    read_count   ;
reg     [7:0]                    write_count  ;  


wire                r_active;
wire                ar_active;
wire                w_active;
wire                aw_active;

assign              ar_active = M_AXI_ARVALID & M_AXI_ARREADY; 
assign              r_active  = M_AXI_RVALID & M_AXI_RREADY; 
assign              w_active  = M_AXI_WVALID & M_AXI_WREADY;
assign              aw_active = M_AXI_AWVALID & M_AXI_AWREADY; 

always@(posedge M_AXI_ACLK)  begin
    ReadMeM[0] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[1] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[2] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[3] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[4] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[5] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[6] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[7] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[8] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[9] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[10] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[11] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[12] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[13] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[14] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[15] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[16] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[17] <= 'h00112233445566778899aabbccddeeff;
    ReadMeM[18] <= 'hffeeddccbbaa99887766554433221100;
    ReadMeM[19] <= 'h00112233445566778899aabbccddeeff;
    // ReadMeM[14] <= 'hffeeddccbbaa99887766554433221100;
/*   
    ReadMeM[0] <= 'h4D7055A12CBD09E1FE13FD46E8718809;
    ReadMeM[1] <= 'h6b3633a5ed04f5abd5197870b5506642;
    ReadMeM[2] <= 'h7c3bc4eb1c18e7f1d879ea602eec46cf;
    ReadMeM[3] <= 'h99cfe9d2b4f88cb9d52049f758e230d9;
    ReadMeM[4] <= 'hd7a7d1b8c65c593ae8694c078c54e853;
*/
end
//ʱ���ź�
always  begin
#10    s_apb_pclk = ~s_apb_pclk; 
end

always begin
#10    M_AXI_ACLK = ~M_AXI_ACLK; 
end
//�������üĴ� ?????
initial begin
    s_apb_psel = 0;
    s_apb_pclk = 0;
    s_apb_paresetn = 1;
    M_AXI_ACLK = 0;
    M_AXI_ARESETN = 1;
#20 
    s_apb_paresetn = 0;
    M_AXI_ARESETN = 0;
#20 
    s_apb_paresetn = 1;
    M_AXI_ARESETN = 1;
#20
    s_apb_pwrite = 1;
    s_apb_psel = 1;
    s_apb_paddr = 32'h0000_001c;
    s_apb_penable = 0;
#20 //����SLT MODULE
    s_apb_penable = 1;
    s_apb_pwdata  = 0;
#20 
    s_apb_paddr = 32'h0000_0018;
#20 //1
    s_apb_penable = 1;
    s_apb_pwdata  = 'd29;
#20 //�����ַ��Ϣ
    s_apb_paddr = 32'h0000_0000;
#20 //������� ?????
    s_apb_penable = 1;
    s_apb_pwdata  = 'h1000;
#20
    s_apb_paddr = 32'h0000_0004;
#20 //����д�� ?????
    s_apb_penable = 1;
    s_apb_pwdata  = 'h2000;
#20 //������Կ��Ϣ
    s_apb_paddr = 32'h0000_0008;
#20 //1
    s_apb_penable = 1;
    s_apb_pwdata  = 'h01234567;
#20 
    s_apb_paddr = 32'h0000_000c;
#20 //2
    s_apb_pwdata  = 'h89abcdef;
    s_apb_penable = 1;
#20 
    s_apb_paddr = 32'h0000_0010;
#20 //3
    s_apb_pwdata  = 'h01234567;
    s_apb_penable = 1;
#20 
    s_apb_paddr = 32'h0000_0014;
#20 //4
    s_apb_pwdata  = 'h89abcdef;
    s_apb_penable = 1;
#40
    s_apb_psel = 0;
#100000000
$finish;
end

always@(posedge s_apb_pclk)begin
    if(!s_apb_paresetn) begin
        s_apb_penable <= 0;
    end
    else if(s_apb_pready) begin
        s_apb_penable <= 0;
    end
end
//��ȡ����
always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        M_AXI_ARREADY <= 0;
    end
    else if (M_AXI_ARREADY) begin
        M_AXI_ARREADY <= 0;
    end
    else if (M_AXI_ARVALID) begin
        M_AXI_ARREADY <= 1;
    end
end

always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        M_AXI_RVALID <= 0;
    end
    else if (M_AXI_RLAST & M_AXI_ARVALID) begin
        M_AXI_RVALID <= 1;
    end
    else if (M_AXI_RLAST & !ar_active) begin
        M_AXI_RVALID <= 0;
    end
    else if (M_AXI_ARREADY) begin
        M_AXI_RVALID <= 1;
    end
end

always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        read_count <= 0;
    end
    else if (M_AXI_RVALID && read_count < C_M_AXI_BURST_LEN) begin
        read_count <= read_count + 1;
    end
    else if (M_AXI_RVALID && read_count == C_M_AXI_BURST_LEN)begin
        read_count <= 0;
    end
    else begin
        read_count <= read_count;
    end
end

always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        M_AXI_RDATA <= 0;
    end
    else if (ar_active) begin
        M_AXI_RDATA <= ReadMeM[read_count];
    end
    else if (r_active && read_count <= C_M_AXI_BURST_LEN) begin
        M_AXI_RDATA <= ReadMeM[read_count+1];
    end
    else begin
        M_AXI_RDATA <= M_AXI_RDATA;
    end    
end

always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        M_AXI_RLAST <= 0;
    end
    else if (read_count == C_M_AXI_BURST_LEN - 1) begin
        M_AXI_RLAST <= 1;
    end
    else begin
        M_AXI_RLAST <= 0;
    end
end
//���ݷ� ??
always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        M_AXI_AWREADY <= 0;
    end
    else if (M_AXI_AWREADY) begin
        M_AXI_AWREADY <= 0;
    end
    else if (M_AXI_AWVALID) begin
        M_AXI_AWREADY <= 1;
    end
end

always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        M_AXI_WREADY <= 0;
    end
    else if (M_AXI_WLAST) begin
        M_AXI_WREADY <= 0;
    end
    else if (aw_active & !M_AXI_WLAST) begin
        M_AXI_WREADY <= 1;
    end
    else begin
        M_AXI_WREADY <= M_AXI_WREADY;
    end
end

always @(posedge M_AXI_ACLK) begin
    if (!M_AXI_ARESETN) begin
        M_AXI_BVALID <= 0;
    end
    else if (M_AXI_WLAST && M_AXI_WREADY && M_AXI_WVALID) begin
        M_AXI_BVALID <= 1;
    end
    else if (M_AXI_BVALID && M_AXI_BREADY) begin
        M_AXI_BVALID <= 0;
    end
end

AES_IP_TOP #
(
    .C_M_AXI_BURST_LEN	            (C_M_AXI_BURST_LEN	    )                 ,
    .C_M_AXI_ID_WIDTH	            (C_M_AXI_ID_WIDTH	    )                 ,
    .C_M_AXI_ADDR_WIDTH	            (C_M_AXI_ADDR_WIDTH	    )                 ,
    .C_M_AXI_DATA_WIDTH	            (C_M_AXI_DATA_WIDTH	    )                 ,
    .C_M_AXI_AWUSER_WIDTH	        (C_M_AXI_AWUSER_WIDTH	)                 ,
    .C_M_AXI_ARUSER_WIDTH	        (C_M_AXI_ARUSER_WIDTH	)                 ,
    .C_M_AXI_WUSER_WIDTH	        (C_M_AXI_WUSER_WIDTH	)                 ,
    .C_M_AXI_RUSER_WIDTH	        (C_M_AXI_RUSER_WIDTH	)                 ,
    .C_M_AXI_BUSER_WIDTH	        (C_M_AXI_BUSER_WIDTH	)
)
AES_ip
(
    .s_apb_pclk              (s_apb_pclk    ),
    .s_apb_paresetn          (s_apb_paresetn),
    .s_apb_paddr             (s_apb_paddr   ),
    .s_apb_penable           (s_apb_penable ),
    .s_apb_psel              (s_apb_psel    ),
    .s_apb_pwdata            (s_apb_pwdata  ),
    .s_apb_pwrite            (s_apb_pwrite  ),
    .s_apb_prdata            (s_apb_prdata  ),
    .s_apb_pready            (s_apb_pready  ),
    .s_apb_pslverr           (s_apb_pslverr ),

    .M_AXI_ACLK              (M_AXI_ACLK    ),
    .M_AXI_ARESETN           (M_AXI_ARESETN ),
 
    .M_AXI_AWID              (M_AXI_AWID    ),
    .M_AXI_AWADDR            (M_AXI_AWADDR  ),
    .M_AXI_AWLEN             (M_AXI_AWLEN   ),
    .M_AXI_AWSIZE            (M_AXI_AWSIZE  ),
    .M_AXI_AWBURST           (M_AXI_AWBURST ),
    .M_AXI_AWLOCK            (M_AXI_AWLOCK  ),
    .M_AXI_AWCACHE           (M_AXI_AWCACHE ),
    .M_AXI_AWPROT            (M_AXI_AWPROT  ),
    .M_AXI_AWQOS             (M_AXI_AWQOS   ),
    .M_AXI_AWUSER            (M_AXI_AWUSER  ),
    .M_AXI_AWVALID           (M_AXI_AWVALID ),
    .M_AXI_AWREADY           (M_AXI_AWREADY ),

    .M_AXI_WDATA             (M_AXI_WDATA   ),
    .M_AXI_WSTRB             (M_AXI_WSTRB   ),
    .M_AXI_WLAST             (M_AXI_WLAST   ),
    .M_AXI_WUSER             (M_AXI_WUSER   ),
    .M_AXI_WVALID            (M_AXI_WVALID  ),
    .M_AXI_WREADY            (M_AXI_WREADY  ),
  
    .M_AXI_BID               (),
    .M_AXI_BRESP             (),
    .M_AXI_BUSER             (),
    .M_AXI_BVALID            (M_AXI_BVALID  ),
    .M_AXI_BREADY            (M_AXI_BREADY  ),

    .M_AXI_ARID              (M_AXI_ARID    ),
    .M_AXI_ARADDR            (M_AXI_ARADDR  ),
    .M_AXI_ARLEN             (M_AXI_ARLEN   ),
    .M_AXI_ARSIZE            (M_AXI_ARSIZE  ),
    .M_AXI_ARBURST           (M_AXI_ARBURST ),
    .M_AXI_ARLOCK            (M_AXI_ARLOCK  ),
    .M_AXI_ARCACHE           (M_AXI_ARCACHE ),
    .M_AXI_ARPROT            (M_AXI_ARPROT  ),
    .M_AXI_ARQOS             (M_AXI_ARQOS   ),
    .M_AXI_ARUSER            (M_AXI_ARUSER  ),
    .M_AXI_ARVALID           (M_AXI_ARVALID ),
    .M_AXI_ARREADY           (M_AXI_ARREADY ),
 
    .M_AXI_RID               (),
    .M_AXI_RDATA             (M_AXI_RDATA   ),
    .M_AXI_RRESP             ('d0   ),
    .M_AXI_RLAST             (M_AXI_RLST   ),
    .M_AXI_RUSER             (),
    .M_AXI_RVALID            (M_AXI_RVALID  ),
    .M_AXI_RREADY            (M_AXI_RREADY  )
);


endmodule