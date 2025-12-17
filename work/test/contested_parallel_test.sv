///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class contested_parallel_test extends base_test;

	`uvm_component_utils(contested_parallel_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", contested_parallel_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting full test",UVM_NONE)
	endtask : run_phase

endclass : contested_parallel_test


///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class contested_parallel_vsequence extends htax_base_vseq;

  `uvm_object_utils(contested_parallel_vsequence)

  rand int port;

  function new (string name = "contested_parallel_vsequence");
    super.new(name);
  endfunction : new

  task body();
		htax_packet_c pkt0, pkt1, pkt2, pkt3, pkt4, pkt5;
		
		
		//Contested Stress Test
        // RX Port 0 VC2 and TX Port Multiple
		`uvm_info(get_type_name(),"Starting contested test on RX Port 0 VC2",UVM_NONE)
		begin
        `uvm_do_on_with(pkt4, p_sequencer.htax_seqr[0], {dest_port == 0; delay == 1; length == 62;vc==2;})
        fork
            repeat(25) begin
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 0; delay == 1; length == 20;vc==2;})
            end
            repeat(25) begin
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 0; delay == 5; length == 40;vc==2;})
            end
            repeat(25) begin
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 0; delay == 10; length == 3;vc==2;})
            end
        join
		end

		// RX Port 0 VC3 and TX Port Multiple
		begin
        `uvm_info(get_type_name(),"Starting contested test on RX Port 0 VC3",UVM_NONE)
        `uvm_do_on_with(pkt4, p_sequencer.htax_seqr[0], {dest_port == 0; delay == 1; length == 62;vc==3;})
        fork
            repeat(25) begin
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 0; delay == 1; length == 20;vc==3;})
            end
            repeat(25) begin
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 0; delay == 5; length == 40;vc==3;})
            end
            repeat(25) begin
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 0; delay == 10; length == 3;vc==3;})
            end
        join
		end
        begin
        
        repeat(50) begin
        fork
            `uvm_do_on_with(pkt4, p_sequencer.htax_seqr[0], {dest_port == 0; delay == 10; length == 61;vc==1;})
            `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 1; delay == 20; length == 51;vc==1;})
            `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 2; delay == 10; length == 61;vc==1;})
            `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 3; delay == 10; length == 61;vc==1;})
        join end
		end
  endtask : body

endclass : contested_parallel_vsequence