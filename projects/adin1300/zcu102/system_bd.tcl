
source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl

set_property -dict [list \
  CONFIG.PSU__ENET0__GRP_MDIO__ENABLE {1} \
  CONFIG.PSU__ENET0__GRP_MDIO__IO {EMIO} \
  CONFIG.PSU__ENET0__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU__ENET0__PERIPHERAL__IO {EMIO}] [get_bd_cells sys_ps8]

ad_ip_instance gmii_to_rgmii gmii_to_rgmii_fmc0
ad_ip_parameter gmii_to_rgmii_fmc0 CONFIG.SupportLevel Include_Shared_Logic_in_Core


ad_ip_instance clk_wiz clk_wiz_375
set_property -dict [list CONFIG.PRIM_IN_FREQ {25}] [get_bd_cells clk_wiz_375]
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {375}] [get_bd_cells clk_wiz_375]

make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_fmc0/MDIO_PHY]
make_bd_intf_pins_external  [get_bd_intf_pins gmii_to_rgmii_fmc0/RGMII]

connect_bd_intf_net [get_bd_intf_pins gmii_to_rgmii_fmc0/GMII] [get_bd_intf_pins sys_ps8/GMII_ENET0]
connect_bd_intf_net [get_bd_intf_pins gmii_to_rgmii_fmc0/MDIO_GEM] [get_bd_intf_pins sys_ps8/MDIO_ENET0]

create_bd_port -dir I ref_clk_25
create_bd_port -dir O reset_n

ad_ip_instance proc_sys_reset proc_rgmii_reset

ad_connect gmii_to_rgmii_fmc0/clkin clk_wiz_375/clk_out1

ad_connect ref_clk_25 clk_wiz_375/clk_in1
ad_connect sys_rstgen/peripheral_reset clk_wiz_375/reset
ad_connect proc_rgmii_reset/ext_reset_in sys_rstgen/peripheral_reset

ad_connect reset_n proc_rgmii_reset/peripheral_aresetn

ad_connect proc_rgmii_reset/dcm_locked clk_wiz_375/locked
ad_connect proc_rgmii_reset/slowest_sync_clk clk_wiz_375/clk_out1
ad_connect proc_rgmii_reset/peripheral_reset gmii_to_rgmii_fmc0/tx_reset
ad_connect gmii_to_rgmii_fmc0/rx_reset proc_rgmii_reset/peripheral_reset

connect_bd_net [get_bd_pins sys_ps8/maxihpm0_lpd_aclk] [get_bd_pins sys_ps8/pl_clk0]

make_bd_pins_external  [get_bd_pins gmii_to_rgmii_fmc0/clock_speed]
