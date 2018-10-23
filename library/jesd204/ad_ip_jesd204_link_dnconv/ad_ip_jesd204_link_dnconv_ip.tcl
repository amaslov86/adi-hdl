# ***************************************************************************
# ***************************************************************************
# Copyright 2018 (c) Analog Devices, Inc. All rights reserved.
#
# Each core or library found in this collection may have its own licensing terms.
# The user should keep this in in mind while exploring these cores.
#
# Redistribution and use in source and binary forms,
# with or without modification of this file, are permitted under the terms of either
#  (at the option of the user):
#
#   1. The GNU General Public License version 2 as published by the
#      Free Software Foundation, which can be found in the top level directory, or at:
# https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
#
# OR
#
#   2.  An ADI specific BSD license as noted in the top level directory, or on-line at:
# https://github.com/analogdevicesinc/hdl/blob/dev/LICENSE
#
# ***************************************************************************
# ***************************************************************************

source ../../scripts/adi_env.tcl
source $ad_hdl_dir/library/scripts/adi_ip.tcl

adi_ip_create ad_ip_jesd204_link_dnconv
adi_ip_files ad_ip_jesd204_link_dnconv [list \
  "ad_ip_jesd204_link_dnconv.v" ]

adi_ip_properties_lite ad_ip_jesd204_link_dnconv

ipx::infer_bus_interface in_link_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]
ipx::infer_bus_interface out_link_clk xilinx.com:signal:clock_rtl:1.0 [ipx::current_core]

adi_add_bus "out_link" "master" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list \
    {"out_link_ready" "TREADY"} \
    {"out_link_valid" "TVALID"} \
    {"out_link_data" "TDATA"} \
  ]
adi_add_bus_clock "out_link_clk" "out_link"

adi_add_bus "in_link" "slave" \
  "xilinx.com:interface:axis_rtl:1.0" \
  "xilinx.com:interface:axis:1.0" \
  [list \
    {"in_link_ready" "TREADY"} \
    {"in_link_valid" "TVALID"} \
    {"in_link_data" "TDATA"} \
  ]
adi_add_bus_clock "in_link_clk" "in_link"


ipx::create_xgui_files [ipx::current_core]
ipx::save_core [ipx::current_core]
