package dns_pkg;
	/* DNS header */
	typedef struct packed {
		bit [15:0] id;
		bit        qr;
		bit [ 3:0] opcode;
		bit        aa;
		bit        tc;
		bit        rd;
		bit        ra;
		bit [ 2:0] z;
		bit [ 3:0] rcode;
	} dnshdr;

	/* udp_init */
	function dnshdr dns_init;
		dns_init.id     = 0;
		dns_init.qr     = 1;
		dns_init.opcode = 0;
		dns_init.aa     = 0;
		dns_init.tc     = 0;
		dns_init.rd     = 0;
		dns_init.ra     = 0;
		dns_init.z      = 0;
		dns_init.rcode  = 0;
	endfunction :dns_init

endpackage :dns_pkg

