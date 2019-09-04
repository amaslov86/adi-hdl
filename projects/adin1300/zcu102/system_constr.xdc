
set_property -dict {PACKAGE_PIN AA12 IOSTANDARD LVCMOS18} [get_ports mdc_fmc]                   ; ## G19 FMC_HPC0_LA16_N
set_property -dict {PACKAGE_PIN Y12  IOSTANDARD LVCMOS18 PULLUP true} [get_ports mdio_fmc]      ; ## G18 FMC_HPC0_LA16_P

set_property -dict {PACKAGE_PIN Y10 IOSTANDARD LVCMOS18} [get_ports reset_n]                    ; ## H19 FMC_HPC0_LA15_P
set_property -dict {PACKAGE_PIN Y4  IOSTANDARD LVCMOS18} [get_ports ref_clk_25]                 ; ## G06 FMC_HPC0_LA00_CC_P

set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS18} [get_ports rgmii_rxc]                  ; ## D21 FMC_HPC0_LA17_CC_N
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS18} [get_ports rgmii_rx_ctl]               ; ## G21 FMC_HPC0_LA20_P
set_property -dict {PACKAGE_PIN N12 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd[0]}]             ; ## H26 FMC_HPC0_LA21_N
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd[1]}]             ; ## D27 FMC_HPC0_LA26_N
set_property -dict {PACKAGE_PIN M11 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd[2]}]             ; ## G27 FMC_HPC0_LA25_P
set_property -dict {PACKAGE_PIN L10 IOSTANDARD LVCMOS18} [get_ports {rgmii_rxd[3]}]             ; ## C27 FMC_HPC0_LA27_N
set_property -dict {PACKAGE_PIN P11 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rgmii_txc]        ; ## D20 FMC_HPC0_LA17_CC_P
set_property -dict {PACKAGE_PIN AC7 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports rgmii_tx_ctl]     ; ## C18 FMC_HPC0_LA14_P
set_property -dict {PACKAGE_PIN V3  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd[0]}]   ; ## G13 FMC_HPC0_LA08_N
set_property -dict {PACKAGE_PIN AC3 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd[1]}]   ; ## D12 FMC_HPC0_LA05_N
set_property -dict {PACKAGE_PIN V4  IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd[2]}]   ; ## G12 FMC_HPC0_LA08_P
set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS18 SLEW FAST} [get_ports {rgmii_txd[3]}]   ; ## D11 FMC_HPC0_LA05_P

set_property -dict {PACKAGE_PIN N9  IOSTANDARD LVCMOS18} [get_ports gp_clk]                     ; ## C22 FMC_HPC0_LA18_CC_P
set_property -dict {PACKAGE_PIN N8  IOSTANDARD LVCMOS18} [get_ports link_st]                    ; ## C23 FMC_HPC0_LA18_CC_N
set_property -dict {PACKAGE_PIN AC4 IOSTANDARD LVCMOS18} [get_ports ext_clk_fmc]                ; ## D09 FMC_HPC0_LA01_CC_N
set_property -dict {PACKAGE_PIN AC8 IOSTANDARD LVCMOS18} [get_ports int_n]                      ; ## D18 FMC_HPC0_LA13_N
set_property -dict {PACKAGE_PIN W1  IOSTANDARD LVCMOS18} [get_ports sw_1]                       ; ## D15 FMC_HPC0_LA09_N
set_property -dict {PACKAGE_PIN W7  IOSTANDARD LVCMOS18} [get_ports sw_2]                       ; ## G15 FMC_HPC0_LA12_P
set_property -dict {PACKAGE_PIN W6  IOSTANDARD LVCMOS18} [get_ports sw_3]                       ; ## G16 FMC_HPC0_LA12_N
set_property -dict {PACKAGE_PIN V8  IOSTANDARD LVCMOS18} [get_ports sw_4]                       ; ## G33 FMC_HPC0_LA31_P
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS18} [get_ports sw_5]                       ; ## G36 FMC_HPC0_LA33_P
set_property -dict {PACKAGE_PIN V11 IOSTANDARD LVCMOS18} [get_ports sw_6]                       ; ## G37 FMC_HPC0_LA33_N
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS18} [get_ports led_0]                      ; ## D17 FMC_HPC0_LA13_P
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS18} [get_ports led_b]                      ; ## G22 FMC_HPC0_LA20_N
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports led_a]                      ; ## G24 FMC_HPC0_LA22_P

set_property -dict {PACKAGE_PIN V7  IOSTANDARD LVCMOS18} [get_ports io_sda]                     ; ## G34 FMC_HPC0_LA31_N
set_property -dict {PACKAGE_PIN U11 IOSTANDARD LVCMOS18} [get_ports io_scl]                     ; ## H37 FMC_HPC0_LA32_P

create_clock -name rx_clk       -period  8.0 [get_ports rgmii_rxc]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets {i_system_wrapper/system_i/gmii_to_rgmii_fmc0/U0/i_gmii_to_rgmii_block/rgmii_rxc_ibuf_i/O}]

set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports rgmii_txc]

