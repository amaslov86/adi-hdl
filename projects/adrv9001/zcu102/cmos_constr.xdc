set_property  -dict {PACKAGE_PIN Y3    IOSTANDARD LVCMOS18  }  [get_ports rx1_dclk_out_n]
set_property  -dict {PACKAGE_PIN Y4    IOSTANDARD LVCMOS18  }  [get_ports rx1_dclk_out_p]
set_property  -dict {PACKAGE_PIN Y1    IOSTANDARD LVCMOS18  }  [get_ports rx1_idata_out_n]
set_property  -dict {PACKAGE_PIN Y2    IOSTANDARD LVCMOS18  }  [get_ports rx1_idata_out_p]
set_property  -dict {PACKAGE_PIN AA1   IOSTANDARD LVCMOS18  }  [get_ports rx1_qdata_out_n]
set_property  -dict {PACKAGE_PIN AA2   IOSTANDARD LVCMOS18  }  [get_ports rx1_qdata_out_p]
set_property  -dict {PACKAGE_PIN V1    IOSTANDARD LVCMOS18  }  [get_ports rx1_strobe_out_n]
set_property  -dict {PACKAGE_PIN V2    IOSTANDARD LVCMOS18  }  [get_ports rx1_strobe_out_p]

set_property  -dict {PACKAGE_PIN N11   IOSTANDARD LVCMOS18  }  [get_ports rx2_dclk_out_n]
set_property  -dict {PACKAGE_PIN P11   IOSTANDARD LVCMOS18  }  [get_ports rx2_dclk_out_p]
set_property  -dict {PACKAGE_PIN M13   IOSTANDARD LVCMOS18  }  [get_ports rx2_idata_out_n]
set_property  -dict {PACKAGE_PIN N13   IOSTANDARD LVCMOS18  }  [get_ports rx2_idata_out_p]
set_property  -dict {PACKAGE_PIN K13   IOSTANDARD LVCMOS18  }  [get_ports rx2_qdata_out_n]
set_property  -dict {PACKAGE_PIN L13   IOSTANDARD LVCMOS18  }  [get_ports rx2_qdata_out_p]
set_property  -dict {PACKAGE_PIN N12   IOSTANDARD LVCMOS18  }  [get_ports rx2_strobe_out_n]
set_property  -dict {PACKAGE_PIN P12   IOSTANDARD LVCMOS18  }  [get_ports rx2_strobe_out_p]


set_property  -dict {PACKAGE_PIN U4    IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_in_n]
set_property  -dict {PACKAGE_PIN U5    IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_in_p]
set_property  -dict {PACKAGE_PIN AC4   IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_out_n]
set_property  -dict {PACKAGE_PIN AB4   IOSTANDARD LVCMOS18  }  [get_ports tx1_dclk_out_p]
set_property  -dict {PACKAGE_PIN V3    IOSTANDARD LVCMOS18  }  [get_ports tx1_idata_in_n]
set_property  -dict {PACKAGE_PIN V4    IOSTANDARD LVCMOS18  }  [get_ports tx1_idata_in_p]
set_property  -dict {PACKAGE_PIN AC3   IOSTANDARD LVCMOS18  }  [get_ports tx1_qdata_in_n]
set_property  -dict {PACKAGE_PIN AB3   IOSTANDARD LVCMOS18  }  [get_ports tx1_qdata_in_p]
set_property  -dict {PACKAGE_PIN AC1   IOSTANDARD LVCMOS18  }  [get_ports tx1_strobe_in_n]
set_property  -dict {PACKAGE_PIN AC2   IOSTANDARD LVCMOS18  }  [get_ports tx1_strobe_in_p]

set_property  -dict {PACKAGE_PIN M14   IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_in_n]
set_property  -dict {PACKAGE_PIN M15   IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_in_p]
set_property  -dict {PACKAGE_PIN N8    IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_out_n]
set_property  -dict {PACKAGE_PIN N9    IOSTANDARD LVCMOS18  }  [get_ports tx2_dclk_out_p]
set_property  -dict {PACKAGE_PIN K16   IOSTANDARD LVCMOS18  }  [get_ports tx2_idata_in_n]
set_property  -dict {PACKAGE_PIN L16   IOSTANDARD LVCMOS18  }  [get_ports tx2_idata_in_p]
set_property  -dict {PACKAGE_PIN L11   IOSTANDARD LVCMOS18  }  [get_ports tx2_qdata_in_n]
set_property  -dict {PACKAGE_PIN M11   IOSTANDARD LVCMOS18  }  [get_ports tx2_qdata_in_p]
set_property  -dict {PACKAGE_PIN K12   IOSTANDARD LVCMOS18  }  [get_ports tx2_strobe_in_n]
set_property  -dict {PACKAGE_PIN L12   IOSTANDARD LVCMOS18  }  [get_ports tx2_strobe_in_p]


# clocks

create_clock -name ref_clk        -period  25.00 [get_ports fpga_ref_clk_p]

create_clock -name rx1_dclk_out   -period  12.5 [get_ports rx1_dclk_out_p]
create_clock -name rx2_dclk_out   -period  12.5 [get_ports rx2_dclk_out_p]
create_clock -name tx1_dclk_out   -period  12.5 [get_ports tx1_dclk_out_p]
create_clock -name tx2_dclk_out   -period  12.5 [get_ports tx2_dclk_out_p]

set_clock_latency -source -early 2 [get_clocks rx1_dclk_out]
set_clock_latency -source -early 2 [get_clocks rx2_dclk_out]

set_clock_latency -source -late 5 [get_clocks rx1_dclk_out]
set_clock_latency -source -late 5 [get_clocks rx2_dclk_out]
