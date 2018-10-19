set LINK_LAYER_BYTES_PER_BEAT 4


# TX parameters
set TX_NUM_OF_LANES 1      ; # L
set TX_NUM_OF_CONVERTERS 4 ; # M
set TX_SAMPLES_PER_FRAME 1 ; # S
set TX_SAMPLE_WIDTH 16     ; # N/NP

# F = (M * N * S) / (L * 8)
set TX_BYTES_PER_FRAME [expr ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH * $TX_SAMPLES_PER_FRAME) / ($TX_NUM_OF_LANES * 8)];
# one beat per lane must accommodate at least one frame
set TX_TPL_BYTES_PER_BEAT [expr max($TX_BYTES_PER_FRAME, $LINK_LAYER_BYTES_PER_BEAT)]

# datapath width = L * 8 * TPL_BYTES_PER_BEAT / (M * N)
set TX_SAMPLES_PER_CHANNEL [expr ($TX_NUM_OF_LANES * 8 * $TX_TPL_BYTES_PER_BEAT) / ($TX_NUM_OF_CONVERTERS * $TX_SAMPLE_WIDTH)];


# RX parameters
set RX_NUM_OF_LANES 2      ; # L
set RX_NUM_OF_CONVERTERS 4 ; # M
set RX_SAMPLES_PER_FRAME 1 ; # S
set RX_SAMPLE_WIDTH 16     ; # N/NP

set RX_SAMPLES_PER_CHANNEL 1 ; # L * 32 / (M * N)

# RX Observation parameters
set RX_OS_NUM_OF_LANES 2      ; # L
set RX_OS_NUM_OF_CONVERTERS 2 ; # M
set RX_OS_SAMPLES_PER_FRAME 1 ; # S
set RX_OS_SAMPLE_WIDTH 16     ; # N/NP

set RX_OS_SAMPLES_PER_CHANNEL 2 ;  # L * 32 / (M * N)

source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

# adrv9009

create_bd_port -dir I dac_fifo_bypass

# dac peripherals

ad_ip_instance axi_clkgen axi_adrv9009_tx_clkgen
ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.ID 2
ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.CLKIN_PERIOD 4
ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.VCO_MUL 4
ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.CLK0_DIV 4
# When F = 8 add a second clock to drive the transport layer with a 2x slower clock
if {$TX_TPL_BYTES_PER_BEAT > $LINK_LAYER_BYTES_PER_BEAT} {
  ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.ENABLE_CLKOUT1 1
  ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.CLK1_DIV 8
  set tx_link_clk axi_adrv9009_tx_clkgen/clk_0
  set tx_data_clk axi_adrv9009_tx_clkgen/clk_1
} else {
  set tx_link_clk axi_adrv9009_tx_clkgen/clk_0
  set tx_data_clk axi_adrv9009_tx_clkgen/clk_0
}

ad_ip_instance axi_adxcvr axi_adrv9009_tx_xcvr
ad_ip_parameter axi_adrv9009_tx_xcvr CONFIG.NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_tx_xcvr CONFIG.QPLL_ENABLE 1
ad_ip_parameter axi_adrv9009_tx_xcvr CONFIG.TX_OR_RX_N 1
ad_ip_parameter axi_adrv9009_tx_xcvr CONFIG.SYS_CLK_SEL 3
ad_ip_parameter axi_adrv9009_tx_xcvr CONFIG.OUT_CLK_SEL 3

adi_axi_jesd204_tx_create axi_adrv9009_tx_jesd $TX_NUM_OF_LANES

ad_ip_instance ad_ip_jesd204_tpl_dac tx_adrv9009_tpl_core [list \
  NUM_LANES $TX_NUM_OF_LANES \
  NUM_CHANNELS $TX_NUM_OF_CONVERTERS \
  SAMPLES_PER_FRAME $TX_SAMPLES_PER_FRAME \
  CONVERTER_RESOLUTION $TX_SAMPLE_WIDTH \
  BITS_PER_SAMPLE $TX_SAMPLE_WIDTH  \
  OCTETS_PER_BEAT $TX_TPL_BYTES_PER_BEAT \
 ]

ad_ip_instance axi_dmac axi_adrv9009_tx_dma
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.DMA_TYPE_SRC 0
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.DMA_TYPE_DEST 1
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.CYCLIC 1
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.DMA_DATA_WIDTH_DEST $dac_dma_data_width
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_adrv9009_tx_dma CONFIG.AXI_SLICE_SRC true

# adc peripherals

ad_ip_instance axi_clkgen axi_adrv9009_rx_clkgen
ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.ID 2
ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.CLKIN_PERIOD 4
ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.VCO_MUL 4
ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.CLK0_DIV 4

ad_ip_instance axi_adxcvr axi_adrv9009_rx_xcvr
ad_ip_parameter axi_adrv9009_rx_xcvr CONFIG.NUM_OF_LANES $RX_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_rx_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_adrv9009_rx_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_adrv9009_rx_xcvr CONFIG.SYS_CLK_SEL 0
ad_ip_parameter axi_adrv9009_rx_xcvr CONFIG.OUT_CLK_SEL 3

adi_axi_jesd204_rx_create axi_adrv9009_rx_jesd $RX_NUM_OF_LANES

ad_ip_instance ad_ip_jesd204_tpl_adc rx_adrv9009_tpl_core [list \
  NUM_LANES $RX_NUM_OF_LANES \
  NUM_CHANNELS $RX_NUM_OF_CONVERTERS \
  CHANNEL_WIDTH $RX_SAMPLE_WIDTH  \
]

ad_ip_instance axi_dmac axi_adrv9009_rx_dma
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.DMA_DATA_WIDTH_SRC [expr 32*$RX_NUM_OF_LANES] ; #$RX_SAMPLE_WIDTH*$RX_SAMPLES_PER_CHANNEL*$RX_NUM_OF_CONVERTERS
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_adrv9009_rx_dma CONFIG.AXI_SLICE_SRC true

# adc-os peripherals

ad_ip_instance axi_clkgen axi_adrv9009_rx_os_clkgen
ad_ip_parameter axi_adrv9009_rx_os_clkgen CONFIG.ID 2
ad_ip_parameter axi_adrv9009_rx_os_clkgen CONFIG.CLKIN_PERIOD 4
ad_ip_parameter axi_adrv9009_rx_os_clkgen CONFIG.VCO_DIV 1
ad_ip_parameter axi_adrv9009_rx_os_clkgen CONFIG.VCO_MUL 4
ad_ip_parameter axi_adrv9009_rx_os_clkgen CONFIG.CLK0_DIV 4

ad_ip_instance axi_adxcvr axi_adrv9009_rx_os_xcvr
ad_ip_parameter axi_adrv9009_rx_os_xcvr CONFIG.NUM_OF_LANES $RX_OS_NUM_OF_LANES
ad_ip_parameter axi_adrv9009_rx_os_xcvr CONFIG.QPLL_ENABLE 0
ad_ip_parameter axi_adrv9009_rx_os_xcvr CONFIG.TX_OR_RX_N 0
ad_ip_parameter axi_adrv9009_rx_os_xcvr CONFIG.SYS_CLK_SEL 0
ad_ip_parameter axi_adrv9009_rx_os_xcvr CONFIG.OUT_CLK_SEL 3

adi_axi_jesd204_rx_create axi_adrv9009_rx_os_jesd $RX_OS_NUM_OF_LANES

ad_ip_instance ad_ip_jesd204_tpl_adc rx_os_adrv9009_tpl_core [list \
  NUM_LANES $RX_OS_NUM_OF_LANES \
  NUM_CHANNELS $RX_OS_NUM_OF_CONVERTERS \
  CHANNEL_WIDTH $RX_OS_SAMPLE_WIDTH  \
]

ad_ip_instance axi_dmac axi_adrv9009_rx_os_dma
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.DMA_TYPE_SRC 2
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.SYNC_TRANSFER_START 1
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.ASYNC_CLK_DEST_REQ 1
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.ASYNC_CLK_SRC_DEST 1
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.ASYNC_CLK_REQ_SRC 1
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.DMA_DATA_WIDTH_SRC [expr 32*$RX_NUM_OF_LANES]; #$RX_OS_SAMPLE_WIDTH*$RX_OS_SAMPLES_PER_CHANNEL*$RX_OS_NUM_OF_CONVERTERS
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.MAX_BYTES_PER_BURST 256
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.AXI_SLICE_DEST true
ad_ip_parameter axi_adrv9009_rx_os_dma CONFIG.AXI_SLICE_SRC true

# common cores

#ad_ip_instance axi_adrv9009 axi_adrv9009_core

ad_ip_instance util_adxcvr util_adrv9009_xcvr
ad_ip_parameter util_adrv9009_xcvr CONFIG.RX_NUM_OF_LANES [expr $RX_NUM_OF_LANES+$RX_OS_NUM_OF_LANES]
ad_ip_parameter util_adrv9009_xcvr CONFIG.TX_NUM_OF_LANES $TX_NUM_OF_LANES
ad_ip_parameter util_adrv9009_xcvr CONFIG.TX_OUT_DIV 1
ad_ip_parameter util_adrv9009_xcvr CONFIG.CPLL_FBDIV 4
ad_ip_parameter util_adrv9009_xcvr CONFIG.CPLL_FBDIV_4_5 5
ad_ip_parameter util_adrv9009_xcvr CONFIG.RX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_xcvr CONFIG.TX_CLK25_DIV 10
ad_ip_parameter util_adrv9009_xcvr CONFIG.RX_PMA_CFG 0x001E7080
ad_ip_parameter util_adrv9009_xcvr CONFIG.RX_CDR_CFG 0x0b000023ff10400020
ad_ip_parameter util_adrv9009_xcvr CONFIG.QPLL_FBDIV 80

# xcvr interfaces

create_bd_port -dir I tx_ref_clk_0
create_bd_port -dir I rx_ref_clk_0
create_bd_port -dir I rx_ref_clk_2

set rx_offset 0
set rx_obs_offset 2
set rx_ref_clk     rx_ref_clk_0
set rx_obs_ref_clk rx_ref_clk_2

ad_connect  sys_cpu_resetn util_adrv9009_xcvr/up_rstn
ad_connect  sys_cpu_clk util_adrv9009_xcvr/up_clk

# Tx
ad_xcvrcon  util_adrv9009_xcvr axi_adrv9009_tx_xcvr axi_adrv9009_tx_jesd ; # {0 3 2 1} use link remaping from the 9009 xbar
ad_reconct  util_adrv9009_xcvr/tx_out_clk_0 axi_adrv9009_tx_clkgen/clk
for {set i 0} {$i < $TX_NUM_OF_LANES} {incr i} {
  ad_connect  $tx_link_clk util_adrv9009_xcvr/tx_clk_$i
}
ad_xcvrpll  tx_ref_clk_0 util_adrv9009_xcvr/qpll_ref_clk_0
ad_xcvrpll  axi_adrv9009_tx_xcvr/up_pll_rst util_adrv9009_xcvr/up_qpll_rst_0
ad_connect  $tx_link_clk axi_adrv9009_tx_jesd/device_clk
ad_connect  $tx_link_clk axi_adrv9009_tx_jesd_rstgen/slowest_sync_clk

# Rx
ad_xcvrcon  util_adrv9009_xcvr axi_adrv9009_rx_xcvr axi_adrv9009_rx_jesd
ad_reconct  util_adrv9009_xcvr/rx_out_clk_$rx_offset axi_adrv9009_rx_clkgen/clk
for {set i 0} {$i < $RX_NUM_OF_LANES} {incr i} {
  set ch [expr $rx_offset+$i]
  ad_connect  axi_adrv9009_rx_clkgen/clk_0 util_adrv9009_xcvr/rx_clk_$ch
  ad_xcvrpll  $rx_ref_clk util_adrv9009_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_adrv9009_rx_xcvr/up_pll_rst util_adrv9009_xcvr/up_cpll_rst_$ch
}
ad_connect  axi_adrv9009_rx_clkgen/clk_0 axi_adrv9009_rx_jesd/device_clk
ad_connect  axi_adrv9009_rx_clkgen/clk_0 axi_adrv9009_rx_jesd_rstgen/slowest_sync_clk

# Rx - OBS
ad_xcvrcon  util_adrv9009_xcvr axi_adrv9009_rx_os_xcvr axi_adrv9009_rx_os_jesd
ad_reconct  util_adrv9009_xcvr/rx_out_clk_$rx_obs_offset axi_adrv9009_rx_os_clkgen/clk
for {set i 0} {$i < $RX_OS_NUM_OF_LANES} {incr i} {
  set ch [expr $rx_obs_offset+$i]
  ad_connect  axi_adrv9009_rx_os_clkgen/clk_0 util_adrv9009_xcvr/rx_clk_$ch
  ad_xcvrpll  $rx_obs_ref_clk util_adrv9009_xcvr/cpll_ref_clk_$ch
  ad_xcvrpll  axi_adrv9009_rx_os_xcvr/up_pll_rst util_adrv9009_xcvr/up_cpll_rst_$ch
}
ad_connect  axi_adrv9009_rx_os_clkgen/clk_0 axi_adrv9009_rx_os_jesd/device_clk
ad_connect  axi_adrv9009_rx_os_clkgen/clk_0 axi_adrv9009_rx_os_jesd_rstgen/slowest_sync_clk

# dma clock & reset

ad_ip_instance proc_sys_reset sys_dma_rstgen
ad_ip_parameter sys_dma_rstgen CONFIG.C_EXT_RST_WIDTH 1

ad_connect  sys_dma_clk sys_dma_rstgen/slowest_sync_clk
ad_connect  sys_dma_resetn sys_dma_rstgen/peripheral_aresetn
ad_connect  sys_dma_reset sys_dma_rstgen/peripheral_reset

# connections (dac)
ad_connect $tx_data_clk tx_adrv9009_tpl_core/link_clk

if {$TX_TPL_BYTES_PER_BEAT > $LINK_LAYER_BYTES_PER_BEAT} {
  ad_ip_instance ad_ip_jesd204_link_upconv tx_link_upconverter [list\
    NUM_LANES $TX_NUM_OF_LANES \
    OCTETS_PER_BEAT_IN $TX_TPL_BYTES_PER_BEAT \
    OCTETS_PER_BEAT_OUT $LINK_LAYER_BYTES_PER_BEAT \
  ]
  ad_connect tx_link_upconverter/in_link_clk $tx_data_clk
  ad_connect tx_link_upconverter/out_link_clk $tx_link_clk

  ad_connect tx_adrv9009_tpl_core/link tx_link_upconverter/in_link
  ad_connect tx_link_upconverter/out_link axi_adrv9009_tx_jesd/tx_data

} else {
  ad_connect axi_adrv9009_tx_jesd/tx_data tx_adrv9009_tpl_core/link
}

if {$TX_NUM_OF_CONVERTERS > 1} {
  #connect FIFO to TPL through upack
  ad_ip_instance util_upack util_adrv9009_tx_upack
  ad_ip_parameter util_adrv9009_tx_upack CONFIG.CHANNEL_DATA_WIDTH [expr $TX_SAMPLE_WIDTH*$TX_SAMPLES_PER_CHANNEL]
  ad_ip_parameter util_adrv9009_tx_upack CONFIG.NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS

  ad_connect $tx_data_clk util_adrv9009_tx_upack/dac_clk

  ad_ip_instance xlconcat adrv9009_tx_data_concat
  ad_ip_parameter adrv9009_tx_data_concat CONFIG.NUM_PORTS $TX_NUM_OF_CONVERTERS

  for {set i 0} {$i < $TX_NUM_OF_CONVERTERS} {incr i} {
    ad_ip_instance xlslice adrv9009_enable_slice_$i [list \
      DIN_WIDTH $TX_NUM_OF_CONVERTERS \
      DIN_FROM $i \
      DIN_TO $i \
    ]
    ad_ip_instance xlslice adrv9009_valid_slice_$i [list \
      DIN_WIDTH $TX_NUM_OF_CONVERTERS \
      DIN_FROM $i \
      DIN_TO $i \
    ]
    ad_connect tx_adrv9009_tpl_core/enable adrv9009_enable_slice_$i/Din
    ad_connect tx_adrv9009_tpl_core/dac_valid adrv9009_valid_slice_$i/Din

    ad_connect adrv9009_enable_slice_$i/Dout util_adrv9009_tx_upack/dac_enable_$i
    ad_connect adrv9009_valid_slice_$i/Dout util_adrv9009_tx_upack/dac_valid_$i
    ad_connect util_adrv9009_tx_upack/dac_data_$i adrv9009_tx_data_concat/In$i

  }
  ad_connect tx_adrv9009_tpl_core/dac_ddata adrv9009_tx_data_concat/dout
  ad_connect util_adrv9009_tx_upack/dac_valid axi_adrv9009_dacfifo/dac_valid
  ad_connect util_adrv9009_tx_upack/dac_data axi_adrv9009_dacfifo/dac_data
} else {
  #connect FIFO to TPL directly
  ad_connect tx_adrv9009_tpl_core/dac_valid axi_adrv9009_dacfifo/dac_valid
  ad_connect tx_adrv9009_tpl_core/dac_ddata axi_adrv9009_dacfifo/dac_data
}
ad_connect tx_adrv9009_tpl_core/dac_dunf axi_adrv9009_dacfifo/dac_dunf


ad_connect $tx_data_clk axi_adrv9009_dacfifo/dac_clk
ad_connect axi_adrv9009_tx_jesd_rstgen/peripheral_reset axi_adrv9009_dacfifo/dac_rst
ad_connect sys_dma_clk axi_adrv9009_dacfifo/dma_clk
ad_connect sys_dma_reset axi_adrv9009_dacfifo/dma_rst
ad_connect sys_dma_clk axi_adrv9009_tx_dma/m_axis_aclk
ad_connect sys_dma_resetn axi_adrv9009_tx_dma/m_src_axi_aresetn

ad_connect axi_adrv9009_dacfifo/dma_xfer_req axi_adrv9009_tx_dma/m_axis_xfer_req
ad_connect axi_adrv9009_dacfifo/dma_ready axi_adrv9009_tx_dma/m_axis_ready
ad_connect axi_adrv9009_dacfifo/dma_data axi_adrv9009_tx_dma/m_axis_data
ad_connect axi_adrv9009_dacfifo/dma_valid axi_adrv9009_tx_dma/m_axis_valid
ad_connect axi_adrv9009_dacfifo/dma_xfer_last axi_adrv9009_tx_dma/m_axis_last

ad_connect axi_adrv9009_dacfifo/bypass dac_fifo_bypass


# connections (adc)

ad_connect axi_adrv9009_rx_clkgen/clk_0 rx_adrv9009_tpl_core/link_clk
ad_connect axi_adrv9009_rx_jesd/rx_data_tdata rx_adrv9009_tpl_core/link_data
ad_connect axi_adrv9009_rx_jesd/rx_data_tvalid rx_adrv9009_tpl_core/link_valid
ad_connect axi_adrv9009_rx_jesd/rx_sof rx_adrv9009_tpl_core/link_sof

if {$RX_NUM_OF_CONVERTERS > 1} {

  #connect DMA to TPL through cpack
  ad_ip_instance util_cpack util_adrv9009_rx_cpack
  ad_ip_parameter util_adrv9009_rx_cpack CONFIG.CHANNEL_DATA_WIDTH [expr $RX_SAMPLE_WIDTH*$RX_SAMPLES_PER_CHANNEL]
  ad_ip_parameter util_adrv9009_rx_cpack CONFIG.NUM_OF_CHANNELS $RX_NUM_OF_CONVERTERS

  ad_connect  axi_adrv9009_rx_clkgen/clk_0 util_adrv9009_rx_cpack/adc_clk
  ad_connect  axi_adrv9009_rx_jesd_rstgen/peripheral_reset util_adrv9009_rx_cpack/adc_rst

  for {set i 0} {$i < $RX_NUM_OF_CONVERTERS} {incr i} {
    ad_ip_instance xlslice adrv9009_rx_data_slice_$i [list \
      DIN_WIDTH [expr $RX_SAMPLE_WIDTH*$RX_SAMPLES_PER_CHANNEL*$RX_NUM_OF_CONVERTERS] \
      DIN_FROM [expr $RX_SAMPLE_WIDTH*$RX_SAMPLES_PER_CHANNEL*($i+1)-1] \
      DIN_TO [expr $RX_SAMPLE_WIDTH*$RX_SAMPLES_PER_CHANNEL*$i] \
    ]

    ad_ip_instance xlslice adrv9009_rx_enable_slice_$i [list \
      DIN_WIDTH $RX_NUM_OF_CONVERTERS \
      DIN_FROM $i \
      DIN_TO $i \
    ]

    ad_ip_instance xlslice adrv9009_rx_valid_slice_$i [list \
      DIN_WIDTH $RX_NUM_OF_CONVERTERS \
      DIN_FROM $i \
      DIN_TO $i \
    ]

    ad_connect rx_adrv9009_tpl_core/adc_data adrv9009_rx_data_slice_$i/Din
    ad_connect rx_adrv9009_tpl_core/enable adrv9009_rx_enable_slice_$i/Din
    ad_connect rx_adrv9009_tpl_core/adc_valid adrv9009_rx_valid_slice_$i/Din

    ad_connect adrv9009_rx_data_slice_$i/Dout util_adrv9009_rx_cpack/adc_data_$i
    ad_connect adrv9009_rx_enable_slice_$i/Dout util_adrv9009_rx_cpack/adc_enable_$i
    ad_connect adrv9009_rx_valid_slice_$i/Dout util_adrv9009_rx_cpack/adc_valid_$i
  }

  ad_connect  util_adrv9009_rx_cpack/adc_valid axi_adrv9009_rx_dma/fifo_wr_en
  ad_connect  util_adrv9009_rx_cpack/adc_sync axi_adrv9009_rx_dma/fifo_wr_sync
  ad_connect  util_adrv9009_rx_cpack/adc_data axi_adrv9009_rx_dma/fifo_wr_din

} else {
  #connect DMA to TPL directly
  ad_connect rx_adrv9009_tpl_core/adc_valid axi_adrv9009_rx_dma/fifo_wr_en
  ad_connect rx_adrv9009_tpl_core/adc_data axi_adrv9009_rx_dma/fifo_wr_din
}
ad_connect  axi_adrv9009_rx_dma/fifo_wr_overflow rx_adrv9009_tpl_core/adc_dovf
ad_connect  axi_adrv9009_rx_clkgen/clk_0 axi_adrv9009_rx_dma/fifo_wr_clk
ad_connect  sys_dma_resetn axi_adrv9009_rx_dma/m_dest_axi_aresetn

# connections (adc-os)

ad_connect axi_adrv9009_rx_os_clkgen/clk_0 rx_os_adrv9009_tpl_core/link_clk
ad_connect axi_adrv9009_rx_os_jesd/rx_data_tdata rx_os_adrv9009_tpl_core/link_data
ad_connect axi_adrv9009_rx_os_jesd/rx_data_tvalid rx_os_adrv9009_tpl_core/link_valid
ad_connect axi_adrv9009_rx_os_jesd/rx_sof rx_os_adrv9009_tpl_core/link_sof

if {$RX_OS_NUM_OF_CONVERTERS > 1} {

  #connect DMA to TPL through cpack
  ad_ip_instance util_cpack util_adrv9009_rx_os_cpack
  ad_ip_parameter util_adrv9009_rx_os_cpack CONFIG.CHANNEL_DATA_WIDTH [expr $RX_OS_SAMPLE_WIDTH*$RX_OS_SAMPLES_PER_CHANNEL]
  ad_ip_parameter util_adrv9009_rx_os_cpack CONFIG.NUM_OF_CHANNELS $RX_OS_NUM_OF_CONVERTERS

  ad_connect  axi_adrv9009_rx_os_clkgen/clk_0 util_adrv9009_rx_os_cpack/adc_clk
  ad_connect  axi_adrv9009_rx_os_jesd_rstgen/peripheral_reset util_adrv9009_rx_os_cpack/adc_rst

  for {set i 0} {$i < $RX_OS_NUM_OF_CONVERTERS} {incr i} {
    ad_ip_instance xlslice adrv9009_rx_os_data_slice_$i [list \
      DIN_WIDTH [expr $RX_OS_SAMPLE_WIDTH*$RX_OS_SAMPLES_PER_CHANNEL*$RX_OS_NUM_OF_CONVERTERS] \
      DIN_FROM [expr $RX_OS_SAMPLE_WIDTH*$RX_OS_SAMPLES_PER_CHANNEL*($i+1)-1] \
      DIN_TO [expr $RX_OS_SAMPLE_WIDTH*$RX_OS_SAMPLES_PER_CHANNEL*$i] \
    ]
    ad_ip_instance xlslice adrv9009_rx_os_enable_slice_$i [list \
      DIN_WIDTH $RX_OS_NUM_OF_CONVERTERS \
      DIN_FROM $i \
      DIN_TO $i \
    ]

    ad_ip_instance xlslice adrv9009_rx_os_valid_slice_$i [list \
      DIN_WIDTH $RX_OS_NUM_OF_CONVERTERS \
      DIN_FROM $i \
      DIN_TO $i \
    ]

    ad_connect rx_os_adrv9009_tpl_core/adc_data adrv9009_rx_os_data_slice_$i/Din
    ad_connect rx_os_adrv9009_tpl_core/enable adrv9009_rx_os_enable_slice_$i/Din
    ad_connect rx_os_adrv9009_tpl_core/adc_valid adrv9009_rx_os_valid_slice_$i/Din

    ad_connect adrv9009_rx_os_data_slice_$i/Dout util_adrv9009_rx_os_cpack/adc_data_$i
    ad_connect adrv9009_rx_os_enable_slice_$i/Dout util_adrv9009_rx_os_cpack/adc_enable_$i
    ad_connect adrv9009_rx_os_valid_slice_$i/Dout util_adrv9009_rx_os_cpack/adc_valid_$i
  }
  ad_connect  util_adrv9009_rx_os_cpack/adc_valid axi_adrv9009_rx_os_dma/fifo_wr_en
  ad_connect  util_adrv9009_rx_os_cpack/adc_sync axi_adrv9009_rx_os_dma/fifo_wr_sync
  ad_connect  util_adrv9009_rx_os_cpack/adc_data axi_adrv9009_rx_os_dma/fifo_wr_din

} else {
  #connect DMA to TPL directly
  ad_connect rx_os_adrv9009_tpl_core/adc_valid axi_adrv9009_rx_os_dma/fifo_wr_en
  ad_connect rx_os_adrv9009_tpl_core/adc_data axi_adrv9009_rx_os_dma/fifo_wr_din
}
ad_connect  axi_adrv9009_rx_os_dma/fifo_wr_overflow rx_os_adrv9009_tpl_core/adc_dovf
ad_connect  axi_adrv9009_rx_os_clkgen/clk_0 axi_adrv9009_rx_os_dma/fifo_wr_clk
ad_connect  sys_dma_resetn axi_adrv9009_rx_os_dma/m_dest_axi_aresetn

# interconnect (cpu)

ad_cpu_interconnect 0x44A00000 rx_adrv9009_tpl_core
ad_cpu_interconnect 0x44A10000 tx_adrv9009_tpl_core
ad_cpu_interconnect 0x44A20000 rx_os_adrv9009_tpl_core
ad_cpu_interconnect 0x44A80000 axi_adrv9009_tx_xcvr
ad_cpu_interconnect 0x43C00000 axi_adrv9009_tx_clkgen
ad_cpu_interconnect 0x44A90000 axi_adrv9009_tx_jesd
ad_cpu_interconnect 0x7c420000 axi_adrv9009_tx_dma
ad_cpu_interconnect 0x44A60000 axi_adrv9009_rx_xcvr
ad_cpu_interconnect 0x43C10000 axi_adrv9009_rx_clkgen
ad_cpu_interconnect 0x44AA0000 axi_adrv9009_rx_jesd
ad_cpu_interconnect 0x7c400000 axi_adrv9009_rx_dma
ad_cpu_interconnect 0x44A50000 axi_adrv9009_rx_os_xcvr
ad_cpu_interconnect 0x43C20000 axi_adrv9009_rx_os_clkgen
ad_cpu_interconnect 0x44AB0000 axi_adrv9009_rx_os_jesd
ad_cpu_interconnect 0x7c440000 axi_adrv9009_rx_os_dma

# gt uses hp0, and 100MHz clock for both DRP and AXI4

ad_mem_hp0_interconnect sys_cpu_clk axi_adrv9009_rx_xcvr/m_axi
ad_mem_hp0_interconnect sys_cpu_clk axi_adrv9009_rx_os_xcvr/m_axi

# interconnect (mem/dac)

ad_mem_hp1_interconnect sys_dma_clk sys_ps7/S_AXI_HP1
ad_mem_hp1_interconnect sys_dma_clk axi_adrv9009_rx_os_dma/m_dest_axi
ad_mem_hp2_interconnect sys_dma_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_dma_clk axi_adrv9009_rx_dma/m_dest_axi
ad_mem_hp3_interconnect sys_dma_clk sys_ps7/S_AXI_HP3
ad_mem_hp3_interconnect sys_dma_clk axi_adrv9009_tx_dma/m_src_axi

# interrupts

ad_cpu_interrupt ps-8 mb-8 axi_adrv9009_rx_os_jesd/irq
ad_cpu_interrupt ps-9 mb-7 axi_adrv9009_tx_jesd/irq
ad_cpu_interrupt ps-10 mb-15 axi_adrv9009_rx_jesd/irq
ad_cpu_interrupt ps-11 mb-14 axi_adrv9009_rx_os_dma/irq
ad_cpu_interrupt ps-12 mb-13- axi_adrv9009_tx_dma/irq
ad_cpu_interrupt ps-13 mb-12 axi_adrv9009_rx_dma/irq
