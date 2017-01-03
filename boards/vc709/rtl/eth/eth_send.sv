import endian_pkg::*;
import ethernet_pkg::*;
import ip_pkg::*;
import udp_pkg::*;
import dns_pkg::*;

module eth_send #(
	parameter ifg_len = 28'hFFFF,
	parameter frame_len = 16'd1020,
	parameter head_size = 6,
	parameter pad_size  = 121, //249

    parameter eth_dst   = 48'h90_E2_BA_5D_8D_C8,
//    parameter eth_dst   = 48'h90_E2_BA_92_CB_D5,
	parameter eth_src   = 48'h00_BB_00_BB_00_BB,
	parameter eth_proto = ETH_P_IP,
	parameter ip_saddr  = {8'd192, 8'd168, 8'd11, 8'd122},
	parameter ip_daddr  = {8'd10, 8'd0, 8'd0, 8'd1},
	parameter udp_sport = 16'd53,
	parameter udp_dport = 16'd50001            // 50001 ~ 51000
)(
	input wire clk156,
	input wire sys_rst,

	input  wire         s_axis_tx_tready,
	output logic        s_axis_tx_tvalid,
	output logic [63:0] s_axis_tx_tdata,
	output logic [ 7:0] s_axis_tx_tkeep,
	output logic        s_axis_tx_tlast,
	output logic        s_axis_tx_tuser
);

always_comb s_axis_tx_tuser = 1'b0;

// tx_packet
typedef union packed {
	bit [head_size-1:0][63:0] raw;           // 48B
	struct packed {
		ethhdr eth;                // 14B
		iphdr ip;                  // 20B
		udphdr udp;                //  8B
		dnshdr dns;                //  4B
		bit [15:0] pad;            //  2B
	} hdr;
} packet_t;

packet_t tx_pkt;

/* function: ipcheck_gen() */
function [15:0] ipcheck_gen(
		input [31:0] sa,
		input [31:0] da
	);
	bit [23:0] sum;
	sum = {8'h0, IPVERSION, 4'd5, 8'h0}
	    + {8'h0, frame_len - ETH_HDR_LEN}   // tot_len
	    + {8'h0, 16'h0}
	    + {8'h0, 16'h0}
	    + {8'h0, IPDEFTTL, IP4_PROTO_UDP}
	    + {8'h0, 16'h0}                     // checksum (zero padding)
	    + {8'h0, sa[31:16]}
	    + {8'h0, sa[15: 0]}
	    + {8'h0, da[31:16]}
	    + {8'h0, da[15: 0]};
	ipcheck_gen = ~( sum[15:0] + {8'h0, sum[23:16]} );
endfunction :ipcheck_gen

// packet init

always_comb begin
	tx_pkt.hdr.eth.h_dest = eth_dst;
	tx_pkt.hdr.eth.h_source = eth_src;
	tx_pkt.hdr.eth.h_proto = eth_proto;

	tx_pkt.hdr.ip.version = IPVERSION;
	tx_pkt.hdr.ip.ihl = 4'd5;
	tx_pkt.hdr.ip.tos = 0;
	tx_pkt.hdr.ip.tot_len = frame_len - ETH_HDR_LEN;
	tx_pkt.hdr.ip.id = 0;
	tx_pkt.hdr.ip.frag_off = 0;
	tx_pkt.hdr.ip.ttl = IPDEFTTL;
	tx_pkt.hdr.ip.protocol = IP4_PROTO_UDP;
//	tx_pkt.hdr.ip.saddr = ip_saddr;
	tx_pkt.hdr.ip.daddr = ip_daddr;
//	tx_pkt.hdr.ip.check = ipcheck_gen();

	tx_pkt.hdr.udp.source = udp_sport;
//	tx_pkt.hdr.udp.dest = udp_dport;
	tx_pkt.hdr.udp.len = frame_len - ETH_HDR_LEN - IP_HDR_DEFLEN;
	tx_pkt.hdr.udp.check = 0;
	
	tx_pkt.hdr.dns.id = 0;
	tx_pkt.hdr.dns.qr = 1;
	tx_pkt.hdr.dns.opcode = 0;
	tx_pkt.hdr.dns.aa = 0;
	tx_pkt.hdr.dns.tc = 0;
	tx_pkt.hdr.dns.rd = 0;
	tx_pkt.hdr.dns.ra = 0;
	tx_pkt.hdr.dns.z = 0;
	tx_pkt.hdr.dns.rcode = 0;
end

logic [15:0] dport;
logic [15:0] saddr_high;
logic [15:0] ipsum;

// main
logic [15:0] cnt_send, cnt_pad;
enum bit [1:0] { TX_IDLE, TX_SEND, TX_PAD, TX_END } tx_state = TX_IDLE;
always_ff @(posedge clk156) begin
	if (sys_rst) begin
		cnt_send   <= 0;
		cnt_pad    <= 0;
		tx_state   <= TX_IDLE;
		dport      <= 16'd50001;
		saddr_high <= 16'd1;
		ipsum      <= 16'd0;
	end else begin
		case (tx_state)
			TX_IDLE: begin
				cnt_send <= 0;
				cnt_pad  <= 0;
				if (s_axis_tx_tready) begin
					tx_state <= TX_SEND;

					// IP checksum
					ipsum <= ipcheck_gen(tx_pkt.hdr.ip.saddr, ip_daddr);
				end
			end
			TX_SEND: begin
				if (s_axis_tx_tready)
					cnt_send <= cnt_send + 1;
				if (cnt_send == (head_size - 1))
					tx_state <= TX_PAD;
			end
			TX_PAD: begin
				if (s_axis_tx_tready)
					cnt_pad <= cnt_pad + 1;
				if (cnt_pad == (pad_size - 1))
					tx_state <= TX_END;
			end
			TX_END: begin
				if (s_axis_tx_tready) begin
					tx_state <= TX_IDLE;

					// dport
					//if (dport == 16'd51000) begin
					//	dport <= 16'd50001;
					//end else begin
					//	dport <= dport + 1;
					//end

					// saddr_high
					if (saddr_high == 16'd32768) begin
						saddr_high <= 16'd0;
					end else begin
						saddr_high <= saddr_high + 1;
					end
				end
			end
			default:
				tx_state <= TX_IDLE;
		endcase
	end
end
always_comb tx_pkt.hdr.udp.dest = dport;
always_comb tx_pkt.hdr.ip.saddr = {8'd10, saddr_high, 8'd1};
always_comb tx_pkt.hdr.ip.check = ipsum;

// tdata
logic [63:0] s_axis_tx_tdata_reg;
always_comb begin
	if (tx_state == TX_SEND) begin
		case (cnt_send)
			28'h0: s_axis_tx_tdata_reg = tx_pkt.raw[5];
			28'h1: s_axis_tx_tdata_reg = tx_pkt.raw[4];
			28'h2: s_axis_tx_tdata_reg = tx_pkt.raw[3];
			28'h3: s_axis_tx_tdata_reg = tx_pkt.raw[2];
			28'h4: s_axis_tx_tdata_reg = tx_pkt.raw[1];
			28'h5: s_axis_tx_tdata_reg = tx_pkt.raw[0];
			default:
				s_axis_tx_tdata_reg = 64'b0;
		endcase
 end else begin
	  s_axis_tx_tdata_reg = 64'b0;
 end
end
always_comb s_axis_tx_tdata = endian_conv64(s_axis_tx_tdata_reg);

// tkeep
always_comb begin
	case (tx_state)
		TX_SEND: s_axis_tx_tkeep = 8'b1111_1111;
		TX_PAD:  s_axis_tx_tkeep = 8'b1111_1111;
		TX_END:  s_axis_tx_tkeep = 8'b0000_1111;
		default: s_axis_tx_tkeep = 8'b0000_0000;
	endcase
end

// tlast
always_comb s_axis_tx_tlast = (s_axis_tx_tready && tx_state == TX_END);

// tvalid
always_comb s_axis_tx_tvalid = (tx_state == TX_SEND || tx_state == TX_PAD || tx_state == TX_END);

endmodule

