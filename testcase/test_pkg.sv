package test_pkg;

  import timer_pkg::*;
  `include "base_test.sv"
  `include "default_value_register_test.sv"
  `include "write_read_value_register_test.sv"
  `include "reset_test.sv"
  `include "TSR_overflow_test.sv"
  `include "TSR_underflow_test.sv"
  `include "reserved_test.sv"
  `include "write_each_read_all_test.sv"
  `include "no_divide_test.sv"
  `include "divide_clk_two_test.sv"
  `include "divide_clk_four_test.sv"
  `include "divide_clk_eight_test.sv"
  `include "count_up_test.sv"
  `include "count_down_test.sv"
  `include "count_up_with_data_test.sv"
  `include "count_down_with_data_test.sv"
  `include "overflow_test.sv"
  `include "underflow_test.sv"
  `include "interrupt_overflow_test.sv"
  `include "interrupt_underflow_test.sv"
  `include "no_interrupt_overflow_test.sv"
  `include "no_interrupt_underflow_test.sv"
  

endpackage


