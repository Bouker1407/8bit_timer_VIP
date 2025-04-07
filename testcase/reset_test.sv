class reset_test extends base_test;

function new(virtual dut_if dut_vif);
	super.new(dut_vif);
endfunction

bit [7:0] wdata, rdata;
bit [7:0] addr;
virtual task run_scenario();
	wait(dut_vif.presetn === 1); 
	addr = 8'h0;
	repeat(4) begin
		wdata = $urandom;
		write(addr, wdata);
		addr++;
	end
	@(posedge dut_vif.pclk);
	dut_vif.presetn = 0;
	@(posedge dut_vif.pclk);
	dut_vif.presetn = 1;
	
	addr = 8'h0;
	repeat(4) begin
		read(addr, rdata);
		if (rdata != 8'h0) begin
			$display("# %0t: Data mismatched with default value in RTL spec", $time);
			$display("# %0t: Register's address which error occured 0x%0h", $time, addr);
			test_err++;
		end
		addr++;
	end
endtask

endclass

