class scoreboard;
mailbox #(packet) m2s_mb;
int error;

`include "coverage.sv"

function new(mailbox #(packet) m2s_mb);
	this.m2s_mb = m2s_mb;
	this.APB_GROUP = new();
	this.error = 0;
endfunction

task run();
	packet pkt;
	while(1) begin
		m2s_mb.get(pkt);
		$display("# %0t: [scoreboard] Get packet from mailbox", $time);
		sample_apb_fc(pkt);
	end
endtask

function void sample_apb_fc(packet pkt);
	$cast(apb_trans, pkt);
	APB_GROUP.sample();
endfunction

function void report(int test_err);
	int total_err = error + test_err;
	if (total_err) begin
		$display("# %0t: [scoreboard] status: TEST FAILED", $time);
		$display("# %0t: [scoreboard] Total error is %0d", $time, total_err);
	end
	else
		$display("# %0t: [scoreboard] status: TEST PASSED", $time);
endfunction

endclass
