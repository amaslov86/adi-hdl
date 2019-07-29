
source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl

set_property -dict [list CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} \
                         CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {1} \
                         CONFIG.PCW_QSPI_GRP_IO1_ENABLE {1} \
                         CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {100 Mbps}] [get_bd_cells sys_ps7]

make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_1]

create_bd_cell -type ip -vlnv xilinx.com:ip:mii_to_rmii:2.0 mii_to_rmii_0
set_property -dict [list CONFIG.C_MODE {1}] [get_bd_cells mii_to_rmii_0]

ad_connect mii_to_rmii_0/GMII    sys_ps7/GMII_ETHERNET_1
ad_connect mii_to_rmii_0/ref_clk sys_ps7/FCLK_CLK2
ad_connect mii_to_rmii_0/rst_n   sys_ps7/FCLK_RESET1_N

create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rmii_rtl:1.0 RMII_PHY_M
ad_connect mii_to_rmii_0/RMII_PHY_M RMII_PHY_M

create_bd_port -dir O clk_50
ad_connect clk_50 sys_ps7/FCLK_CLK2
