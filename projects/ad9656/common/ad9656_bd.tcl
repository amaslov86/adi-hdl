
# RX parameters
set RX_NUM_OF_LANES 4      ; # L
set RX_NUM_OF_CONVERTERS 4 ; # M
set RX_SAMPLES_PER_FRAME 1 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 2 ; # L * 32 / (M * N)

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adc peripherals

ad_ip_instance axi_adxcvr axi_ad9656_rx_xcvr
ad_ip_parameter axi_ad9656_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_ad9656_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_ad9656_rx_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_ad9656_rx_xcvr CONFIG.SYS_CLK_SEL 0
ad_ip_parameter axi_ad9656_rx_xcvr CONFIG.OUT_CLK_SEL 3

adi_axi_jesd204_rx_create axi_ad9656_rx_jesd $RX_NUM_OF_LANES

ad_ip_instance util_cpack2 util_ad9656_rx_cpack [list \
  NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS \
  SAMPLES_PER_CHANNEL $RX_SAMPLES_PER_CHANNEL \
  SAMPLE_DATA_WIDTH $RX_SAMPLE_WIDTH \
  ]

adi_tpl_jesd204_rx_create rx_ad9656_tpl_core $RX_NUM_OF_LANES \
                                               $RX_NUM_OF_CONVERTERS \
                                               $RX_SAMPLES_PER_FRAME \
                                               $RX_SAMPLE_WIDTH

ad_ip_instance axi_dmac axi_ad9656_rx_dma
ad_ip_parameter axi_ad9656_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_ad9656_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad9656_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad9656_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_ad9656_rx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_ad9656_rx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_ad9656_rx_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_ad9656_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad9656_rx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr 32*$RX_NUM_OF_LANES]
ad_ip_parameter axi_ad9656_rx_dma CONFIG.MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_ad9656_rx_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_ad9656_rx_dma CONFIG.AXI_SLICE_SRC true

# common cores


ad_ip_instance util_adxcvr util_ad9656_xcvr
ad_ip_parameter util_ad9656_xcvr CONFIG.RX_NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter util_ad9656_xcvr CONFIG.TX_NUM_OF_LANES 0
ad_ip_parameter util_ad9656_xcvr CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_ad9656_xcvr CONFIG.CPLL_FBDIV 2
ad_ip_parameter util_ad9656_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_ad9656_xcvr CONFIG.RX_OUT_DIV 1
ad_ip_parameter util_ad9656_xcvr CONFIG.RX_CLK25_DIV 5
ad_ip_parameter util_ad9656_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_ad9656_xcvr CONFIG.RX_PMA_CFG 0x001E7080
ad_ip_parameter util_ad9656_xcvr CONFIG.RX_CDR_CFG 0x0b000023ff10400020
 ad_ip_parameter util_ad9656_xcvr CONFIG.QPLL_FBDIV 0x080

# xcvr interfaces

set rx_ref_clk     rx_ref_clk_0

create_bd_port -dir I $rx_ref_clk
ad_connect  $sys_cpu_resetn util_ad9656_xcvr/up_rstn
ad_connect  $sys_cpu_clk util_ad9656_xcvr/up_clk

# Rx
ad_connect ad9656_rx_device_clk util_ad9656_xcvr/rx_out_clk_0
ad_xcvrcon  util_ad9656_xcvr axi_ad9656_rx_xcvr axi_ad9656_rx_jesd {} ad9656_rx_device_clk
ad_xcvrpll $rx_ref_clk util_ad9656_xcvr/qpll_ref_clk_0
for {set i 0} {$i < $RX_NUM_OF_LANES} {incr i} {
  set ch [expr $i]
  ad_xcvrpll  $rx_ref_clk util_ad9656_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_ad9656_rx_xcvr/up_pll_rst util_ad9656_xcvr/up_cpll_rst_$ch
}

# connections (adc)

ad_connect  util_ad9656_xcvr/rx_out_clk_0 rx_ad9656_tpl_core/link_clk
ad_connect  axi_ad9656_rx_jesd/rx_sof rx_ad9656_tpl_core/link_sof
ad_connect  axi_ad9656_rx_jesd/rx_data_tdata rx_ad9656_tpl_core/link_data
ad_connect  axi_ad9656_rx_jesd/rx_data_tvalid rx_ad9656_tpl_core/link_valid
ad_connect  util_ad9656_xcvr/rx_out_clk_0 util_ad9656_rx_cpack/clk
ad_connect  ad9656_rx_device_clk_rstgen/peripheral_reset util_ad9656_rx_cpack/reset

ad_connect  rx_ad9656_tpl_core/adc_valid_0 util_ad9656_rx_cpack/fifo_wr_en
ad_connect  rx_ad9656_tpl_core/adc_enable_0 util_ad9656_rx_cpack/enable_0
ad_connect  rx_ad9656_tpl_core/adc_enable_1 util_ad9656_rx_cpack/enable_1
ad_connect  rx_ad9656_tpl_core/adc_data_0 util_ad9656_rx_cpack/fifo_wr_data_0
ad_connect  rx_ad9656_tpl_core/adc_data_1 util_ad9656_rx_cpack/fifo_wr_data_1
ad_connect  rx_ad9656_tpl_core/adc_dovf util_ad9656_rx_cpack/fifo_wr_overflow

ad_connect  util_ad9656_xcvr/rx_out_clk_0 axi_ad9656_rx_dma/fifo_wr_clk
ad_connect  util_ad9656_rx_cpack/packed_fifo_wr axi_ad9656_rx_dma/fifo_wr
ad_connect  $sys_dma_resetn axi_ad9656_rx_dma/m_dest_axi_aresetn

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_ad9656_tpl_core
ad_cpu_interconnect 0x44A60000 axi_ad9656_rx_xcvr
#ad_cpu_interconnect 0x43C10000 axi_ad9656_rx_clkgen
ad_cpu_interconnect 0x44AA0000 axi_ad9656_rx_jesd
ad_cpu_interconnect 0x7c400000 axi_ad9656_rx_dma

# gt uses hp0, and 100MHz clock for both DRP and AXI4

ad_mem_hp0_interconnect $sys_cpu_clk axi_ad9656_rx_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp2_interconnect $sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp2_interconnect $sys_dma_clk axi_ad9656_rx_dma/m_dest_axi

# interrupts

ad_cpu_interrupt ps-10 mb-15 axi_ad9656_rx_jesd/irq
ad_cpu_interrupt ps-13 mb-12 axi_ad9656_rx_dma/irq

