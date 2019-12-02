
proc ad_data_offload_create {instance_name datapath_type mem_type mem_size source_dwidth destination_dwidth} {

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
    # Internal storage instance
    ###########################################################################

    ## Add the memory module source into the project file set
    ## NOTE: be aware of relative path
    if {[get_files -quiet "ad_mem_asym.v"] == ""} {
      add_files -norecurse -fileset sources_1 "../../../library/common/ad_mem_asym.v"
    }

    create_bd_cell -type module -reference ad_mem_asym internal_buffer
    set_property -dict [list \
      CONFIG.A_DATA_WIDTH $source_dwidth \
      CONFIG.A_ADDRESS_WIDTH $source_awidth \
      CONFIG.B_DATA_WIDTH $destination_dwidth \
      CONFIG.B_ADDRESS_WIDTH $destination_awidth \
    ] [get_bd_cells internal_buffer]

    ###########################################################################
    # Data offload instance
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

    #
    ## TODO: IF $mem_type == 0
    #

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

    ad_connect internal_buffer/clka i_data_offload/s_axis_aclk
    ad_connect internal_buffer/wea i_data_offload/fifo_src_wen
    ad_connect internal_buffer/addra i_data_offload/fifo_src_waddr
    ad_connect internal_buffer/dina i_data_offload/fifo_src_wdata
    ad_connect internal_buffer/clkb i_data_offload/m_axis_aclk
    ad_connect internal_buffer/reb i_data_offload/fifo_dst_ren
    ad_connect internal_buffer/addrb i_data_offload/fifo_dst_raddr
    ad_connect internal_buffer/doutb i_data_offload/fifo_dst_rdata

  current_bd_instance /

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
