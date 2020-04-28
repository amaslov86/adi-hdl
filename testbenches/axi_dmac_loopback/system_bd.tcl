global m_dma_cfg
global s_dma_cfg
global mng_axi_cfg
global ddr_axi_cfg

# Create DUTs
ad_ip_instance axi_dmac master_dma $m_dma_cfg
adi_sim_add_define "M_DMAC=master_dma"

ad_ip_instance axi_dmac slave_dma $s_dma_cfg
adi_sim_add_define "S_DMAC=slave_dma"

# Create data storage (AXI slave)
ad_ip_instance axi_vip ddr_axi_vip $ddr_axi_cfg
adi_sim_add_define "DDR_AXI=ddr_axi_vip"

# Create instance: mng_axi , and set properties
# VIP for management port
ad_ip_instance axi_vip mng_axi_vip $mng_axi_cfg
adi_sim_add_define "MNG_AXI=mng_axi_vip"

# Create clock gens
ad_ip_instance clk_vip mng_clk_vip [list \
  INTERFACE_MODE {MASTER} \
  FREQ_HZ {100000000} \
]
adi_sim_add_define "MNG_CLK=mng_clk_vip"

ad_ip_instance clk_vip ddr_clk_vip [list \
  INTERFACE_MODE {MASTER} \
  FREQ_HZ {250000000} \
]
adi_sim_add_define "DDR_CLK=ddr_clk_vip"

ad_ip_instance clk_vip usr_clk_vip [list \
  INTERFACE_MODE {MASTER} \
  FREQ_HZ {100000000} \
]
adi_sim_add_define "USR_CLK=usr_clk_vip"

ad_ip_instance rst_vip rst_gen [ list \
  INTERFACE_MODE {MASTER} \
  RST_POLARITY {ACTIVE_LOW} \
]
adi_sim_add_define "RST=rst_gen"

# add interconnect 
# config
ad_ip_instance axi_interconnect axi_cfg_interconnect [ list \
  NUM_SI {1} \
  NUM_MI {2} \
]

# data
ad_ip_instance axi_interconnect axi_ddr_interconnect [ list \
  NUM_SI {2} \
  NUM_MI {1} \
]

# connect datapath 
#  ddr interconnect - M_DMA 
ad_connect master_dma/m_src_axi axi_ddr_interconnect/S00_AXI

#  M_DMA - S_DMA 
ad_connect master_dma/m_axis slave_dma/s_axis


# S_DMA - ddr interconnect 
ad_connect slave_dma/m_dest_axi axi_ddr_interconnect/S01_AXI

# ddr interconnect to ddr AXI VIP
ad_connect axi_ddr_interconnect/M00_AXI ddr_axi_vip/S_AXI

# connect config
ad_connect mng_axi_vip/M_AXI  axi_cfg_interconnect/S00_AXI
ad_connect axi_cfg_interconnect/M00_AXI master_dma/s_axi
ad_connect axi_cfg_interconnect/M01_AXI slave_dma/s_axi


# connect reset and clocks
ad_connect rst_gen/rst_out master_dma/s_axi_aresetn
ad_connect rst_gen/rst_out master_dma/m_src_axi_aresetn

ad_connect rst_gen/rst_out slave_dma/s_axi_aresetn
ad_connect rst_gen/rst_out slave_dma/m_dest_axi_aresetn

ad_connect rst_gen/rst_out mng_axi_vip/aresetn

ad_connect rst_gen/rst_out axi_cfg_interconnect/ARESETN
ad_connect rst_gen/rst_out axi_cfg_interconnect/S00_ARESETN
ad_connect rst_gen/rst_out axi_cfg_interconnect/M00_ARESETN
ad_connect rst_gen/rst_out axi_cfg_interconnect/M01_ARESETN

ad_connect rst_gen/rst_out axi_ddr_interconnect/ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/S00_ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/S01_ARESETN
ad_connect rst_gen/rst_out axi_ddr_interconnect/M00_ARESETN

ad_connect rst_gen/rst_out ddr_axi_vip/aresetn

ad_connect mng_clk_vip/clk_out mng_axi_vip/aclk
ad_connect mng_clk_vip/clk_out master_dma/s_axi_aclk
ad_connect mng_clk_vip/clk_out slave_dma/s_axi_aclk
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/ACLK
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/S00_ACLK
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/M00_ACLK
ad_connect mng_clk_vip/clk_out axi_cfg_interconnect/M01_ACLK

ad_connect ddr_clk_vip/clk_out master_dma/m_src_axi_aclk
ad_connect ddr_clk_vip/clk_out slave_dma/m_dest_axi_aclk
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/S00_ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/S01_ACLK
ad_connect ddr_clk_vip/clk_out axi_ddr_interconnect/M00_ACLK
ad_connect ddr_clk_vip/clk_out ddr_axi_vip/aclk

ad_connect usr_clk_vip/clk_out master_dma/m_axis_aclk

ad_connect usr_clk_vip/clk_out slave_dma/s_axis_aclk

# assign addresses
create_bd_addr_seg -range 0x00010000 -offset 0x44A00000 [get_bd_addr_spaces mng_axi_vip/Master_AXI] [get_bd_addr_segs master_dma/s_axi/axi_lite] SEG_axi_s_dmac_0_axi_lite
create_bd_addr_seg -range 0x00010000 -offset 0x44A10000 [get_bd_addr_spaces mng_axi_vip/Master_AXI] [get_bd_addr_segs  slave_dma/s_axi/axi_lite] SEG_axi_m_dmac_0_axi_lite

adi_sim_add_define "M_DMAC_BA=\'h44A00000"
adi_sim_add_define "S_DMAC_BA=\'h44A10000"

# Create hierarchies
group_bd_cells DUT [get_bd_cells master_dma] [get_bd_cells slave_dma]
group_bd_cells clk_rst_gen [get_bd_cells ddr_clk_vip] [get_bd_cells usr_clk_vip] [get_bd_cells mng_clk_vip] [get_bd_cells rst_gen]

# assign DDR address range
assign_bd_address [get_bd_addr_segs {ddr_axi_vip/S_AXI/Reg }]
set_property offset 0x00000000 [get_bd_addr_segs {DUT/master_dma/m_src_axi/SEG_ddr_axi_vip_Reg}]
set_property range 4G [get_bd_addr_segs {DUT/master_dma/m_src_axi/SEG_ddr_axi_vip_Reg}]
set_property offset 0x00000000 [get_bd_addr_segs {DUT/slave_dma/m_dest_axi/SEG_ddr_axi_vip_Reg}]
set_property range 4G [get_bd_addr_segs {DUT/slave_dma/m_dest_axi/SEG_ddr_axi_vip_Reg}]
