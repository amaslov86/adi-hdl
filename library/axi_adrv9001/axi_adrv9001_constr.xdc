#create_generated_clock -name adc_1_clk \
#  -source [get_ports rx1_dclk_in_p] \
#  -divide_by 8 [get_ports adc_1_clk]
#
#create_generated_clock -name adc_2_clk \
#  -source [get_ports rx2_dclk_in_p] \
#  -divide_by 8 [get_ports adc_2_clk]
#
#create_generated_clock -name dac_1_clk \
#  -source [get_ports tx1_dclk_in_p] \
#  -divide_by 8 [get_ports dac_1_clk]
#
#create_generated_clock -name dac_2_clk \
#  -source [get_ports tx2_dclk_in_p] \
#  -divide_by 8 [get_ports dac_2_clk]
#
set_false_path -from [get_cells -quiet -hier *in_toggle_d1_reg* -filter {NAME =~ *i_serdes* && IS_SEQUENTIAL}]
set_false_path -from [get_cells -quiet -hier *out_toggle_d1_reg* -filter {NAME =~ *i_serdes* && IS_SEQUENTIAL}]

set_false_path -through  [get_pins -hier *i_idelay/CNTVALUEOUT]
set_false_path -through  [get_pins -hier *i_idelay/CNTVALUEIN]
