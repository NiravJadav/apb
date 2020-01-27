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


localparam IDLE = 2'b01;
localparam SETUP = 2'b10;
localparam ACCESS = 2'b11;

reg [1:0]state;
//reg [2:0]next_state;

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
			if(!transfer)
			begin
			pselect <= 0; penable <= 0;
			state <= IDLE;
			end
			else if (transfer)
			begin
			pselect <= 1;	
			penable <= 0;
			state <= SETUP;
			end
			end
		SETUP : 
			begin
			pselect <= 1;	
			penable <= 1;
			state <= ACCESS;
			end 
		ACCESS :
			begin
			if(!pready)
				begin
				penable <= 1;pselect <= 1; 
				state <= ACCESS;
				end
              		else if(pready & transfer)
				begin
				penable <= 0;pselect <= 1; 
				state <= SETUP;
				end
			else if(pready & !transfer)
				begin
				penable <= 0;pselect <= 0; 
				state <= IDLE;
				end
			end
		
	default : state <= IDLE;
	endcase
	
end


endmodule 
