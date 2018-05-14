# pl ddr4 (use only when dma is not capable of keeping up).
# generic fifo interface - existence is oblivious to software.

ad_ip_instance proc_sys_reset axi_rstgen
ad_ip_instance ip:ddr4 axi_ddr_cntrl
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_CLOCK_BOARD_INTERFACE {user_si570_sysclk}
ad_ip_parameter axi_ddr_cntrl CONFIG.C0_DDR4_BOARD_INTERFACE {ddr4_sdram}
ad_ip_parameter axi_ddr_cntrl CONFIG.RESET_BOARD_INTERFACE {reset}

create_bd_port -dir I -type rst sys_rst
set_property CONFIG.POLARITY ACTIVE_HIGH [get_bd_ports sys_rst]

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 c0_ddr4
create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk
ad_ip_parameter sys_clk CONFIG.FREQ_HZ {300000000} 

ad_connect  sys_rst axi_ddr_cntrl/sys_rst
ad_connect  sys_clk axi_ddr_cntrl/C0_SYS_CLK
ad_connect  c0_ddr4 axi_ddr_cntrl/C0_DDR4

ad_ip_instance axi_adcfifo $adc_fifo_name
ad_ip_parameter $adc_fifo_name CONFIG.ADC_DATA_WIDTH $adc_data_width
ad_ip_parameter $adc_fifo_name CONFIG.DMA_DATA_WIDTH $adc_dma_data_width
ad_ip_parameter $adc_fifo_name CONFIG.AXI_DATA_WIDTH 128
ad_ip_parameter $adc_fifo_name CONFIG.DMA_READY_ENABLE 1
ad_ip_parameter $adc_fifo_name CONFIG.AXI_SIZE 6
ad_ip_parameter $adc_fifo_name CONFIG.AXI_LENGTH 4 
ad_ip_parameter $adc_fifo_name CONFIG.AXI_ADDRESS 0x80000000
ad_ip_parameter $adc_fifo_name CONFIG.AXI_ADDRESS_LIMIT 0xa0000000

ad_connect  axi_ddr_cntrl/C0_DDR4S_AXI $adc_fifo_name/axi
ad_connect  axi_ddr_cntrl/c0_ddr4_ui_clk $adc_fifo_name/axi_clk
ad_connect  axi_ddr_cntrl/c0_ddr4_ui_clk axi_rstgen/slowest_sync_clk
ad_connect  axi_rstgen/ext_reset_in axi_ddr_cntrl/c0_ddr4_ui_clk_sync_rst
ad_connect  axi_rstgen/peripheral_aresetn $adc_fifo_name/axi_resetn
ad_connect  axi_rstgen/peripheral_aresetn axi_ddr_cntrl/aresetn

assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]

