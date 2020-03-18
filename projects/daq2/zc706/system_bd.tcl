
## Offload attributes
set adc_offload_name "axi_ad9680_offload"
set adc_offload_type 1                      ; ## PL_DDR
set adc_offload_size 4294967295             ; ## 4 Gbyte
set adc_offload_src_width 128
set adc_offload_dst_width 64
set adc_offload_axi_data_width 512
set adc_offload_axi_addr_width 30

set dac_offload_name "axi_ad9144_offload"
set dac_offload_type 0                      ; ## BRAM
set dac_offload_size 512000                 ; ## 512 kbyte
set dac_offload_src_dwidth 128
set dac_offload_dst_dwidth 128

## NOTE: With this configuration the #36Kb BRAM utilization is at ~51%

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/daq2_bd.tcl

################################################################################
## DDR3 MIG for Data Offload IP
################################################################################

if {$adc_offload_type} {
  set offload_name $adc_offload_name
}

if {$dac_offload_type} {
  set offload_name $dac_offload_name
}

if {$adc_offload_type || $dac_offload_type} {

    ad_ip_instance proc_sys_reset axi_rstgen
    ad_ip_instance mig_7series axi_ddr_cntrl
    file copy -force $ad_hdl_dir/projects/common/zc706/zc706_plddr3_mig.prj [get_property IP_DIR \
      [get_ips [get_property CONFIG.Component_Name [get_bd_cells axi_ddr_cntrl]]]]
    ad_ip_parameter axi_ddr_cntrl CONFIG.XML_INPUT_FILE zc706_plddr3_mig.prj

    # PL-DDR data offload interfaces
    create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk
    create_bd_port -dir I -type rst sys_rst
    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3

    ad_connect axi_ddr_cntrl/ui_clk axi_rstgen/slowest_sync_clk
    ad_connect axi_ddr_cntrl/ui_clk $offload_name/fifo2axi_bridge/axi_clk
    ad_connect axi_ddr_cntrl/S_AXI $offload_name/fifo2axi_bridge/ddr_axi
    ad_connect axi_rstgen/peripheral_aresetn $offload_name/fifo2axi_bridge/axi_resetn
    ad_connect axi_rstgen/peripheral_aresetn axi_ddr_cntrl/aresetn
    ad_connect sys_rst axi_rstgen/ext_reset_in

    assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]

    ad_connect  sys_rst axi_ddr_cntrl/sys_rst
    ad_connect  sys_clk axi_ddr_cntrl/SYS_CLK
    ad_connect  ddr3    axi_ddr_cntrl/DDR3

}

################################################################################
# System ID
################################################################################

ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring

