
source ../../scripts/adi_env.tcl
source ../../scripts/adi_project_intel.tcl

adi_project adin1300_a10soc

source $ad_hdl_dir/projects/common/a10soc/a10soc_system_assign.tcl

###############################################################################
# Triyng to use other pins, this issue migth not be true in the future
###############################################################################
# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#  R610: DNI -> R0
#  R611: DNI -> R0
#  R612: R0 -> DNI
#  R613: R0 -> DNI
#  R620: DNI -> R0
#  R632: DNI -> R0
#  R621: R0 -> DNI
#  R633: R0 -> DNI
###############################################################################

set_location_assignment PIN_D6    -to mdio_fmc           ; ## G18  FMCA_HPC_LA16_P
set_location_assignment PIN_E6    -to mdc_fmc            ; ## G19  FMCA_HPC_LA16_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mdio_fmc
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to mdio_fmc
set_instance_assignment -name IO_STANDARD "1.8 V" -to mdc_fmc


set_location_assignment PIN_G9    -to rgmii_rxc          ; ## D21  FMCA_HPC_LA17_CC_N
set_location_assignment PIN_C3    -to rgmii_rx_ctl       ; ## G21  FMCA_HPC_LA20_P
set_location_assignment PIN_D3    -to rgmii_rxd[0]       ; ## H26  FMCA_HPC_LA21_N
set_location_assignment PIN_G2    -to rgmii_rxd[1]       ; ## D27  FMCA_HPC_LA26_N
set_location_assignment PIN_E3    -to rgmii_rxd[2]       ; ## G27  FMCA_HPC_LA25_P
set_location_assignment PIN_H2    -to rgmii_rxd[3]       ; ## C27  FMCA_HPC_LA27_N

set_location_assignment PIN_F9    -to rgmii_txc          ; ## D20  FMCA_HPC_LA17_CC_P
set_location_assignment PIN_J9    -to rgmii_tx_ctl       ; ## C18  FMCA_HPC_LA14_P
set_location_assignment PIN_B12   -to rgmii_txd[0]       ; ## G13  FMCA_LA08_N
set_location_assignment PIN_F14   -to rgmii_txd[1]       ; ## D12  FMCA_LA05_N
set_location_assignment PIN_B11   -to rgmii_txd[2]       ; ## G12  FMCA_LA08_P
set_location_assignment PIN_F13   -to rgmii_txd[3]       ; ## D11  FMCA_LA05_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to rgmii_rxc
set_instance_assignment -name IO_STANDARD "1.8 V" -to rgmii_rx_ctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to rgmii_rxd
set_instance_assignment -name IO_STANDARD "1.8 V" -to rgmii_txc
set_instance_assignment -name IO_STANDARD "1.8 V" -to rgmii_tx_ctl
set_instance_assignment -name IO_STANDARD "1.8 V" -to rgmii_txd


set_location_assignment PIN_G7    -to gp_clk             ; ## C22  FMCA_HPC_LA18_CC_P
set_location_assignment PIN_H7    -to link_st            ; ## C23  FMCA_HPC_LA18_CC_N
set_location_assignment PIN_E13   -to ext_clk_fmc        ; ## D09  FMCA_HPC_LA01_CC_N ## rework required
set_location_assignment PIN_K11   -to int_n              ; ## D18  FMCA_LA13_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to gp_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to link_st
set_instance_assignment -name IO_STANDARD "1.8 V" -to ext_clk_fmc
set_instance_assignment -name IO_STANDARD "1.8 V" -to int_n


set_location_assignment PIN_A13   -to sw_1               ; ## D15  FMCA_LA09_N
set_location_assignment PIN_M12   -to sw_2               ; ## G15  FMCA_LA12_P
set_location_assignment PIN_N13   -to sw_3               ; ## G16  FMCA_LA12_N
set_location_assignment PIN_P8    -to sw_4               ; ## G33  FMCA_HPC_LA31_P
set_location_assignment PIN_P11   -to sw_5               ; ## G36  FMCA_HPC_LA33_P
set_location_assignment PIN_R11   -to sw_6               ; ## G37  FMCA_HPC_LA33_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to sw_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to sw_2
set_instance_assignment -name IO_STANDARD "1.8 V" -to sw_3
set_instance_assignment -name IO_STANDARD "1.8 V" -to sw_4
set_instance_assignment -name IO_STANDARD "1.8 V" -to sw_5
set_instance_assignment -name IO_STANDARD "1.8 V" -to sw_6


set_location_assignment PIN_C4    -to led_b             ; ## G22  FMCA_HPC_LA20_N
set_location_assignment PIN_F4    -to led_a             ; ## G24  FMCA_HPC_LA22_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to led_a
set_instance_assignment -name IO_STANDARD "1.8 V" -to led_b


set_location_assignment PIN_R8    -to io_sda            ; ## G34  FMCA_HPC_LA31_N
set_location_assignment PIN_L8    -to io_scl            ; ## H37  FMCA_HPC_LA32_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to io_sda
set_instance_assignment -name IO_STANDARD "1.8 V" -to io_scl


set_location_assignment PIN_D4    -to reset_n           ; ## H19  FMCA_HPC_LA15_P

set_instance_assignment -name IO_STANDARD "1.8 V" -to reset_n


execute_flow -compile
