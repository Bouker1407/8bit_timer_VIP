class write_each_read_all_test extends base_test;

function new(virtual dut_if dut_vif);
	super.new(dut_vif);
endfunction

bit [7:0] wdata, rdata;
bit [7:0] waddr, raddr;

bit [7:0] wdata_array [0:3];

virtual task run_scenario();
	wait (dut_vif.presetn === 1'b1);
	waddr = 8'h0;
	wdata_array = '{default: '0};
	repeat(4) begin
		wdata = $urandom;
		write(waddr, wdata);
		wdata_array[waddr] = wdata;
		raddr = 8'h0;
		repeat(4) begin
			read(raddr, rdata);
			case(raddr)
				8'h0: begin
					if (rdata != {3'h0, wdata_array[raddr][4:0]}) begin
						test_err++;	
						$display("# %0t: Read register data mismatched with write data, register address = 0x%0h, read data = 8'h%0h, write data = 8'h%0h", $time, raddr, rdata, wdata_array[raddr][4:0]);
					end
				end
				8'h2: begin
					if (rdata != wdata_array[raddr]) begin
						test_err++;
						$display("# %0t: Read register data mismatched with write data, register address = 0x%0h", $time, raddr);
					end
				end
				8'h3: begin
					if (rdata != {6'h00, wdata_array[raddr][1:0]}) begin
						test_err++;
						$display("# %0t: Read register data mismatched with write data, register address = 0x%0h", $time, raddr);
					end
				end
			endcase
			raddr++;
		end
		waddr++;
	end
endtask

endclass
