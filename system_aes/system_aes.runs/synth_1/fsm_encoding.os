
 add_fsm_encoding \
       {axilite_sif.axi_wr_rd_cs} \
       { }  \
       {{000 000} {001 110} {010 101} {011 100} {100 111} {101 010} {110 001} {111 011} }

 add_fsm_encoding \
       {wr_chnl.GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs} \
       { }  \
       {{000 000} {001 100} {010 011} {011 001} {100 010} }

 add_fsm_encoding \
       {rd_chnl.rlast_sm_cs} \
       { }  \
       {{000 000} {001 010} {010 011} {011 100} {100 001} }

 add_fsm_encoding \
       {rd_chnl.rd_data_sm_cs} \
       { }  \
       {{0000 0000} {0001 0001} {0010 0010} {0011 0011} {0100 0100} {0101 0101} {0110 0110} {0111 0111} {1000 1000} }

 add_fsm_encoding \
       {axi_data_fifo_v2_1_14_axic_reg_srl_fifo.state} \
       { }  \
       {{00 0100} {01 1000} {10 0001} {11 0010} }

 add_fsm_encoding \
       {axi_data_fifo_v2_1_14_axic_reg_srl_fifo__parameterized0.state} \
       { }  \
       {{00 0100} {01 1000} {10 0001} {11 0010} }

 add_fsm_encoding \
       {axi_data_fifo_v2_1_14_axic_reg_srl_fifo__parameterized1.state} \
       { }  \
       {{00 0100} {01 1000} {10 0001} {11 0010} }

 add_fsm_encoding \
       {axi_data_fifo_v2_1_14_axic_reg_srl_fifo__parameterized2.state} \
       { }  \
       {{00 0100} {01 1000} {10 0001} {11 0010} }
