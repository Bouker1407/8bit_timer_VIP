class reserved_test extends base_test;
	
function new(virtual dut_if dut_vif);
	super.new(dut_vif);	
endfunction

bit [7:0] wdata, rdata;
bit [7:0] addr;

task run_scenario();
	wait(dut_vif.presetn === 1);
	std::randomize(addr, wdata) with {addr > 8'h03; addr <= 8'hFF;};
	write(addr, wdata);
	addr = 8'h0;
	repeat(4) begin
		read(addr, rdata);
		if (rdata != 8'h0) begin
			$display("# %0t: Data mismatched with default value in RTL spec", $time);
			$display("# %0t: Register's address which error occured 0x%0h", $time, addr);
			test_err++;
		end
		addr = addr + 8'h1;
	end
endtask
endclass
