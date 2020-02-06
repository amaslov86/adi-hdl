
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

# get_env_param retrieves parameter value from the environment if exists,
# other case use the default value

adi_project ad9081_fmca_ebz_vcu118 0 [list \
  JESD_MODE    [get_env_param JESD_MODE    64B66B ] \
  RX_RATE      [get_env_param RX_RATE      16.22016 ] \
  TX_RATE      [get_env_param TX_RATE      16.22016 ] \
  REF_CLK_RATE [get_env_param REF_CLK_RATE 245.76 ] \
  RX_JESD_M    [get_env_param RX_JESD_M    8 ] \
  RX_JESD_L    [get_env_param RX_JESD_L    8 ] \
  RX_JESD_S    [get_env_param RX_JESD_S    1 ] \
  RX_JESD_NP   [get_env_param RX_JESD_NP   16 ] \
  RX_NUM_LINKS [get_env_param RX_NUM_LINKS 1 ] \
  TX_JESD_M    [get_env_param TX_JESD_M    8 ] \
  TX_JESD_L    [get_env_param TX_JESD_L    8 ] \
  TX_JESD_S    [get_env_param TX_JESD_S    1 ] \
  TX_JESD_NP   [get_env_param TX_JESD_NP   16 ] \
  TX_NUM_LINKS [get_env_param TX_NUM_LINKS 1 ] \
]

adi_project_files ad9081_fmca_ebz_vcu118 [list \
  "system_top.v" \
  "system_constr.xdc"\
  "timing_constr.xdc"\
  "../../../library/common/ad_3w_spi.v"\
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/vcu118/vcu118_system_constr.xdc" ]


adi_project_run ad9081_fmca_ebz_vcu118

