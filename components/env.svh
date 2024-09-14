class env extends uvm_env;
	`uvm_component_utils(env)

	virtual inf my_vif;

	env_config env_config_h;
	active_agent_cnfig active_agent_config_h;

	scoreboard scoreboard_h;
	coverage coverage_h;
	active_agent active_agent_h;


	function new (string name = "env", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase);
		super.build_phase(phase);

		if(!uvm_config_db#(env_config)::get(this, , "env_config_h", env_config_h))
			`uvm_fatal(get_full_name(), "FAILED TO GET ENV_CONFIG")

		scoreboard_h = scoreboard::type_id::create("scoreboard_h");
		coverage_h = coverage::type_id::create("coverage_h");
		active_agent_h = active_agent::type_id::create("active_agent_h");

		active_agent_config_h = new(.active_agent_my_vif(my_vif), .is_active(UVM_ACTIVE));
		uvm_config_db#(active_agent_config)::set(this, active_agent_h, "active_agent_config_h", active_agent_config_h);
		uvm_config_db#(virtual inf)::set(this, scoreboard_h, "my_vif", env_config_h.env_config_my_vif);
		uvm_config_db#(virtual inf)::set(this, coverage_h , "my_vif", env_config_h.env_config_my_vif);

	endfunction

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		active_agent_h.tlm_analysis_port_inputs.connect(scoreboard_h.tlm_analysis_export_inputs);
		active_agent_h.tlm_analysis_port_outputs.connect(scoreboard_h.tlm_analysis_export_outputs);
		active_agent_h.tlm_analysis_port_inputs.connect(coverage_h.tlm_analysis_export_inputs);

	endfunction : connect_phase

endclass : env