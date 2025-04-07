class write_read_value_register_test extends base_test;

function new(virtual dut_if dut_vif);
	super.new(dut_vif);
endfunction

bit [7:0] wdata, rdata;
bit [7:0] addr;

virtual task run_scenario();
	wait (dut_vif.presetn === 1);
	addr = 8'h0;
	repeat(3) begin
		wdata = $urandom;
		write(addr, wdata);
		read(addr, rdata);
		case (addr)
			8'h0: begin
				if ({3'h0, wdata[4:0]} != rdata) begin
					$display("# %0t: Read register data mismatched with write data, register address = 0x%0h", $time, addr);
					test_err++;
				end
			end
			8'h2: begin 
				if (wdata != rdata) begin
					$display("# %0t: Read register data mismatched with write data, register address = 0x%0h", $time, addr);
					test_err++;
				end
			end
			8'h3: begin
				if ({6'h00, wdata[1:0]} != rdata) begin
					$display("# %0t: Read register data mismatched with write data, register address = 0x%0h", $time, addr);
					test_err++;
				end
			end
		endcase

		if (addr == 8'h0)
			addr = addr + 2;
		else
			addr = addr + 1;
	end
endtask

endclass
