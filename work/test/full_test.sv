///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class full_test extends base_test;

	`uvm_component_utils(full_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", full_test_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting full test",UVM_NONE)
	endtask : run_phase

endclass : full_test


///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class full_test_vsequence extends htax_base_vseq;

  `uvm_object_utils(full_test_vsequence)

  rand int port;

  function new (string name = "full_test_vsequence");
    super.new(name);
  endfunction : new

  task body();
		// Exectuing 10 TXNs on ports {0,1,2,3} randomly 
    // repeat(10) begin
    //   port = $urandom_range(0,3);
    //   `uvm_do_on(req, p_sequencer.htax_seqr[port])

	// 		//USE `uvm_do_on_with to add constraints on req
		
    // end
	int lengths[16] = {3,7,11,15,19,23,27,31,35,39,43,47,51,55,58,61};
	int counter =0;
	for (int dp = 0; dp < 4; dp++) begin            // DEST_PORT: 0..3
            for (int v = 1; v <= 3; v++) begin          // VC: 1..3 (exclude 0)
                for(int pkt_delay=1; pkt_delay<=20; pkt_delay++) begin
					for(int pkt_length=3; pkt_length<=62; pkt_length++) begin
						for(int fp=0; fp<4; fp++) begin    // FLOW_PRIORITY: 0..3
							counter++;
								`uvm_do_on_with(req, p_sequencer.htax_seqr[fp], {
								dest_port == dp; 
								vc == v; 
								length == pkt_length;
								delay == pkt_delay;
							})
						`uvm_info(get_type_name(),$sformatf("Transaction %0d: from_port %0d, dest_port=%0d, vc=%0d, length=%0d, delay=%0d", counter, fp, dp, v, pkt_length, pkt_delay), UVM_NONE)
						end
						end
				end
            end
        end
  endtask : body

endclass : full_test_vsequence
