
## Offload attributes
set adc_offload_type 1                      ; ## PL_DDR
set adc_offload_size 4294967295            ; ## 4 Gbyte
set adc_offload_src_width 128
set adc_offload_dst_width 64
set adc_offload_axi_data_width 512
set adc_offload_axi_addr_width 30

set dac_offload_type 0                      ; ## BRAM
set dac_offload_size 512000                 ; ## 512 kbyte
set dac_offload_src_dwidth 128
set dac_offload_dst_dwidth 128

## NOTE: With this configuration the #36Kb BRAM utilization is at ~51%

source $ad_hdl_dir/projects/common/zc706/zc706_system_bd.tcl
source ../common/daq2_bd.tcl

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9
set sys_cstring "sys rom custom string placeholder"
sysid_gen_sys_init_file $sys_cstring


