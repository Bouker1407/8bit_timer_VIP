`timescale 1ns / 1ps
module testbench; 
  import timer_pkg::*;
  import test_pkg::*;
 
  dut_if d_if();

  timer_top u_dut(
    .ker_clk(d_if.ker_clk),       
    .pclk(d_if.pclk),       
    .presetn(d_if.presetn),    
    .psel(d_if.psel),       
    .penable(d_if.penable),    
    .pwrite(d_if.pwrite),     
    .paddr(d_if.paddr),      
    .pwdata(d_if.pwdata),     
    .prdata(d_if.prdata),     
    .pready(d_if.pready),     
    .interrupt(d_if.interrupt));

  initial begin
    d_if.presetn = 0;
    #100ns;
    d_if.presetn = 1;
  end

  // 50 MHz
  initial begin
    d_if.pclk = 0;
    forever begin 
      #10ns;
      d_if.pclk = ~d_if.pclk;
    end
  end
 
  // 200 MHz
  initial begin
    d_if.ker_clk = 1;
    forever begin 
      #2.5ns;
      d_if.ker_clk = ~d_if.ker_clk;
    end
  end

  initial begin
    #1ms;
    $display("[testbench] Time out....Seems your tb is hang!");
    $finish;
  end
 
  base_test 					base = new(d_if);
  default_value_register_test 			read_def = new(d_if);
  write_read_value_register_test 		wr_test = new(d_if);
  reset_test 					rs_test = new(d_if);
  TSR_overflow_test 				TSR_ovfl = new(d_if);
  TSR_underflow_test 				TSR_udfl = new(d_if);
 reserved_test					rsv_test = new(d_if);
 write_each_read_all_test			werat = new(d_if);
 no_divide_test					no_div = new(d_if);
 divide_clk_two_test				div_2 = new(d_if);
 divide_clk_four_test				div_4 = new(d_if);
 divide_clk_eight_test				div_8 = new(d_if);
 count_up_test					cu = new(d_if);
 count_down_test				cd = new(d_if);
 count_up_with_data_test			cud = new(d_if);
 count_down_with_data_test			cdd = new(d_if);	
 overflow_test					ovfl = new(d_if);	
 underflow_test					udfl = new(d_if);
 interrupt_overflow_test			i_ovfl = new(d_if);
 interrupt_underflow_test			i_udfl = new(d_if);
 no_interrupt_overflow_test			no_i_ovfl = new(d_if);
 no_interrupt_underflow_test			no_i_udfl = new(d_if);


  initial begin
	if ($test$plusargs("default_value_register_test"))
		base = read_def;
	else if ($test$plusargs("write_read_value_register_test"))
		base = wr_test;
	else if($test$plusargs("reset_test"))
		base = rs_test;
	else if($test$plusargs("TSR_overflow_test"))
		base = TSR_ovfl;
	else if($test$plusargs("TSR_underflow_test"))
		base = TSR_udfl;
	else if($test$plusargs("reserved_test"))
		base = rsv_test;
	else if($test$plusargs("write_each_read_all_test"))
		base = werat;
	else if($test$plusargs("no_divide_test"))
		base = no_div;
	else if($test$plusargs("divide_clk_two_test"))
		base = div_2;
	else if($test$plusargs("divide_clk_four_test"))
		base = div_4;
	else if($test$plusargs("divide_clk_eight_test"))
		base = div_8;
	else if($test$plusargs("count_up_test"))
		base = cu;
	else if($test$plusargs("count_down_test"))
		base = cd;
	else if($test$plusargs("count_up_with_data_test"))
		base = cud;
	else if($test$plusargs("count_down_with_data_test"))
		base = cdd;
	else if($test$plusargs("overflow_test"))
		base = ovfl;
	else if($test$plusargs("underflow_test"))
		base = udfl;
	else if($test$plusargs("interrupt_overflow_test"))
		base = i_ovfl;
	else if($test$plusargs("interrupt_underflow_test"))
		base = i_udfl;
	else if($test$plusargs("no_interrupt_overflow_test"))
		base = no_i_ovfl;
	else if($test$plusargs("no_interrupt_unuderflow_test"))
		base = no_i_udfl;

	base.run_test();
  end

    
endmodule
