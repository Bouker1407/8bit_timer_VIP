class no_interrupt_underflow_test extends base_test;

function new(virtual dut_if dut_vif);
	super.new(dut_vif);
endfunction

bit [1:0] clk_div_mode;
bit [7:0] wdata, rdata;
time check_time;
int clk_mul;
virtual task run_scenario();
	wait(dut_vif.presetn === 1);

	wdata = $urandom;
	write(8'h02, wdata);

	clk_div_mode = $urandom;
	case(clk_div_mode)
		2'h0: clk_mul = 5;
		2'h1: clk_mul = 10;
		2'h2: clk_mul = 20;
		2'h3: clk_mul = 40;
	endcase

	write(8'h00, {3'h0, clk_div_mode, 3'h6});

	$display("# %0t: Start counting", $time);
	write(8'h00, {3'h0, clk_div_mode, 3'h3});

	check_time = $time + clk_mul*wdata*1000;
	while($time < check_time) #1;
	
	$display("# %0t: Stop counting", $time);
	write(8'h00, {3'h0, clk_div_mode, 3'h2});

	read(8'h1, rdata);
	if (rdata != 8'h2) begin
		test_err++;
		$display("# %0t: Underflow error occured", $time);		
	end
	@(posedge dut_vif.pclk);
	if (dut_vif.interrupt) begin
		test_err++;
		$display("# %0t: Interrupt signal triggered unexpectedly", $time);
	end
endtask

endclass

