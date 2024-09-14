class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	env_config env_config_h;
	env env_h;
	sequencer sequencer_h;

	virtual inf my_vif;

	function new (string name = "base_test", uvm_component parent);
		super.new(name, parent);
	endfunction  

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		if(!(uvm_config_db#(virtual inf)::get( this, , "my_vif"  , my_vif ))
			`uvm_fatal(get_full_name(),"FAILED TO GET INF HANDLE")

		env_config = new(.env_config_my_vif(my_vif));
		env_h = env::type_id::create("env_h", this);
		sequencer_h = sequencer::type_id::create("sequencer_h", this);

		uvm_config_db#(env_config)::set(this, env_h, "env_config_h", env_config_h);

	endfunction 

	function void connect_phase (uvm_phase phase);
		super.build_phase(phase);
	endfunction 

	function void end_of_elaboration_phase(uvm_phase);
		super.end_of_elaboration_phase(phase);
		sequencer_h = env_h.active_agent_h.sequencer_h;

		base_sequence_h.sequencer_h = sequencer_h;
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		phase.raise_objection(this);

		base_sequence_h.start();

		phase.drop_objection(this);
	endtask


	function void report_phase (uvm_phase phase);
		super.report_phase(phase);

		`uvm_info(get_full_name(),"ERROR_COUNT: correct_count:%0d incorrect_count:%0d",UVM_LOW)
		
	endfunction : 
endclass : base_test