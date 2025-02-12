`timescale 1ns / 1ps

module testbench;
  reg clk;
  reg rstn;
  reg slt_module;
  reg en;
  reg data_in_valid;
  reg [127:0] data_in;
  reg [127:0] key_in;

  wire rk_ready;
  wire data_out_valid;
  wire [127:0] data_out;

  // 实例化AES128模块
  AES128 AES128_DUT(
    .clk(clk),
    .rstn(rstn),
    .en(en),
    .data_in_valid(data_in_valid),
    .data_in(data_in),
    .rk_ready(rk_ready),
    .data_out_valid(data_out_valid),
    .data_out(data_out),
    .key_in(key_in),
    .slt_module(slt_module)
  );
 
  always #5 clk = !clk; // 时钟周期�?10ns

  initial begin
    clk = 0;
    rstn = 0;
    data_in_valid = 0;
    data_in = 128'b0;
    key_in = 128'b0;

    slt_module=1;
    #10;
    slt_module=0;
    #10;
    rstn = 1;
    en = 1;
    // 测试1：测试密钥生�?
    // key_in = 128'h0123456789ABCDEF0123456789ABCDEF;
    key_in=128'h0123456789ABCDEF0123456700010203;
    #130;
    key_in=128'hfedcba9876543210fedcba9803020100;
    #130;
    key_in=128'h0123456789ABCDEF0123456704050607;
    #130;
    key_in=128'h0123456789ABCDEF0123456708090a0b;
    #130;
    key_in=128'h0123456789ABCDEF012345670c0d0e0f;
    #130;
    key_in=128'h0123456789ABCDEF0123456710111213;
    #130
    key_in=128'h0123456789ABCDEF0123456714151617;
    #130
    key_in=128'h0123456789ABCDEF0123456718191a1b;
    #130;
    key_in=128'h0123456789ABCDEF012345671c1d1e1f;
    #130;
    key_in=128'h0123456789ABCDEF0123456720212223;
    #130;
    key_in=128'h0123456789ABCDEF0123456724252627;
    #130;
    key_in=128'h0123456789ABCDEF0123456728292a2b;
    #130;
    key_in=128'h0123456789ABCDEF012345672c2d2e2f;
    #130;
    key_in=128'h0123456789ABCDEF0123456730313233;
    #130;
    key_in=128'h0123456789ABCDEF0123456734353637;
    #130;
    key_in=128'h0123456789ABCDEF0123456738393a3b;
    #130;
    key_in=128'h0123456789ABCDEF012345673c3d3e3f;
    #130;
    key_in=128'h0123456789ABCDEF0123456740414243;
    #130;
    key_in=128'h0123456789ABCDEF0123456744454647;
    #130;
    key_in=128'h0123456789ABCDEF0123456748494a4b;
    #130;
    key_in=128'h0123456789ABCDEF012345674c4d4e4f;
    #130;
    key_in=128'h0123456789ABCDEF0123456750515253;
    #130;
    key_in=128'h0123456789ABCDEF0123456754555657;
    #130;
    key_in=128'h0123456789ABCDEF0123456758595a5b;
    #130;
    key_in=128'h0123456789ABCDEF012345675c5d5e5f;
    #130;
    key_in=128'h0123456789ABCDEF0123456760616263;
    #130;
    key_in=128'h0123456789ABCDEF0123456764656667;
    #130;
    key_in=128'h0123456789ABCDEF0123456768696a6b;
    #130;
    key_in=128'h0123456789ABCDEF012345676c6d6e6f;
   #130;
    key_in=128'h0123456789ABCDEF0123456770717273;
    #130;
    key_in=128'h0123456789ABCDEF0123456774757677;
    #130;
    key_in=128'h0123456789ABCDEF0123456778797a7b;
   #130;
    key_in=128'h0123456789ABCDEF012345677c7d7e7f;
    #130;
    key_in=128'h0123456789ABCDEF0123456780818283;
    #130;
    key_in=128'h0123456789ABCDEF0123456784858687;
    #130;
    key_in=128'h0123456789ABCDEF0123456788898a8b;
    #130;
    key_in=128'h0123456789ABCDEF012345678c8d8e8f;
    #130;
    key_in=128'h0123456789ABCDEF0123456790919293;
    #130;
    key_in=128'h0123456789ABCDEF0123456794959697;
    #130;
    key_in=128'h0123456789ABCDEF0123456798999a9b;
    #130;
    key_in=128'h0123456789ABCDEF012345679c9d9e9f;
    #130;
    key_in=128'h0123456789ABCDEF01234567a0a1a2a3;
    #130;
    key_in=128'h0123456789ABCDEF01234567a4a5a6a7;
    #130;
    slt_module=1;
    #10
    slt_module=0;
    key_in=128'h0123456789ABCDEF01234567a8a9aaab;
   #130;
    key_in=128'h0123456789ABCDEF01234567acadaeaf;
    #130;
    key_in=128'h0123456789ABCDEF01234567b0b1b2b3;
   #130;
   rstn=0;
   #10;
   rstn=1;
    key_in=128'h0123456789ABCDEF01234567b4b5b6b7;
    #130;
    key_in=128'h0123456789ABCDEF01234567b8b9babb;
    #130;
    key_in=128'h0123456789ABCDEF01234567bcbdbebf;
    #130;
    key_in=128'h0123456789ABCDEF01234567c0c1c2c3;
    #130;
    key_in=128'h0123456789ABCDEF01234567c4c5c6c7;
    #130;
    key_in=128'h0123456789ABCDEF01234567c8c9cacb;
    #130;
    key_in=128'h0123456789ABCDEF01234567cccdcecf;
    #130;
    key_in=128'h0123456789ABCDEF01234567d0d1d2d3;
   #130;
    key_in=128'h0123456789ABCDEF01234567d4d5d6d7;
   #130;
    key_in=128'h0123456789ABCDEF01234567d8d9dadb;
    #130;
    key_in=128'h0123456789ABCDEF01234567dcdddedf;
    #130;
    key_in=128'h0123456789ABCDEF01234567e0e1e2e3;
    #130;
    key_in=128'h0123456789ABCDEF01234567e4e5e6e7;
    #130;
    key_in=128'h0123456789ABCDEF01234567e8e9eaeb;
    #130;
    key_in=128'hffffffffffffffffffffffffffffffff;
    #130;
    key_in=128'h0123456789ABCDEF01234567ecedeeef;
    #130;
    key_in=128'h0123456789ABCDEF01234567f0f1f2f3;
    #130;
    key_in=128'h0123456789ABCDEF01234567f4f5f6f7;
    #130;
    en=0;
    #10;
    en=1;
    key_in=128'h0123456789ABCDEF01234567f8f9fafb;
   #130;
    key_in=128'h0123456789ABCDEF01234567fcfdfeff;
    #130;
    en = 0;

    // 等待密钥生成完成
    wait (rk_ready);

    // 测试2：测试加密过�?
    data_in_valid = 1;
    // data_in = 128'hd7e5dbd3324595f8fdc7d7c571da6c2a;
    //525a0bb6f6626e941a81cd7b5fe8b620
    data_in=128'h000102030405060708090a0b0c0d0e0f;
    #11;
    data_in=128'h101112131415161718191a1b1c1d1e1f;
    #11;
    data_in=128'h0f0e0d0c0b0a09080706050403020100;
    #11;
    data_in=128'hffffffffffffffffffffffffffffffff;
    #11;
    data_in=128'h202122232425262728292a2b2c2d2e2f;
    #11;
    data_in=128'h303132333435363738393a3b3c3d3e3f;
    #11;
    data_in=128'h404142434445464748494a4b4c4d4e4f;
    #11;
    data_in=128'h505152535455565758595a5b5c5d5e5f;
    #11;
    data_in=128'h606162636465666768696a6b6c6d6e6f;
    #11;
    data_in=128'h707172737475767778797a7b7c7d7e7f;
    #11;
    data_in=128'h808182838485868788898a8b8c8d8e8f;
    #11;
    data_in=128'h909192939495969798999a9b9c9d9e9f;
    #11;
    data_in=128'ha0a1a2a3a4a5a6a7a8a9aaabacadaeaf;
    #11;
    data_in=128'hb0b1b2b3b4b5b6b7b8b9babbbcbdbebf;
    #11;
    data_in=128'hc0c1c2c3c4c5c6c7c8c9cacbcccdcecf;
    #11;
    data_in=128'hd0d1d2d3d4d5d6d7d8d9dadbdcdddedf;
    #11;
    data_in=128'he0e1e2e3e4e5e6e7e8e9eaebecedeeef;
    #11;
    data_in=128'hf0f1f2f3f4f5f6f7f8f9fafbfcfdfeff;
    //  data_in = 128'ha2f4dbd3324595f8fdc7d7c571da6c2b;
    //d73f13dadea97657531d06d240c2c627
    #10;
     data_in_valid = 0;
    // 等待加密完成
    wait (data_out_valid);

    // �?查最终输出结�?
    $display("Test Case 2 - Encryption:");
    $display("Encrypted value: %h", data_out);

    // // 测试3：测试解密过程（假设解密逻辑已实现）
    // slt_module = 1'b1; // 切换到解密模�?
    // data_in_valid = 1;
    // data_in = data_out; // 使用加密后的数据作为解密输入
    // #10;
    // data_in_valid = 0;

    // // 等待解密完成
    // wait (data_out_valid);

    // // �?查最终输出结�?
    // $display("Test Case 3 - Decryption:");
    // $display("Decrypted value: %h", data_out);

    #100 $finish;
  end

endmodule