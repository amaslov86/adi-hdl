set_property -dict {PACKAGE_PIN AE17  IOSTANDARD LVCMOS25} [get_ports rmii_mdc_fmc]               ; ## G19 FMC_LPC_LA16_N
set_property -dict {PACKAGE_PIN AE18  IOSTANDARD LVCMOS25 PULLUP true} [get_ports rmii_mdio_fmc]  ; ## G18 FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN AB15  IOSTANDARD LVCMOS25} [get_ports rmii_reset_n]               ; ## H19 FMC_LPC_LA15_P
set_property -dict {PACKAGE_PIN AE13  IOSTANDARD LVCMOS25} [get_ports rmii_ref_clk_25]            ; ## G06 FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN AH29  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd[0]}]              ; ## H26 FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN AK30  IOSTANDARD LVCMOS25} [get_ports {rmii_rxd[1]}]              ; ## D27 FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN AG26  IOSTANDARD LVCMOS25} [get_ports rmii_crs_dv]                 ; ## G21 FMC_LPC_LA20_P
set_property -dict {PACKAGE_PIN AE27  IOSTANDARD LVCMOS25} [get_ports rmii_rx_er]                 ; ## C22 FMC_LPC_LA18_CC_P
set_property -dict {PACKAGE_PIN AD13  IOSTANDARD LVCMOS25} [get_ports {rmii_txd[0]}]              ; ## G13 FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN AE15  IOSTANDARD LVCMOS25} [get_ports {rmii_txd[1]}]              ; ## D12 FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN AF18  IOSTANDARD LVCMOS25} [get_ports rmii_tx_en]                 ; ## C18 FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN AG15  IOSTANDARD LVCMOS25} [get_ports rmii_clk_fmc]               ; ## D09 FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN AH13  IOSTANDARD LVCMOS25} [get_ports rmii_sw_1]                  ; ## D15 FMC_LPC_LA09_N
set_property -dict {PACKAGE_PIN AD16  IOSTANDARD LVCMOS25} [get_ports rmii_sw_2]                  ; ## G15 FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN AD15  IOSTANDARD LVCMOS25} [get_ports rmii_sw_3]                  ; ## G16 FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN AG27  IOSTANDARD LVCMOS25} [get_ports rmii_led_b]                 ; ## G22 FMC_LPC_LA20_N
set_property -dict {PACKAGE_PIN AK27  IOSTANDARD LVCMOS25} [get_ports rmii_led_a]                 ; ## G24 FMC_LPC_LA22_P
set_property -dict {PACKAGE_PIN AC29  IOSTANDARD LVCMOS25} [get_ports rmii_sw_4]                  ; ## G33 FMC_LPC_LA31_P
set_property -dict {PACKAGE_PIN Y30   IOSTANDARD LVCMOS25} [get_ports rmii_sw_5]                  ; ## G36 FMC_LPC_LA33_P
set_property -dict {PACKAGE_PIN AA30  IOSTANDARD LVCMOS25} [get_ports rmii_sw_6]                  ; ## G37 FMC_LPC_LA33_N

create_generated_clock -name rmii_rx_clk  \
  -source [get_pins i_system_wrapper/system_i/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/C] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/mii_to_rmii_0/U0/rmii2mac_rx_clk_bi_reg/Q]

create_generated_clock -name rmii_tx_clk  \
  -source [get_pins i_system_wrapper/system_i/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/C] \
  -divide_by 2 [get_pins i_system_wrapper/system_i/mii_to_rmii_0/U0/rmii2mac_tx_clk_bi_reg/Q]
