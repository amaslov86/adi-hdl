
proc ad_data_offload_create {instance_name datapath_type mem_type mem_size source_dwidth destination_dwidth {ddr_data_width 0} {ddr_addr_width 0}} {

  global ad_hdl_dir
  global sys_cpu_resetn

  create_bd_cell -type hier $instance_name
  current_bd_instance /$instance_name

    ###########################################################################
    ## Sub-system's ports and interface definitions
    ###########################################################################

    create_bd_pin -dir I -type clk s_axi_aclk
    create_bd_pin -dir I -type rst s_axi_aresetn
    create_bd_pin -dir I -type clk s_axis_aclk
    create_bd_pin -dir I -type rst s_axis_aresetn
    create_bd_pin -dir I -type clk m_axis_aclk
    create_bd_pin -dir I -type rst m_axis_aresetn

    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 s_axi
    create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 s_axis
    create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:axis_rtl:1.0 m_axis

    create_bd_pin -dir I init_req
    create_bd_pin -dir O init_ack
    create_bd_pin -dir I sync_ext

    set source_max_address [expr ($mem_size * 8) / $source_dwidth]
    set source_awidth [log2 $source_max_address]
    set destination_max_address [expr ($mem_size * 8) / $destination_dwidth]
    set destination_awidth [log2 $destination_max_address]

    ###########################################################################
    # Data offload controller instance
    ###########################################################################

    ad_ip_instance data_offload i_data_offload [list \
      MEM_TYPE $mem_type \
      MEM_SIZE $mem_size \
      TX_OR_RXN_PATH $datapath_type \
      SRC_DATA_WIDTH $source_dwidth \
      SRC_ADDR_WIDTH $source_awidth \
      DST_DATA_WIDTH $destination_dwidth \
      DST_ADDR_WIDTH $destination_awidth \
    ]

    if {$mem_type == 0} {
      ###########################################################################
      # Internal storage instance (BRAMs)
      ###########################################################################

      ## Add the memory module source into the project file set
      ## NOTE: be aware of relative path
      if {[get_files -quiet "ad_mem_asym.v"] == ""} {
        add_files -norecurse -fileset sources_1 "../../../library/common/ad_mem_asym.v"
      }

      create_bd_cell -type module -reference ad_mem_asym storage_unit
      set_property -dict [list \
        CONFIG.A_DATA_WIDTH $source_dwidth \
        CONFIG.A_ADDRESS_WIDTH $source_awidth \
        CONFIG.B_DATA_WIDTH $destination_dwidth \
        CONFIG.B_ADDRESS_WIDTH $destination_awidth \
      ] [get_bd_cells storage_unit]

      ad_connect storage_unit/clka i_data_offload/s_axis_aclk
      ad_connect storage_unit/wea i_data_offload/fifo_src_wen
      ad_connect storage_unit/addra i_data_offload/fifo_src_waddr
      ad_connect storage_unit/dina i_data_offload/fifo_src_wdata
      ad_connect storage_unit/clkb i_data_offload/m_axis_aclk
      ad_connect storage_unit/reb i_data_offload/fifo_dst_ren
      ad_connect storage_unit/addrb i_data_offload/fifo_dst_raddr
      ad_connect storage_unit/doutb i_data_offload/fifo_dst_rdata

    } elseif {$mem_type == 1} {
      ###########################################################################
      # External DDR4 storage instance
      ###########################################################################

      ad_ip_instance util_fifo2axi_bridge fifo2axi_bridge [list \
        SRC_DATA_WIDTH $source_dwidth \
        SRC_ADDR_WIDTH $source_awidth \
        DST_DATA_WIDTH $destination_dwidth \
        DST_ADDR_WIDTH $destination_awidth \
        AXI_DATA_WIDTH $ddr_data_width \
        AXI_ADDR_WIDTH $ddr_addr_width \
        AXI_ADDRESS 0x00000000 \
        AXI_ADDRESS_LIMIT 0xffffffff \
      ]

      ## NOTE: TODO this instance is carrier specific, find a way to be more generic
      ad_ip_instance proc_sys_reset axi_rstgen
      ad_ip_instance mig_7series axi_ddr_cntrl
      file copy -force $ad_hdl_dir/projects/common/zc706/zc706_plddr3_mig.prj [get_property IP_DIR \
        [get_ips [get_property CONFIG.Component_Name [get_bd_cells axi_ddr_cntrl]]]]
      ad_ip_parameter axi_ddr_cntrl CONFIG.XML_INPUT_FILE zc706_plddr3_mig.prj

      ad_connect fifo2axi_bridge/fifo_src_clk i_data_offload/s_axis_aclk
      ad_connect fifo2axi_bridge/fifo_src_resetn i_data_offload/fifo_src_resetn
      ad_connect fifo2axi_bridge/fifo_src_wen i_data_offload/fifo_src_wen
      ad_connect fifo2axi_bridge/fifo_src_waddr i_data_offload/fifo_src_waddr
      ad_connect fifo2axi_bridge/fifo_src_wdata i_data_offload/fifo_src_wdata
      ad_connect fifo2axi_bridge/fifo_src_wlast i_data_offload/fifo_src_wlast

      ad_connect fifo2axi_bridge/fifo_dst_clk i_data_offload/m_axis_aclk
      ad_connect fifo2axi_bridge/fifo_dst_resetn i_data_offload/fifo_dst_resetn
      ad_connect fifo2axi_bridge/fifo_dst_ren i_data_offload/fifo_dst_ren
      ad_connect fifo2axi_bridge/fifo_dst_raddr i_data_offload/fifo_dst_raddr
      ad_connect fifo2axi_bridge/fifo_dst_rdata i_data_offload/fifo_dst_rdata
      ad_connect fifo2axi_bridge/fifo_dst_rlast i_data_offload/fifo_dst_rlast

      ad_connect axi_ddr_cntrl/ui_clk axi_rstgen/slowest_sync_clk
      ad_connect axi_ddr_cntrl/ui_clk fifo2axi_bridge/axi_clk
      ad_connect axi_ddr_cntrl/S_AXI fifo2axi_bridge/ddr_axi
      ad_connect axi_rstgen/peripheral_aresetn fifo2axi_bridge/axi_resetn
      ad_connect axi_rstgen/peripheral_aresetn axi_ddr_cntrl/aresetn

      assign_bd_address [get_bd_addr_segs -of_objects [get_bd_cells axi_ddr_cntrl]]

    }

    ###########################################################################
    # Internal connections
    ###########################################################################

    ad_connect s_axi_aclk i_data_offload/s_axi_aclk
    ad_connect s_axi_aresetn i_data_offload/s_axi_aresetn
    ad_connect s_axis_aclk i_data_offload/s_axis_aclk
    ad_connect s_axis_aresetn i_data_offload/s_axis_aresetn
    ad_connect m_axis_aclk i_data_offload/m_axis_aclk
    ad_connect m_axis_aresetn i_data_offload/m_axis_aresetn

    ad_connect s_axi i_data_offload/s_axi
    ad_connect s_axis i_data_offload/s_axis
    ad_connect m_axis i_data_offload/m_axis

    ad_connect init_req i_data_offload/init_req
    ad_connect init_ack i_data_offload/init_ack
    ad_connect sync_ext i_data_offload/sync_ext

  current_bd_instance /

  if {$mem_type == 1} {

    # PL-DDR data offload interfaces
    create_bd_port -dir I -type rst sys_rst
    create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 ddr3
    create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 sys_clk

    ad_connect  sys_rst $instance_name/axi_ddr_cntrl/sys_rst
    ad_connect  sys_clk $instance_name/axi_ddr_cntrl/SYS_CLK
    ad_connect  ddr3 $instance_name/axi_ddr_cntrl/DDR3
    ## TODO: $sys_cpu_resetn does not work in this context
    ad_connect  sys_rstgen/peripheral_aresetn $instance_name/axi_rstgen/ext_reset_in

  }
}

proc log2 {x} {
  if {$x <= 0} {error "log2 requires a positive argument"}
  if {$x < 2} {
    return $x
  } else {
    for {set i 0} {$x > 0} {incr i} {
      set x [expr $x >> 1]
    }
    return $i
  }
}
