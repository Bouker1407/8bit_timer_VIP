packet apb_trans;
covergroup APB_GROUP;
	apb_transfer: coverpoint apb_trans.transfer {
		bins READ = {packet::READ};
		bins WRITE = {packet::WRITE};
	}
	apb_address: coverpoint apb_trans.paddr {
		bins TCR_addr = {8'h0};
		bins TSR_addr = {8'h1};
		bins TDR_addr = {8'h2};
		bins TIE_addr = {8'h3};
		bins reserved_region = default;
	}
	apb_TCR_clk_div: coverpoint apb_trans.pdata[7:3] {
		bins no_divide = {5'b00000};
		bins divide_2 = {5'b00001};
		bins divide_4 = {5'b00010};
		bins divide_8 = {5'b00011};
	}
	apb_TCR_load: coverpoint apb_trans.pdata[2] {
		bins load_enable = {1'b1};
		bins load_disable = {1'b0};
	}
	apb_TCR_counter_mode: coverpoint apb_trans.pdata[1] {
		bins count_up = {1'b0};
		bins count_down = {1'b1};
	}
	apb_TCR_timer: coverpoint apb_trans.pdata[0] {
		bins timer_not_count = {1'b0};
		bins timer_start_count = {1'b1};
	}
	apb_TSR: coverpoint apb_trans.pdata {
		bins underflow = {8'h2};
		bins overflow = {8'h1};
	}
	apb_TIE: coverpoint apb_trans.pdata {
		bins underflow_en = {8'h2};
		bins overflow_en = {8'h1};
	}
	no_clock_divide_feature: cross apb_transfer, apb_address, apb_TCR_clk_div, apb_TCR_load, apb_TCR_counter_mode, apb_TCR_timer {
		ignore_bins no_clk_div = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TCR_addr) || !binsof(apb_TCR_clk_div.no_divide) || !binsof(apb_TCR_load) intersect {1'b1,1'b0} || !binsof(apb_TCR_counter_mode) intersect{1'b0,1'b1} || !binsof(apb_TCR_timer) intersect {1'b0,1'b1};
	}
	clock_divide_2_feature: cross apb_transfer, apb_address, apb_TCR_clk_div, apb_TCR_load, apb_TCR_counter_mode, apb_TCR_timer {
		ignore_bins clk_div_2 = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TCR_addr) || !binsof(apb_TCR_clk_div.divide_2) || !binsof(apb_TCR_load) intersect {1'b1,1'b0} || !binsof(apb_TCR_counter_mode) intersect{1'b0,1'b1} || !binsof(apb_TCR_timer) intersect {1'b0,1'b1};
	}
	clock_divide_4_feature: cross apb_transfer, apb_address, apb_TCR_clk_div, apb_TCR_load, apb_TCR_counter_mode, apb_TCR_timer {
		ignore_bins clk_div_4 = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TCR_addr) || !binsof(apb_TCR_clk_div.divide_4) || !binsof(apb_TCR_load) intersect {1'b1,1'b0} || !binsof(apb_TCR_counter_mode) intersect{1'b0,1'b1} || !binsof(apb_TCR_timer) intersect {1'b0,1'b1};
	}
	clock_divide_8_feature: cross apb_transfer, apb_address, apb_TCR_clk_div, apb_TCR_load, apb_TCR_counter_mode, apb_TCR_timer {
		ignore_bins clk_div_8 = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TCR_addr) || !binsof(apb_TCR_clk_div.divide_8) || !binsof(apb_TCR_load) intersect {1'b1,1'b0} || !binsof(apb_TCR_counter_mode) intersect{1'b0,1'b1} || !binsof(apb_TCR_timer) intersect {1'b0,1'b1};
	}
	count_up_feature: cross apb_transfer, apb_address, apb_TCR_clk_div, apb_TCR_load, apb_TCR_counter_mode, apb_TCR_timer {
		ignore_bins c_u = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TCR_addr) || !binsof(apb_TCR_clk_div) intersect{[0:3]} || !binsof(apb_TCR_load) intersect{[0:1]} || !binsof(apb_TCR_counter_mode.count_up) || !binsof(apb_TCR_timer) intersect {[0:1]};
	}
	count_down_feature: cross apb_transfer, apb_address, apb_TCR_clk_div, apb_TCR_load, apb_TCR_counter_mode, apb_TCR_timer {
		ignore_bins c_d = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TCR_addr) || !binsof(apb_TCR_clk_div) intersect{[0:3]} || !binsof(apb_TCR_load) intersect{[0:1]} || !binsof(apb_TCR_counter_mode.count_down) || !binsof(apb_TCR_timer) intersect {[0:1]};
	}
	count_with_data_feature: cross apb_transfer, apb_address {
		ignore_bins c_data = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TDR_addr);
	}
	overflow_feature: cross apb_transfer, apb_address, apb_TSR {
		ignore_bins ovfl = !binsof(apb_transfer.READ) || !binsof(apb_address.TSR_addr) || !binsof(apb_TSR.overflow);
	}
	underflow_feature: cross apb_transfer, apb_address, apb_TSR {
		ignore_bins udfl = !binsof(apb_transfer.READ) || !binsof(apb_address.TSR_addr) || !binsof(apb_TSR.underflow);
	}
	overflow_interrupt: cross apb_transfer, apb_address, apb_TIE {
		ignore_bins ovfl_intr = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TIE_addr) || !binsof(apb_TIE.overflow_en);
	}
	underflow_interupt: cross apb_transfer, apb_address, apb_TIE {
		ignore_bins udfl_intr = !binsof(apb_transfer.WRITE) || !binsof(apb_address.TIE_addr) || !binsof(apb_TIE.underflow_en);
	}
endgroup


