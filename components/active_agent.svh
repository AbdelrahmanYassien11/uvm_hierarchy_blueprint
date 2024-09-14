class active_agent extends uvm_agent;
	`uvm_component_utils(active_agent)

	active_agent_config active_agent_config_h;

	driver driver_h;
	sequencer sequencer_h;
	inputs_monitor inputs_monitor_h;

	uvm_analysis_port#(sequence_item) tlm_analysis_port_inputs;

	virtual inf my_vif;

	function new (string name = "active_agent", uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(active_agent_config)::get(this, ,"active_agent_config_h",active_agent_config_h))
			`uvm_fatal(get_full_name(),"COULDNT GET ACTIVE_AGENT_CONFIG")

		is_active = active_agent_config_h.get_is_active();

		if(get_is_active() ==  UVM_ACTIVE) begin
			driver_h = driver::type_id::create("driver_h", this);
			sequencer_h = sequencer::type_id::create("sequencer_h", this);
		end
		inputs_monitor_h = inptus_monitor::type_id::create("inputs_monitor_h", this);
		
		uvm_config_db#(virtual inf)::set(this, driver_h, "my_vif", active_agent_config_h.active_agent_config_my_vif);
		uvm_config_db#(virtual inf)::set(this, sequencer_h, "my_vif", active_agent_config_h.active_agent_config_my_vif);
		uvm_config_db#(virtual inf)::set(this, inputs_monitor_h, "my_vif", active_agent_config_h.active_agent_config_my_vif);

		tlm_analysis_port_inputs = new("tlm_analysis_port_inputs", this);
	endfunction : build_phase 

	function void connect_phase (uvm_phase phase);
		super.connect_phase(phase);
		inputs_monitor_h.tlm_analysis_port_inputs.connect(tlm_analysis_port_inputs);
		
		if(get_is_active() == UVM_ACTIVE)
			driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
	endfunction : connect_phase

endclass : active_agent