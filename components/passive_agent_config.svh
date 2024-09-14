class passive_agent_config;

	virtual inf passive_agent_config_my_vif;

	uvm_active_passive_enum is_passive;

	function new(virtual inf passive_agent_config_my_vif, uvm_active_passive_enum is_passive);
		this.passive_agent_config_my_vif = passive_agent_config_my_vif;
		this.is_passive = is_passive;
	endfunction : new

	function uvm_active_passive_enum get_is_passive();
		is_passive == UVM_PASISVE;
		return is_passive;
	endfunction

endclass : passive_agent_config