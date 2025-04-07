class base_test;
virtual dut_if dut_vif;
environment envi;
int test_err;

function new(virtual dut_if dut_vif);
	this.dut_vif = dut_vif;
	this.test_err = 0;
endfunction

function void build();
	envi = new(dut_vif);
	envi.build();
endfunction

task read(bit [7:0] addr, ref bit [7:0] data);
	packet pkt = new();
	pkt.paddr = addr;
	pkt.transfer = packet::READ;
	envi.stim.send_pkt(pkt);
	@(envi.drv.xfer_done);
	data = pkt.pdata;
endtask

task write(bit [7:0] addr, bit [7:0] data);
	packet pkt = new();
	pkt.paddr = addr;
	pkt.transfer = packet::WRITE;
	pkt.pdata = data;
	envi.stim.send_pkt(pkt);
	@(envi.drv.xfer_done);
endtask

virtual task run_scenario();
endtask;

task run_test();
	build();
	fork
		envi.run();
		run_scenario();
	join_any
	#30us;
	envi.sb.report(test_err);
	$display("# %0t: [base_test] End simulation", $time);
	$finish;
endtask

endclass

