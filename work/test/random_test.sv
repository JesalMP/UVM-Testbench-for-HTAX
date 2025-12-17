class random_test extends base_test;

	`uvm_component_utils(random_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", random_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting multiport random test",UVM_NONE)
	endtask : run_phase

endclass : random_test


class random_vsequence extends htax_base_vseq;

  `uvm_object_utils(random_vsequence)

  rand int port;

  function new (string name = "random_vsequence");
    super.new(name);
  endfunction : new

  task body();
		// Exectuing 10 TXNs on ports {0,1,2,3} randomly 
    repeat(100) begin
      port = $urandom_range(0,3);
      `uvm_do_on(req, p_sequencer.htax_seqr[port])
    end
  endtask : body

endclass : random_vsequence
