
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

## FIFO depth is 8Mb - 500k samples
set dac_fifo_address_width 16

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

source ../common/fmcomms8_bd.tcl
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL1_REF_CTRL__FREQMHZ 300


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {199.5} \
   CONFIG.C_DATA_DEPTH {16384} \
   CONFIG.C_MON_TYPE {MIX} \
   CONFIG.C_NUM_MONITOR_SLOTS {8} \
   CONFIG.C_NUM_OF_PROBES {8} \
   CONFIG.C_SLOT {7} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0} \
   CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:display_jesd204:jesd204_rx_bus_rtl:1.0} \
   CONFIG.C_SLOT_4_INTF_TYPE {analog.com:interface:jesd204_rx_cfg_rtl:1.0} \
   CONFIG.C_SLOT_5_INTF_TYPE {analog.com:interface:jesd204_rx_status_rtl:1.0} \
   CONFIG.C_SLOT_6_INTF_TYPE {analog.com:interface:jesd204_rx_ilas_config_rtl:1.0} \
   CONFIG.C_SLOT_7_INTF_TYPE {analog.com:interface:jesd204_rx_event_rtl:1.0} \
 ] $system_ila_0

  ad_connect core_clk_d system_ila_0/clk
  ad_connect axi_adrv9009_fmc_rx_jesd/rx_axi/rx_cfg system_ila_0/SLOT_4_JESD204_RX_CFG
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_phy0 system_ila_0/SLOT_0_JESD204_RX_BUS
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_phy1 system_ila_0/SLOT_1_JESD204_RX_BUS
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_phy2 system_ila_0/SLOT_2_JESD204_RX_BUS
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_phy3 system_ila_0/SLOT_3_JESD204_RX_BUS
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_event system_ila_0/SLOT_7_JESD204_RX_EVENT
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_ilas_config system_ila_0/SLOT_6_JESD204_RX_ILAS_CONFIG
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_status system_ila_0/SLOT_5_JESD204_RX_STATUS

  # Create port connections
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/lmfc_clk system_ila_0/probe2
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/lmfc_edge system_ila_0/probe1
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/phy_en_char_align system_ila_0/probe4
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_data system_ila_0/probe5
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_sof system_ila_0/probe7
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/rx_valid system_ila_0/probe6
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/sync system_ila_0/probe3
  ad_connect axi_adrv9009_fmc_rx_jesd/rx/sysref system_ila_0/probe0
