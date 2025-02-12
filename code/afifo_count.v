`timescale 1ns / 1ps

module afifo_count #(
    parameter  DATA_WIDTH  = 32,
    parameter  FIFO_DEPTH  = 3 
) (
    input                            clk      ,
    input                            rst      ,
    input                            wr_en    ,
    input                            rd_en    ,
    input       [DATA_WIDTH-1:0]     wr_data  ,
    output reg  [DATA_WIDTH-1:0]     rd_data  ,
    output reg    [DATA_WIDTH-1:0]   rd_data_pre,
    output reg                       full     ,
    output reg                       empty
//    output        [$clog2(FIFO_DEPTH):0]  fifo_data_avail,
//    output  reg   [$clog2(FIFO_DEPTH):0]  fifo_room_avail,
);

localparam ptr_width = clog2(FIFO_DEPTH);  //Chinese：指针宽度计算  $clog2是否可综合

reg [DATA_WIDTH-1:0] RAM [0:FIFO_DEPTH-1];
reg [ptr_width-1:0] wr_ptr,rd_ptr,wr_ptr_nxt,rd_ptr_nxt;
reg [ptr_width:0] num_entries,num_entries_nxt;
wire full_nxt,empty_nxt;
//wire [ptr_width:0] fifo_room_avail_nxt,fifo_data_avail;

function integer clog2;
    input integer value;
    integer i;
    begin
        clog2 = 0;
        for (i = value - 1; i > 0; i = i >> 1) begin
            clog2 = clog2 + 1;
        end
    end
endfunction   

always @(*) begin
    if(empty)
        rd_data_pre = {2'b11,{(DATA_WIDTH-2){1'b0}}};
        // rd_data_pre = {DATA_WIDTH{1'b1}};
    else
        rd_data_pre = RAM[rd_ptr];
end
//WRITE PTR
always @(*) begin
    wr_ptr_nxt = wr_ptr;
    if (wr_en) begin
        if (wr_ptr == (FIFO_DEPTH - 1)) begin
            wr_ptr_nxt = 'd0;
        end
        else begin
            wr_ptr_nxt = wr_ptr + 1'b1;
        end
    end
end

//READ PTR
always @(*) begin
    rd_ptr_nxt = rd_ptr;
    if (rd_en) begin
        if (rd_ptr == (FIFO_DEPTH - 1)) begin
            rd_ptr_nxt = 'd0;
        end
        else begin
            rd_ptr_nxt = rd_ptr + 1'b1;
        end
    end
end

//WRITE DATA
//always @(posedge clk or negedge rst) begin
//    if (wr_en) begin
//        RAM[wr_ptr] <= wr_data;                
//    end
//    else begin
//        RAM[wr_ptr] <= RAM[wr_ptr];
//    end   
//end

always @(posedge clk) begin
    if (wr_en) begin
        RAM[wr_ptr] <= wr_data;                
    end
    else begin
        RAM[wr_ptr] <= RAM[wr_ptr];
    end   
end

// //READ DATA
// always @(posedge clk or negedge rst) begin
//     if (!rst) begin
//         rd_data <= 'd0;
//     end
//     else begin
//         rd_data <= RAM[rd_ptr];                    
//     end
// end

//Caculate number of occupied entries in the FIFO
always @(*) begin
    num_entries_nxt = num_entries;
    if (wr_en && rd_en) begin
        num_entries_nxt = num_entries;
    end
    else begin
        if (wr_en && !full) begin
            num_entries_nxt = num_entries + 1'b1;
        end
        else begin
            if (rd_en && !empty) begin
                num_entries_nxt = num_entries - 1'b1;
            end
        end
    end
end

assign full_nxt   = (num_entries_nxt == FIFO_DEPTH);
assign empty_nxt = (num_entries_nxt == 'd0);
//assign fifo_data_avail = num_entries;
//assign fifo_ronn_avail_nxt = (FIFO_DEPTH - num_entries_nxt);


always @(posedge clk or negedge rst) begin
    if (!rst) begin
        wr_ptr      <=  'd0;
        rd_ptr      <=  'd0;
        num_entries <=  'd0;
        full        <=  'd0;
        empty       <=  'd1;
//        fifo_room_avail <= FIFO_DEPTH;
    end
    else begin
        wr_ptr      <=  wr_ptr_nxt      ;
        rd_ptr      <=  rd_ptr_nxt      ;
        num_entries <=  num_entries_nxt ;
        full        <=  full_nxt        ;
        empty       <=  empty_nxt       ;
//        fifo_room_avail <= fifo_room_avail_nxt;
    end
end
endmodule