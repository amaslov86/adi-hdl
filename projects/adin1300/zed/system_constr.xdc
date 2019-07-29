set_property -dict {PACKAGE_PIN K21   IOSTANDARD LVCMOS25} [get_ports mii_mdc_fmc]               ; ## G19 FMC_LPC_LA16_N
set_property -dict {PACKAGE_PIN J20   IOSTANDARD LVCMOS25 PULLUP true} [get_ports mii_mdio_fmc]  ; ## G18 FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN J16   IOSTANDARD LVCMOS25} [get_ports mii_reset_n]               ; ## H19 FMC_LPC_LA15_P
set_property -dict {PACKAGE_PIN M19   IOSTANDARD LVCMOS25} [get_ports mii_ref_clk_25]            ; ## G06 FMC_LPC_LA00_CC_P
set_property -dict {PACKAGE_PIN B20   IOSTANDARD LVCMOS25} [get_ports mii_rx_clk]                ; ## D21 FMC_LPC_LA17_CC_N
set_property -dict {PACKAGE_PIN E20   IOSTANDARD LVCMOS25} [get_ports {mii_rxd[0]}]              ; ## H26 FMC_LPC_LA21_N
set_property -dict {PACKAGE_PIN E18   IOSTANDARD LVCMOS25} [get_ports {mii_rxd[1]}]              ; ## D27 FMC_LPC_LA26_N
set_property -dict {PACKAGE_PIN D22   IOSTANDARD LVCMOS25} [get_ports {mii_rxd[2]}]              ; ## G27 FMC_LPC_LA25_P
set_property -dict {PACKAGE_PIN D21   IOSTANDARD LVCMOS25} [get_ports {mii_rxd[3]}]              ; ## C27 FMC_LPC_LA27_N
set_property -dict {PACKAGE_PIN G20   IOSTANDARD LVCMOS25} [get_ports mii_rx_dv]                 ; ## G21 FMC_LPC_LA20_P
set_property -dict {PACKAGE_PIN C20   IOSTANDARD LVCMOS25} [get_ports mii_rx_er]                 ; ## C23 FMC_LPC_LA18_CC_N
set_property -dict {PACKAGE_PIN D20   IOSTANDARD LVCMOS25} [get_ports mii_crs]                   ; ## C22 FMC_LPC_LA18_CC_P
set_property -dict {PACKAGE_PIN M17   IOSTANDARD LVCMOS25} [get_ports mii_col]                   ; ## D18 FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN B19   IOSTANDARD LVCMOS25} [get_ports mii_tx_clk]                ; ## D20 FMC_LPC_LA17_CC_P
set_property -dict {PACKAGE_PIN J22   IOSTANDARD LVCMOS25} [get_ports {mii_txd[0]}]              ; ## G13 FMC_LPC_LA08_N
set_property -dict {PACKAGE_PIN K18   IOSTANDARD LVCMOS25} [get_ports {mii_txd[1]}]              ; ## D12 FMC_LPC_LA05_N
set_property -dict {PACKAGE_PIN J21   IOSTANDARD LVCMOS25} [get_ports {mii_txd[2]}]              ; ## G12 FMC_LPC_LA08_P
set_property -dict {PACKAGE_PIN J18   IOSTANDARD LVCMOS25} [get_ports {mii_txd[3]}]              ; ## D11 FMC_LPC_LA05_P
set_property -dict {PACKAGE_PIN K19   IOSTANDARD LVCMOS25} [get_ports mii_tx_en]                 ; ## C18 FMC_LPC_LA14_P
set_property -dict {PACKAGE_PIN L17   IOSTANDARD LVCMOS25} [get_ports mii_tx_er]                 ; ## D17 FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN N20   IOSTANDARD LVCMOS25} [get_ports mii_ext_clk_fmc]           ; ## D09 FMC_LPC_LA01_CC_N
set_property -dict {PACKAGE_PIN R21   IOSTANDARD LVCMOS25} [get_ports mii_sw_1]                  ; ## D15 FMC_LPC_LA09_N
set_property -dict {PACKAGE_PIN P20   IOSTANDARD LVCMOS25} [get_ports mii_sw_2]                  ; ## G15 FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P21   IOSTANDARD LVCMOS25} [get_ports mii_sw_3]                  ; ## G16 FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN G21   IOSTANDARD LVCMOS25} [get_ports mii_led_a]                 ; ## G22 FMC_LPC_LA20_N
set_property -dict {PACKAGE_PIN G19   IOSTANDARD LVCMOS25} [get_ports mii_led_b]                 ; ## G24 FMC_LPC_LA22_P
set_property -dict {PACKAGE_PIN B16   IOSTANDARD LVCMOS25} [get_ports mii_sw_4]                  ; ## G33 FMC_LPC_LA31_P
set_property -dict {PACKAGE_PIN B21   IOSTANDARD LVCMOS25} [get_ports mii_sw_5]                  ; ## G36 FMC_LPC_LA33_P
set_property -dict {PACKAGE_PIN B22   IOSTANDARD LVCMOS25} [get_ports mii_sw_6]                  ; ## G37 FMC_LPC_LA33_N

create_clock -name mii_rx_clk  -period  40.00  [get_ports mii_rx_clk]
create_clock -name mii_tx_clk  -period  40.00  [get_ports mii_tx_clk]
