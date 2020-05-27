# ad9656_rx JESD204

add_instance ad9656_rx_jesd204 adi_jesd204
set_instance_parameter_value ad9656_rx_jesd204 {ID} {1}
set_instance_parameter_value ad9656_rx_jesd204 {TX_OR_RX_N} {0}
set_instance_parameter_value ad9656_rx_jesd204 {SOFT_PCS} {true}
set_instance_parameter_value ad9656_rx_jesd204 {LANE_RATE} {9830.4}
set_instance_parameter_value ad9656_rx_jesd204 {REFCLK_FREQUENCY} {245.76}
set_instance_parameter_value ad9656_rx_jesd204 {NUM_OF_LANES} {2}

add_connection sys_clk.clk ad9656_rx_jesd204.sys_clk
add_connection sys_clk.clk_reset ad9656_rx_jesd204.sys_resetn
add_interface rx_ref_clk clock sink
set_interface_property rx_ref_clk EXPORT_OF ad9656_rx_jesd204.ref_clk
add_interface rx_serial_data conduit end
set_interface_property rx_serial_data EXPORT_OF ad9656_rx_jesd204.serial_data
add_interface rx_sysref conduit end
set_interface_property rx_sysref EXPORT_OF ad9656_rx_jesd204.sysref
add_interface rx_sync conduit end
set_interface_property rx_sync EXPORT_OF ad9656_rx_jesd204.sync

# ad9656-core

add_instance axi_ad9656 axi_ad9656
add_connection ad9656_rx_jesd204.link_clk axi_ad9656.if_adc_clk
add_connection ad9656_rx_jesd204.link_sof axi_ad9656.if_adc_rx_sof
add_connection ad9656_rx_jesd204.link_data axi_ad9656.if_adc_rx_data
add_connection sys_clk.clk axi_ad9656.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9656.s_axi_reset

# pack(s) & unpack(s)

add_instance axi_ad9656_rx_cpack util_cpack2
set_instance_parameter_value axi_ad9656_rx_cpack {NUM_OF_CHANNELS} {4}
set_instance_parameter_value axi_ad9656_rx_cpack {SAMPLES_PER_CHANNEL} {1}
set_instance_parameter_value axi_ad9656_rx_cpack {SAMPLE_DATA_WIDTH} {16}
add_connection ad9656_rx_jesd204.link_reset axi_ad9656_rx_cpack.reset
add_connection ad9656_rx_jesd204.link_clk axi_ad9656_rx_cpack.clk
add_connection axi_ad9656.adc_ch_0 axi_ad9656_rx_cpack.adc_ch_0
add_connection axi_ad9656.adc_ch_1 axi_ad9656_rx_cpack.adc_ch_1
add_connection axi_ad9656.adc_ch_2 axi_ad9656_rx_cpack.adc_ch_2
add_connection axi_ad9656.adc_ch_3 axi_ad9656_rx_cpack.adc_ch_3
add_connection axi_ad9656_rx_cpack.if_fifo_wr_overflow axi_ad9656.if_adc_dovf

# adc dma

add_instance axi_ad9656_rx_dma axi_dmac
set_instance_parameter_value axi_ad9656_rx_dma {ID} {0}
set_instance_parameter_value axi_ad9656_rx_dma {DMA_DATA_WIDTH_SRC} {64}
set_instance_parameter_value axi_ad9656_rx_dma {DMA_DATA_WIDTH_DEST} {128}
set_instance_parameter_value axi_ad9656_rx_dma {DMA_LENGTH_WIDTH} {24}
set_instance_parameter_value axi_ad9656_rx_dma {DMA_2D_TRANSFER} {0}
set_instance_parameter_value axi_ad9656_rx_dma {AXI_SLICE_DEST} {0}
set_instance_parameter_value axi_ad9656_rx_dma {AXI_SLICE_SRC} {0}
set_instance_parameter_value axi_ad9656_rx_dma {SYNC_TRANSFER_START} {1}
set_instance_parameter_value axi_ad9656_rx_dma {CYCLIC} {0}
set_instance_parameter_value axi_ad9656_rx_dma {DMA_TYPE_DEST} {0}
set_instance_parameter_value axi_ad9656_rx_dma {DMA_TYPE_SRC} {2}
set_instance_parameter_value axi_ad9656_rx_dma {FIFO_SIZE} {16}
add_connection ad9656_rx_jesd204.link_clk axi_ad9656_rx_dma.if_fifo_wr_clk
add_connection axi_ad9656_rx_cpack.if_packed_fifo_wr_en axi_ad9656_rx_dma.if_fifo_wr_en
add_connection axi_ad9656_rx_cpack.if_packed_fifo_wr_sync axi_ad9656_rx_dma.if_fifo_wr_sync
add_connection axi_ad9656_rx_cpack.if_packed_fifo_wr_data axi_ad9656_rx_dma.if_fifo_wr_din
add_connection axi_ad9656_rx_dma.if_fifo_wr_overflow axi_ad9656_rx_cpack.if_packed_fifo_wr_overflow
add_connection sys_clk.clk axi_ad9656_rx_dma.s_axi_clock
add_connection sys_clk.clk_reset axi_ad9656_rx_dma.s_axi_reset
add_connection sys_dma_clk.clk axi_ad9656_rx_dma.m_dest_axi_clock
add_connection sys_dma_clk.clk_reset axi_ad9656_rx_dma.m_dest_axi_reset

# reconfig sharing

for {set i 0} {$i < 4} {incr i} {
  add_instance avl_adxcfg_${i} avl_adxcfg
  add_connection sys_clk.clk avl_adxcfg_${i}.rcfg_clk
  add_connection sys_clk.clk_reset avl_adxcfg_${i}.rcfg_reset_n
  add_connection avl_adxcfg_${i}.rcfg_m1 ad9656_rx_jesd204.phy_reconfig_${i}
}

# addresses

ad_cpu_interconnect 0x00030000 ad9656_rx_jesd204.link_reconfig
ad_cpu_interconnect 0x00034000 ad9656_rx_jesd204.link_management
ad_cpu_interconnect 0x00035000 ad9656_rx_jesd204.link_pll_reconfig
ad_cpu_interconnect 0x00038000 avl_adxcfg_0.rcfg_s1
ad_cpu_interconnect 0x00039000 avl_adxcfg_1.rcfg_s1
ad_cpu_interconnect 0x00048000 avl_adxcfg_2.rcfg_s1
ad_cpu_interconnect 0x00049000 avl_adxcfg_3.rcfg_s1
ad_cpu_interconnect 0x0003c000 axi_ad9656_rx_dma.s_axi

ad_cpu_interconnect 0x00050000 axi_ad9656.s_axi

# dma interconnects

ad_dma_interconnect axi_ad9656_rx_dma.m_dest_axi

# interrupts

ad_cpu_interrupt 12 axi_ad9656_rx_dma.interrupt_sender

