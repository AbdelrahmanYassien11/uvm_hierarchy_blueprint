class outputs_monitor extends uvm_monitor;
	`uvm_component_utils(outputs_monitor)

	virtual inf my_vif;
	
	sequence_item seq_item;

	uvm_analysis_port#(sequence_item) tlm_analysis_port_outputs;


	function new (string name = "outputs_monitor", uvm_component parent);
		super.new(name, parent);		
	endfunction : new

	function void build_phase (uvm_phase phase);
		super.build_phase(phase);

		if(!uvm_config_db#(virtual inf)::get(this, , "my_vif", my_vif))
			`uvm_fatal(get_full_nmae(),"FAILED TO GET V INTERFACE HANDLE")
		
		seq_item = sequence_item::type_id::create("seq_item");
		tlm_analysis_port_outputs =  new("tlm_analysis_port_outputs", this);

	endfunction : build_phase

	function void connect_phase(uvm_phase);
		super.connect_phase(phase);
		my_vif.outputs_monitor_h = this;
	endfunction : connect_phase

	function void write_to_monitor (/* insert the outputs you wish to monitor here */);
		seq_item. = ;
		seq_item. = ;
		seq_item. = ;

		tlm_analysis_port_outputs.write(seq_item);
	endfunction : write_to_monitor

endclass : outputs_monitor