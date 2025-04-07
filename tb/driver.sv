class driver;
virtual dut_if dut_vif;
mailbox #(packet) s2d_mb;
event xfer_done;

function new(virtual dut_if dut_vif, mailbox #(packet) s2d_mb);
	this.dut_vif = dut_vif;
	this.s2d_mb = s2d_mb;
endfunction

task run();
	packet pkt;
	dut_vif.pready = 1'b1;
	while (1) begin
		s2d_mb.get(pkt);
		$display("# %0t: [driver] Get packet from stimulus", $time);
		@(posedge dut_vif.pclk)
		dut_vif.paddr = pkt.paddr;
		dut_vif.psel = 1'b1;
		dut_vif.pwrite = (pkt.transfer == packet::WRITE) ? 1'b1 : 1'b0;
		dut_vif.pwdata = (pkt.transfer == packet::WRITE) ? pkt.pdata : 0;
		if (pkt.transfer == packet::WRITE)
			$display("# %0t: [driver] Write transfer, Drive DUT with address: 8'h%h, wdata: 8'h%h", $time, pkt.paddr, pkt.pdata);
		else
			$display("# %0t: [driver] Read transfer, Drive DUT with address: 8'h%h", $time, pkt.paddr);
		@(posedge dut_vif.pclk) 
		dut_vif.penable = 1;
		#1;
		pkt.pdata = (dut_vif.pwrite) ? pkt.pdata : dut_vif.prdata;
		@(posedge dut_vif.pclk)
		dut_vif.paddr = 0;
		dut_vif.psel = 0;
		dut_vif.pwrite = 0;
		dut_vif.pwdata = 0;
		dut_vif.penable = 0;
		$display("# %0t: [driver] Transfer done", $time);
		-> xfer_done;
	end
endtask

endclass


