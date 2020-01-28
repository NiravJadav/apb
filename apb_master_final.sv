module apb_bridge #(parameter WIDTH =16)
		 (      input transfer,			// peripheral transfer 
			input rd_wr,			// rd_wr = 1 --> write | rd_wr = 0 --< read
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
reg [1:0]next_state;

reg [WIDTH-1:0]data = 'hff;
reg [WIDTH-1:0]addr = 0;

always@(state or transfer or pready)
begin
	case(state)
		IDLE :
			begin
			pselect <= 0;
			penable <= 0;
			pwdata <= 0;
			paddr <= 0;
			pwrite<=0;
			if(!transfer)
				next_state <= IDLE;
			else if (transfer)
				next_state <= SETUP;
			end


		SETUP : 
			begin
			pselect <= 1;
			penable <= 0;
			next_state <= ACCESS;
			if(rd_wr)		// write transfer
				begin
				pwrite <= 1;
				paddr <= addr;
				pwdata <= data;
				end
			else if(!rd_wr)
				begin		// read transfer
				pwrite<=0;
				paddr <= addr;
				end
			end


		ACCESS :
			begin
			pselect <= 1;
			penable <= 1;
			
			if(!pready)
				next_state <= ACCESS;
              		else
				begin
				if(pready & transfer)
					next_state <= SETUP;
				else if(pready & !transfer)
					next_state <= IDLE;
				end
			
			if(pwrite)		// write tranfer
				begin
				paddr <= addr;
				pwdata <= pwdata;
				end
			else if(!pwrite)	// read transfer
				begin
				paddr <= addr;
				if(pready)
					data <= prdata;
				end
			end
		
	default : next_state <= IDLE;
	endcase
	
end

always@(posedge pclk or negedge preset_n)
	begin
	if(!preset_n)
		begin
		state <= IDLE;
		end		
	else 
		state <= next_state;
	end

endmodule	
