#set_property  -dict {PACKAGE_PIN G7 }  [get_ports clk_buf_tp_n]
#set_property  -dict {PACKAGE_PIN G8 }  [get_ports clk_buf_tp_p]
set_property  -dict {PACKAGE_PIN AA7   IOSTANDARD LVCMOS18}  [get_ports dev_clk_out]
set_property  -dict {PACKAGE_PIN AC6   IOSTANDARD LVDS}  [get_ports dev_mcs_fpga_in_n]
set_property  -dict {PACKAGE_PIN AC7   IOSTANDARD LVDS}  [get_ports dev_mcs_fpga_in_p]

set_property  -dict {PACKAGE_PIN Y12   IOSTANDARD LVCMOS18}  [get_ports dgpio_0]
set_property  -dict {PACKAGE_PIN AA12  IOSTANDARD LVCMOS18}  [get_ports dgpio_1]
set_property  -dict {PACKAGE_PIN Y9    IOSTANDARD LVCMOS18}  [get_ports dgpio_2]
set_property  -dict {PACKAGE_PIN AB5   IOSTANDARD LVCMOS18}  [get_ports dgpio_3]
set_property  -dict {PACKAGE_PIN W1    IOSTANDARD LVCMOS18}  [get_ports dgpio_4]
set_property  -dict {PACKAGE_PIN W4    IOSTANDARD LVCMOS18}  [get_ports dgpio_5]
set_property  -dict {PACKAGE_PIN M10   IOSTANDARD LVCMOS18}  [get_ports dgpio_6]
set_property  -dict {PACKAGE_PIN L15   IOSTANDARD LVCMOS18}  [get_ports dgpio_7]
set_property  -dict {PACKAGE_PIN T7    IOSTANDARD LVCMOS18}  [get_ports dgpio_8]
set_property  -dict {PACKAGE_PIN T6    IOSTANDARD LVCMOS18}  [get_ports dgpio_9]
set_property  -dict {PACKAGE_PIN AB6   IOSTANDARD LVCMOS18}  [get_ports dgpio_10]
set_property  -dict {PACKAGE_PIN L10   IOSTANDARD LVCMOS18}  [get_ports dgpio_11]

set_property  -dict {PACKAGE_PIN T11   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_mcs_in_n]
set_property  -dict {PACKAGE_PIN U11   IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_mcs_in_p]
set_property  -dict {PACKAGE_PIN R8    IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_ref_clk_n]
set_property  -dict {PACKAGE_PIN T8    IOSTANDARD LVDS DIFF_TERM_ADV TERM_100}  [get_ports fpga_ref_clk_p]
set_property  -dict {PACKAGE_PIN V6    IOSTANDARD LVCMOS18}  [get_ports gp_int]
set_property  -dict {PACKAGE_PIN AB8   IOSTANDARD LVCMOS18}  [get_ports mode]
set_property  -dict {PACKAGE_PIN AC8   IOSTANDARD LVCMOS18}  [get_ports reset_trx]

set_property  -dict {PACKAGE_PIN W5    IOSTANDARD LVCMOS18}  [get_ports rx1_enable]
set_property  -dict {PACKAGE_PIN K15   IOSTANDARD LVCMOS18}  [get_ports rx2_enable]

set_property  -dict {PACKAGE_PIN AA6   IOSTANDARD LVCMOS18}  [get_ports sm_fan_tach]

set_property  -dict {PACKAGE_PIN W7    IOSTANDARD LVCMOS18}  [get_ports spi_clk]
set_property  -dict {PACKAGE_PIN U8    IOSTANDARD LVCMOS18}  [get_ports spi_dio]
set_property  -dict {PACKAGE_PIN W6    IOSTANDARD LVCMOS18}  [get_ports spi_do]
set_property  -dict {PACKAGE_PIN Y10   IOSTANDARD LVCMOS18}  [get_ports spi_en]

set_property  -dict {PACKAGE_PIN W2    IOSTANDARD LVCMOS18}  [get_ports tx1_enable]
set_property  -dict {PACKAGE_PIN U9    IOSTANDARD LVCMOS18}  [get_ports tx2_enable]

set_property  -dict {PACKAGE_PIN V8    IOSTANDARD LVCMOS18}  [get_ports vadj_test_1]
set_property  -dict {PACKAGE_PIN V7    IOSTANDARD LVCMOS18}  [get_ports vadj_test_2]


set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports tx1_strobe_in_p]
set_property UNAVAILABLE_DURING_CALIBRATION TRUE [get_ports tx2_idata_in_p]


#
#  Independent Tx clock from Rx,
#  Tx clock not routed through clock capable pins
#

#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_clk_in_ibuf/O]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_clk_in_ibuf/O]
#
#create_pblock pblock_1
#resize_pblock pblock_1 -add CLOCKREGION_X3Y2:CLOCKREGION_X3Y2
#
#add_cells_to_pblock pblock_1 [get_cells \
#  [list i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_div_clk_rbuf \
#        i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_clk_in_gbuf]]
#
#create_pblock pblock_2
#resize_pblock pblock_2 -add CLOCKREGION_X3Y3:CLOCKREGION_X3Y3
#
#add_cells_to_pblock pblock_2 [get_cells \
#  [list i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_div_clk_rbuf \
#        i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_clk_in_gbuf]]
#
#set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_1  [list \
#  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_clk_in_gbuf/O]] \
#  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_div_clk_rbuf/O]]]
#
#set_property USER_CLOCK_ROOT X3Y2 [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_1_phy/i_dac_div_clk_rbuf/O]]
#
#set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_2  [list \
#  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_clk_in_gbuf/O]] \
#  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_div_clk_rbuf/O]]]
#
#set_property USER_CLOCK_ROOT X3Y3 [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_tx_2_phy/i_dac_div_clk_rbuf/O]]


#
#  Common Tx and Rx clock, both use Rx clock
#

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_1  [list \
  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_1_phy/i_clk_buf/O]] \
  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_1_phy/i_div_clk_buf/O]]]

set_property USER_CLOCK_ROOT X3Y2 [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_1_phy/i_div_clk_buf/O]]

set_property CLOCK_DELAY_GROUP BALANCE_CLOCKS_2  [list \
  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_2_phy/i_clk_buf/O]] \
  [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_2_phy/i_div_clk_buf/O]]]

set_property USER_CLOCK_ROOT X3Y3 [get_nets -of [get_pins i_system_wrapper/system_i/axi_adrv9001/inst/i_if/i_rx_2_phy/i_div_clk_buf/O]]

