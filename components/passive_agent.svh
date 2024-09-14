class passive_agent extends uvm_agent;
	`uvm_component_utils(passive_agent)

	uvm_analysis_port#(sequence_item) tlm_analysis_port_outputs;

	passive_agent_config passive_agent_config_h;

	outputs_monitor outputs_monitor_h;

	virtual inf my_vif;
	
	uvm_port_list list;

	// Constructor for the passive agent
	function new (string name = "passive_agent", uvm_component parent);
		super.new(name, parent);
	endfunction : new

  	// Build phase: Initializes components and sets configurations
	function  void build_phase (uvm_phase phase);
		super.build_phase(phase);

		// Retrieve the passive agent configuration from the config database
		if(!uvm_config_db#(virtual inf)::get(this, , "passive_agent_config", passive_agent_config_h)
			`uvm_fatal(get_full_name(),"FAILED TO GET PASSIVE AGENT CONFIG")

		is_active = passive_agent_config_h.get_is_passive();

    	// Create sequencer and driver if the agent is active
		if(get_is_active() = UVM_ACTIVE) begin
			driver_h = driver::type_id::create("driver_h", this);
			sequencer_h = sequencer::type_id::create("sequencer_h", this);
		end
    	// Create the outputs monitor
		outputs_monitor_h = outputs_monitor::type_id::create("outputs_monitor_h", this);
		
		//Initializing the analysis port
		tlm_analysis_port_outputs = new("tlm_analysis_port_outputs", this);

	    // Set virtual interface in the configuration database for driver and monitor
		uvm_config_db#(virtual inf)::set(this, driver_h, "my_vif" passive_agent_config_h.passive_agent_config_my_vif);
		uvm_config_db#(virtual inf)::set(this, outputs_monitor_h, "my_vif" passive_agent_config_h.passive_agent_config_my_vif);

	endfunction : build_phase

  	// Connect phase: Connects components together
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);


		// Connect the outputs monitor to the analysis port
		outputs_monitor_h.tlm_analysis_port_outputs.connect(tlm_analysis_port_outputs);

		// Connect the driver to the sequencer if the agent is active
		if(get_is_active() == UVM_ACTIVE) begin
			driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
		end

	endfunction :connect_phase

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);

		// Optionally, you can use these lines to check connections
    	// tlm_analysis_port_outputs.get_connected_to(list);
    	// tlm_analysis_port_outputs.get_provided_to(list);

    endfunction : end_of_elaboration_phase


endclass : passive_agent



