///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class stress_test extends base_test;

	`uvm_component_utils(stress_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", stress_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting Stress test",UVM_NONE)
	endtask : run_phase

endclass : stress_test

///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class stress_vsequence extends htax_base_vseq;

  `uvm_object_utils(stress_vsequence)

  rand int port;

  function new (string name = "stress_vsequence");
    super.new(name);
  endfunction : new

  task body();
		htax_packet_c pkt0, pkt1, pkt2, pkt3,pkt4;
        repeat (1000) begin
            fork
                `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {pkt0.delay == 4; pkt0.length == 6;pkt0.vc==1;pkt0.dest_port==0;})
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {pkt1.delay == 4; pkt1.length == 6;pkt1.vc==1;pkt1.dest_port==1;})
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], { pkt2.delay == 4; pkt2.length == 6;pkt2.vc==1;pkt2.dest_port==2;})
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {pkt3.delay == 4; pkt3.length == 6;pkt3.vc==1;pkt3.dest_port==3;})
                join
        end
        repeat(250) begin
		    fork
            // Stress test TX port 0
            `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {pkt0.dest_port == 0; pkt0.delay == 20; pkt0.length == 5; pkt0.vc==1;})
            `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {pkt1.dest_port == 1; pkt1.delay == 20; pkt1.length == 5; pkt1.vc==1;})
            `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {pkt2.dest_port == 2; pkt2.delay == 20; pkt2.length == 5; pkt2.vc==1;})
            `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {pkt3.dest_port == 3; pkt3.delay == 20; pkt3.length == 5; pkt3.vc==1;})
        join
        end
        // Sequential traffic on each port to different destinations
        repeat(250) begin
            `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 0; delay == 1; length == 3;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 1; delay == 9; length == 20;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 2; delay == 15; length == 40;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 3; delay == 20; length == 62;})
        end
        
        repeat(250) begin
            `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 0; delay == 1; length == 3;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 1; delay == 9; length == 20;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 2; delay == 15; length == 40;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 3; delay == 20; length == 62;})
        end
        
        repeat(250) begin
            `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 0; delay == 1; length == 3;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 1; delay == 9; length == 20;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 2; delay == 15; length == 40;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 3; delay == 20; length == 62;})
        end
        
        repeat(250) begin
            `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 0; delay == 1; length == 3;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 1; delay == 9; length == 20;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 2; delay == 15; length == 40;})
        end
        repeat(250) begin
            `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 3; delay == 20; length == 62;})
        end

        fork
            // Stress test RX on port 0 vc 0
            repeat(250) begin
                `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 0; delay == 1; length == 3;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 0; delay == 9; length == 20;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 0; delay == 15; length == 40;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 0; delay == 20; length == 62;})
            end
        join
        fork
            // Stress test RX on port 1 vc 0
            repeat(250) begin
                `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 1; delay == 1; length == 3;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 1; delay == 9; length == 20;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 1; delay == 15; length == 40;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 1; delay == 20; length == 62;})
            end
        join
        fork
            // Stress test RX on port 2 vc 0
            repeat(250) begin
                `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 2; delay == 1; length == 3;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 2; delay == 9; length == 20;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 2; delay == 15; length == 40;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 2; delay == 20; length == 62;})
            end
        join
        fork
            // Stress test RX on port 0 vc 1
            repeat(250) begin
                `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 0; delay == 1; length == 3;vc==1;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 0; delay == 9; length == 20;vc==1;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 0; delay == 15; length == 40;vc==1;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 0; delay == 20; length == 62;vc==1;})
            end
        join

        fork
            // Stress test RX on port 2 vc 0
            repeat(250) begin
                `uvm_do_on_with(pkt0, p_sequencer.htax_seqr[0], {dest_port == 3; delay == 1; length == 3;vc==1;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt1, p_sequencer.htax_seqr[1], {dest_port == 3; delay == 9; length == 20;vc==1;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt2, p_sequencer.htax_seqr[2], {dest_port == 3; delay == 15; length == 40;vc==1;})
            end
            repeat(250) begin
                `uvm_do_on_with(pkt3, p_sequencer.htax_seqr[3], {dest_port == 3; delay == 20; length == 62;vc==1;})
            end
        join
  endtask : body

endclass : stress_vsequence