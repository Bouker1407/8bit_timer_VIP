class TSR_overflow_test extends base_test;
virtual dut_if dut_vif;

function new (virtual dut_if dut_vif);
	super.new(dut_vif);
endfunction

bit[7:0] rdata;
time check_time;
virtual task run_scenario();
//	wait (dut_vif.presetn === 1);
	#100ns;
	write(8'h2, 8'd216);
	write(8'h0, 8'h4);
	
	$display("# %0t: Start counting", $time);
	write(8'h0, 8'h1);

	check_time = $time + 5*150*1000;
	while ($time < check_time) #1;

	$display("# %0t: Stop counting", $time);
	write(8'h0, 8'h0);

	read(8'h1, rdata);
	if (rdata != 8'h1) begin
		test_err++;
		$display("# %0t: Overflow error occured", $time);
	end

	write(8'h1, 8'h0);
	read(8'h1, rdata);
	if (rdata != 8'h1) begin
		test_err++;
		$display("# %0t: TSR write transfer error occured, value did not keep after write", $time);
	end
	write(8'h1, 8'h1);
	read(8'h1, rdata);
	if (rdata != 8'h0) begin
		test_err++;
		$display("# %0t: TSR write transfer error occured, value did not clear after write", $time);
	end
endtask

endclass



