
module  AES_IP_TOP #
(
    parameter integer C_M_AXI_BURST_LEN           = 16                   , //1 16 64 128
    parameter integer C_M_AXI_ID_WIDTH            = 1                     ,
    parameter integer C_M_AXI_ADDR_WIDTH          = 32                    ,
    parameter integer C_M_AXI_DATA_WIDTH          = 128                   ,
    parameter integer C_M_AXI_AWUSER_WIDTH        = 0                     ,
    parameter integer C_M_AXI_ARUSER_WIDTH        = 0                     ,
    parameter integer C_M_AXI_WUSER_WIDTH         = 0                     ,
    parameter integer C_M_AXI_RUSER_WIDTH         = 0                     ,
    parameter integer C_M_AXI_BUSER_WIDTH         = 0
)
(
    input                                   s_apb_pclk              ,
    input                                   s_apb_paresetn          ,
    input   [31:0]                          s_apb_paddr             ,
    input                                   s_apb_penable           ,
    input                                   s_apb_psel              ,
    input   [31:0]                          s_apb_pwdata            ,
    input                                   s_apb_pwrite            ,
    output  [31:0]                          s_apb_prdata            ,
    output                                  s_apb_pready            ,
    output                                  s_apb_pslverr           ,

    input                                   M_AXI_ACLK              ,
    input                                   M_AXI_ARESETN           ,

    output  [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_AWID              ,
    output  [C_M_AXI_ADDR_WIDTH-1 : 0]      M_AXI_AWADDR            ,
    output  [7 : 0]                         M_AXI_AWLEN             ,
    output  [2 : 0]                         M_AXI_AWSIZE            ,
    output  [1 : 0]                         M_AXI_AWBURST           ,
    output                                  M_AXI_AWLOCK            ,
    output  [3 : 0]                         M_AXI_AWCACHE           ,
    output  [2 : 0]                         M_AXI_AWPROT            ,
    output  [3 : 0]                         M_AXI_AWQOS             ,
    output  [C_M_AXI_AWUSER_WIDTH-1 : 0]    M_AXI_AWUSER            ,
    output                                  M_AXI_AWVALID           ,
    input                                   M_AXI_AWREADY           ,

    output  [C_M_AXI_DATA_WIDTH-1 : 0]      M_AXI_WDATA             ,
    output  [C_M_AXI_DATA_WIDTH/8-1 : 0]    M_AXI_WSTRB             ,
    output                                  M_AXI_WLAST             ,
    output  [C_M_AXI_WUSER_WIDTH-1 : 0]     M_AXI_WUSER             ,
    output                                  M_AXI_WVALID            ,
    input                                   M_AXI_WREADY            ,

    input   [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_BID               ,
    input   [1 : 0]                         M_AXI_BRESP             ,
    input   [C_M_AXI_BUSER_WIDTH-1 : 0]     M_AXI_BUSER             ,
    input                                   M_AXI_BVALID            ,
    output                                  M_AXI_BREADY            ,

    output  [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_ARID              ,
    output  [C_M_AXI_ADDR_WIDTH-1 : 0]      M_AXI_ARADDR            ,
    output  [7 : 0]                         M_AXI_ARLEN             ,
    output  [2 : 0]                         M_AXI_ARSIZE            ,
    output  [1 : 0]                         M_AXI_ARBURST           ,
    output                                  M_AXI_ARLOCK            ,
    output  [3 : 0]                         M_AXI_ARCACHE           ,
    output  [2 : 0]                         M_AXI_ARPROT            ,
    output  [3 : 0]                         M_AXI_ARQOS             ,
    output  [C_M_AXI_ARUSER_WIDTH-1 : 0]    M_AXI_ARUSER            ,
    output                                  M_AXI_ARVALID           ,
    input                                   M_AXI_ARREADY           ,

    input   [C_M_AXI_ID_WIDTH-1 : 0]        M_AXI_RID               ,
    input   [C_M_AXI_DATA_WIDTH-1 : 0]      M_AXI_RDATA             ,
    input   [1 : 0]                         M_AXI_RRESP             ,
    input                                   M_AXI_RLAST             ,
    input   [C_M_AXI_RUSER_WIDTH-1 : 0]     M_AXI_RUSER             ,
    input                                   M_AXI_RVALID            ,
    output                                  M_AXI_RREADY            
);
//******************************WIRE************************************//
wire                  w_AES_STATE                         ;
wire                  w_OPEN_AES                          ;
wire [127:0]          w_key_out                           ;
wire                  w_slt_module                        ;
wire [31:0]           w_write_addr                        ;
wire [31:0]           w_read_addr                         ;

wire [127:0]          w_DATA_FINISH                       ;
wire                  w_RK_READY                          ;
wire                  w_FINISH_OUT_VALID                  ;
wire [127:0]          w_DATA_BEGIN                        ;
wire                  w_BEGIN_IN_VALID                    ;
wire [127:0] SM4_IN_DATA,SM4_OUT_DATA;
//****************************** ?   ***********************************//

//******************************    *************************************//
AES_Config_Register register(
    .s_apb_pclk                  (s_apb_pclk    ),
    .s_apb_paresetn              (s_apb_paresetn),
    .s_apb_paddr                 (s_apb_paddr   ),
    .s_apb_penable               (s_apb_penable ),
    .s_apb_psel                  (s_apb_psel    ),
    .s_apb_pwdata                (s_apb_pwdata  ),
    .s_apb_pwrite                (s_apb_pwrite  ),
    .s_apb_prdata                (s_apb_prdata  ),
    .s_apb_pready                (s_apb_pready  ),
    .s_apb_pslverr               (s_apb_pslverr ),
     
    .AES_STATE                   (w_AES_STATE ),
    .OPEN_AES                    (w_OPEN_AES  ),
    .key_out                     (w_key_out   ),
    .slt_module                  (w_slt_module),

    .write_addr                  (w_write_addr),
    .read_addr                   (w_read_addr ),

//************************************************Delete**********************************************// 
    .final_data_valid            (w_FINISH_OUT_VALID),
    .final_data                  (w_DATA_FINISH     )
//************************************************Delete**********************************************// 


);
// reg w_RK_READY_1st,w_RK_READY_2st;
// wire read_pulse;
// 	always @(posedge M_AXI_ACLK)										      
//   begin                                                                        
//     // Initiates AXI transaction delay    
//     if (M_AXI_ARESETN == 0 )                                                   
//       begin                                                                    
//         w_RK_READY_1st <= 1'b0;                                                   
//         w_RK_READY_2st <= 1'b0;                                                   
//       end                                                                               
//     else                                                                       
//       begin  
//         w_RK_READY_1st <= w_RK_READY;
//         w_RK_READY_2st <= w_RK_READY_1st;                                                                 
//       end                                                                      
//   end  
// assign read_pulse	= (!w_RK_READY_2st) && w_RK_READY_1st;
aes_ip_v1_0_M00_AXI # (
    .C_M_AXI_BURST_LEN      (C_M_AXI_BURST_LEN      ),
    .C_M_AXI_ID_WIDTH       (C_M_AXI_ID_WIDTH       ),
    .C_M_AXI_ADDR_WIDTH     (C_M_AXI_ADDR_WIDTH     ),
    .C_M_AXI_DATA_WIDTH     (C_M_AXI_DATA_WIDTH     ),
    .C_M_AXI_AWUSER_WIDTH   (C_M_AXI_AWUSER_WIDTH   ),
    .C_M_AXI_ARUSER_WIDTH   (C_M_AXI_ARUSER_WIDTH   ),
    .C_M_AXI_WUSER_WIDTH    (C_M_AXI_WUSER_WIDTH    ),
    .C_M_AXI_RUSER_WIDTH    (C_M_AXI_RUSER_WIDTH    ),
    .C_M_AXI_BUSER_WIDTH    (C_M_AXI_BUSER_WIDTH    )
  )
  aes_ip_v1_0_M00_AXI_inst (
    .C_M_TARGET_READ_SLAVE_BASE_ADDR(w_read_addr),
    .C_M_TARGET_WRITE_SLAVE_BASE_ADDR(w_write_addr),
    .SM4_OUT_DATA(w_DATA_FINISH),
    .SM4_IN_DATA(SM4_IN_DATA),
    .INIT_AXI_TXN(),
    .INIT_AXI_READ_TXN(w_RK_READY),
    .INIT_AXI_WRITE_TXN(w_FINISH_OUT_VALID),
    .TXN_DONE(),
    .ERROR(),
    .M_AXI_ACLK(M_AXI_ACLK),
    .M_AXI_ARESETN(M_AXI_ARESETN),
    .M_AXI_AWID(M_AXI_AWID),
    .M_AXI_AWADDR(M_AXI_AWADDR),
    .M_AXI_AWLEN(M_AXI_AWLEN),
    .M_AXI_AWSIZE(M_AXI_AWSIZE),
    .M_AXI_AWBURST(M_AXI_AWBURST),
    .M_AXI_AWLOCK(M_AXI_AWLOCK),
    .M_AXI_AWCACHE(M_AXI_AWCACHE),
    .M_AXI_AWPROT(M_AXI_AWPROT),
    .M_AXI_AWQOS(M_AXI_AWQOS),
    .M_AXI_AWUSER(M_AXI_AWUSER),
    .M_AXI_AWVALID(M_AXI_AWVALID),
    .M_AXI_AWREADY(M_AXI_AWREADY),
    .M_AXI_WDATA(M_AXI_WDATA),
    .M_AXI_WSTRB(M_AXI_WSTRB),
    .M_AXI_WLAST(M_AXI_WLAST),
    .M_AXI_WUSER(M_AXI_WUSER),
    .M_AXI_WVALID(M_AXI_WVALID),
    .M_AXI_WREADY(M_AXI_WREADY),
    .M_AXI_BID(M_AXI_BID),
    .M_AXI_BRESP(M_AXI_BRESP),
    .M_AXI_BUSER(M_AXI_BUSER),
    .M_AXI_BVALID(M_AXI_BVALID),
    .M_AXI_BREADY(M_AXI_BREADY),
    .M_AXI_ARID(M_AXI_ARID),
    .M_AXI_ARADDR(M_AXI_ARADDR),
    .M_AXI_ARLEN(M_AXI_ARLEN),
    .M_AXI_ARSIZE(M_AXI_ARSIZE),
    .M_AXI_ARBURST(M_AXI_ARBURST),
    .M_AXI_ARLOCK(M_AXI_ARLOCK),
    .M_AXI_ARCACHE(M_AXI_ARCACHE),
    .M_AXI_ARPROT(M_AXI_ARPROT),
    .M_AXI_ARQOS(M_AXI_ARQOS),
    .M_AXI_ARUSER(M_AXI_ARUSER),
    .M_AXI_ARVALID(M_AXI_ARVALID),
    .M_AXI_ARREADY(M_AXI_ARREADY),
    .M_AXI_RID(M_AXI_RID),
    .M_AXI_RDATA(M_AXI_RDATA),
    .M_AXI_RRESP(M_AXI_RRESP),
    .M_AXI_RLAST(M_AXI_RLAST),
    .M_AXI_RUSER(M_AXI_RUSER),
    .M_AXI_RVALID(M_AXI_RVALID),
    .M_AXI_RREADY(M_AXI_RREADY)
  );

/*  
AES_AXI_Interface #
(
    .C_M_AXI_BURST_LEN	            ( C_M_AXI_BURST_LEN	  )          ,
    .C_M_AXI_ID_WIDTH	            ( C_M_AXI_ID_WIDTH	  )          ,
    .C_M_AXI_ADDR_WIDTH	            ( C_M_AXI_ADDR_WIDTH  )          ,
    .C_M_AXI_DATA_WIDTH	            ( C_M_AXI_DATA_WIDTH  )          ,
    .C_M_AXI_AWUSER_WIDTH	        ( C_M_AXI_AWUSER_WIDTH)          ,
    .C_M_AXI_ARUSER_WIDTH	        ( C_M_AXI_ARUSER_WIDTH)          ,
    .C_M_AXI_WUSER_WIDTH	        ( C_M_AXI_WUSER_WIDTH )          ,
    .C_M_AXI_RUSER_WIDTH	        ( C_M_AXI_RUSER_WIDTH )          ,
    .C_M_AXI_BUSER_WIDTH	        ( C_M_AXI_BUSER_WIDTH )    
)
inter_face
(
    // Global Clock Signal.
    .M_AXI_ACLK              (M_AXI_ACLK   )            ,
    .M_AXI_ARESETN           (M_AXI_ARESETN)            ,
    .M_AXI_AWID              (M_AXI_AWID   )            ,
    .M_AXI_AWADDR            (M_AXI_AWADDR )            ,
    .M_AXI_AWLEN             (M_AXI_AWLEN  )            ,
    .M_AXI_AWSIZE            (M_AXI_AWSIZE )            ,
    .M_AXI_AWBURST           (M_AXI_AWBURST)            ,
    .M_AXI_AWLOCK            (M_AXI_AWLOCK )            ,
    .M_AXI_AWCACHE           (M_AXI_AWCACHE)            ,
    .M_AXI_AWPROT            (M_AXI_AWPROT )            ,
    .M_AXI_AWQOS             (M_AXI_AWQOS  )            ,
    .M_AXI_AWUSER            (M_AXI_AWUSER )            ,
    .M_AXI_AWVALID           (M_AXI_AWVALID)            ,
    .M_AXI_AWREADY           (M_AXI_AWREADY)            ,
    .M_AXI_WDATA             (M_AXI_WDATA  )            ,
    .M_AXI_WSTRB             (M_AXI_WSTRB  )            ,
    .M_AXI_WLAST             (M_AXI_WLAST  )            ,
    .M_AXI_WUSER             (M_AXI_WUSER  )            ,
    .M_AXI_WVALID            (M_AXI_WVALID )            ,
    .M_AXI_WREADY            (M_AXI_WREADY )            ,
    .M_AXI_BID               (M_AXI_BID    )            ,
    .M_AXI_BRESP             (M_AXI_BRESP  )            ,
    .M_AXI_BUSER             (M_AXI_BUSER  )            ,
    .M_AXI_BVALID            (M_AXI_BVALID )            ,
    .M_AXI_BREADY            (M_AXI_BREADY )            ,
    .M_AXI_ARID              (M_AXI_ARID   )            ,
    .M_AXI_ARADDR            (M_AXI_ARADDR )            ,
    .M_AXI_ARLEN             (M_AXI_ARLEN  )            ,
    .M_AXI_ARSIZE            (M_AXI_ARSIZE )            ,
    .M_AXI_ARBURST           (M_AXI_ARBURST)            ,
    .M_AXI_ARLOCK            (M_AXI_ARLOCK )            ,
    .M_AXI_ARCACHE           (M_AXI_ARCACHE)            ,
    .M_AXI_ARPROT            (M_AXI_ARPROT )            ,
    .M_AXI_ARQOS             (M_AXI_ARQOS  )            ,
    .M_AXI_ARUSER            (M_AXI_ARUSER )            ,
    .M_AXI_ARVALID           (M_AXI_ARVALID)            ,
    .M_AXI_ARREADY           (M_AXI_ARREADY)            ,
    .M_AXI_RID               (M_AXI_RID    )            ,
    .M_AXI_RDATA             (M_AXI_RDATA  )            ,
    .M_AXI_RRESP             (M_AXI_RRESP  )            ,
    .M_AXI_RLAST             (M_AXI_RLAST  )            ,
    .M_AXI_RUSER             (M_AXI_RUSER  )            ,
    .M_AXI_RVALID            (M_AXI_RVALID )            ,
    .M_AXI_RREADY            (M_AXI_RREADY )            ,

    .READ_ADDR               (w_read_addr       )       ,
    .WRIRTE_ADDR             (w_write_addr      )       ,

    .DATA_FINISH             (w_DATA_FINISH     )       ,
    .RK_READY                (w_RK_READY        )       ,
    .FINISH_OUT_VALID        (w_FINISH_OUT_VALID)       ,
    .DATA_BEGIN              (w_DATA_BEGIN      )       ,
    .BEGIN_IN_VALID          (w_BEGIN_IN_VALID  )                              
);
*/
AES128 aes_core
(
    .clk                      (M_AXI_ACLK         )     , 
    .rstn                     (M_AXI_ARESETN      )     ,
    .en                       (w_OPEN_AES         )     , // input  ?   ?? config   ? ?   Encryption

    .data_in_valid            (M_AXI_RVALID && M_AXI_RREADY  )     , // input  plaintext ?   §¹(in_data_valid)
    .data_in                  (SM4_IN_DATA       )     , // input  plaintext(in_data) )

    .aes_state                (w_AES_STATE        )     , // output      ??  1/0      config
    .rk_ready                 (w_RK_READY         )     , // output  key_done      AXI

    .data_out_valid           (w_FINISH_OUT_VALID )     , // ciphertext ?   §¹ (out_data_valid)
    .data_out                 (w_DATA_FINISH      )     , // ciphertext(out_data)

    .key_in                   (w_key_out          )     , // input    ?key(in_key)  config    
    .slt_module               (w_slt_module       )       // input      /    ?  ? ï…config    
);


endmodule