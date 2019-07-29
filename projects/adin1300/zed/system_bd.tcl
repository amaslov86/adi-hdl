
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl

set_property -dict [list \
  CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {1} \
  CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {1}] [get_bd_cells sys_ps7]

make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/MDIO_ETHERNET_1]
make_bd_intf_pins_external  [get_bd_intf_pins sys_ps7/GMII_ETHERNET_1]


