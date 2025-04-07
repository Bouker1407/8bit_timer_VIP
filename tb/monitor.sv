class monitor;
virtual dut_if dut_vif;
mailbox #(packet) m2s_mb;

function new(virtual dut_if dut_vif, mailbox #(packet) m2s_mb);
	this.dut_vif = dut_vif;
	this.m2s_mb = m2s_mb;
endfunction

task run();
	packet pkt;
	while(1) begin
		pkt = new();
		@(posedge dut_vif.penable)
		$display("# %0t: [monitor] Capture APB transaction and send to mailbox", $time);
		#1
		pkt.paddr = dut_vif.paddr;
		pkt.pdata = (dut_vif.pwrite) ? dut_vif.pwdata : dut_vif.prdata;
		pkt.transfer = (dut_vif.pwrite) ? packet::WRITE : packet::READ;
		m2s_mb.put(pkt);
		end
endtask

endclass
