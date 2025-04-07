class environment;
virtual dut_if dut_vif;

mailbox #(packet) 	s2d_mb;
mailbox #(packet)	m2s_mb;

stimulus	stim;
driver		drv;
monitor		mon;
scoreboard	sb;

function new(virtual dut_if dut_vif);
	this.dut_vif = dut_vif;
endfunction

function void  build();
	s2d_mb = new();
	m2s_mb = new();

	stim = new(s2d_mb);
	drv = new(dut_vif, s2d_mb);
	mon = new(dut_vif, m2s_mb);
	sb = new(m2s_mb);
	$display("# %0t: [environment] Built successfully", $time);
endfunction

task run();
	$display("# %0t: [environment] Run", $time);
	fork
		stim.run();
		drv.run();
		mon.run();
		sb.run();
	join
endtask

endclass
