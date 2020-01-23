module apb_bridge #(parameter WIDTH =16)
		 (      input transfer,			// peripheral transfer 
			input pclk,			// peripheral clock
			input preset_n,			// peripheral reser 
			input pready, 			// peripheral ready signal 
			input [WIDTH-1:0]prdata,	// peripheral read data bus
			output reg pselect,
			output reg penable,
			output reg pwrite,
			output reg [WIDTH-1:0]pwdata,
			output reg [WIDTH-1:0]paddr);


localparam IDLE = 3'b01;
localparam SETUP = 3'b010;
localparam ACCESS = 3'b100;

reg [2:0]state;
reg [2:0]next_state;

always@(posedge pclk or negedge preset_n )
begin
	if(!preset_n)
	begin
	state   <= IDLE;
	pselect <= 0;
	penable <= 0;
	end
	else
	case(state)
		IDLE :
			begin
			pselect <= 0;	
			penable <= 0;
			if(transfer) state <= SETUP;
			else state <= IDLE;
			end
		SETUP : 
			begin
			pselect <= 1;	
			penable <= 0;
			state <= ACCESS;
			end 
		ACCESS :
			begin
			pselect <= 1;
			penable <= 1;
			if(!pready)
				state <= ACCESS;
			else if(pready & transfer)
				state <= SETUP;
			else if(pready & !transfer)
				state <= IDLE;
			end
	default : state <= IDLE;
	endcase
	
end


endmodule 
