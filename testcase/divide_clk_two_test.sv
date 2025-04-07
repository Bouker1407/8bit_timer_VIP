class divide_clk_two_test extends base_test;

function new(virtual dut_if dut_vif);
	super.new(dut_vif);
endfunction

bit [7:0] rdata;

time check_time;
task run_scenario();
	wait(dut_vif.presetn === 1)
	write(8'h00, 8'h08);

	$display("# %0t: Start counting up", $time);
	write(8'h00, 8'h09);

	check_time = 10*256*1000 + $time;
	while($time < check_time) #1;
	
	$display("# %0t: Stop counting", $time);
	write(8'h00, 8'h08);

	read(8'h1, rdata);
        if (rdata != 8'h1) begin
		test_err++;
		$display("# %0t: Counter did not count up correctly with ker_clk divided by clock divisor mode", $time);
	end	
	write(8'h01, 8'h01);
	
	$display("# %0t: Start counting down", $time);
	write(8'h00, 8'h0b);

	check_time = 10*150*1000 + $time;
	while($time < check_time) #1;
	
	$display("# %0t: Stop counting", $time);
	write(8'h00, 8'ha);

	read(8'h1, rdata);
	if (rdata != 8'h2) begin
		test_err++;
		$display("# %0t: Counter did not count down expectably after counting up", $time);
	end
endtask

endclass 



