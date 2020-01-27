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
reg [1:0]next_state;

always@(state or transfer or pready)
begin
	case(state )
		IDLE :
			begin
			if(!transfer)
				next_state <= IDLE;
			else if (transfer)
				next_state <= SETUP;
			end
		SETUP : 
			next_state <= ACCESS;
		ACCESS :
			begin
			if(!pready)
				next_state <= ACCESS;
              		else
			begin
			 if(pready & transfer)
				next_state <= SETUP;
			else if(pready & !transfer)
				next_state <= IDLE;
			end
			end
		
	default : state <= IDLE;
	endcase
	
end

always@(posedge pclk or negedge preset_n)
	begin
	if(!preset_n)
		begin
		state <= IDLE;
		//next_state <= IDLE;
		end		
	else 
		state <= next_state;
	end

always@(state)
begin
	if(!preset_n)
		begin
		pselect <=0;
		penable <=0;
		end
	else
	case(state)
	IDLE: 
		begin
		pselect <= 0;
		penable <= 0;
		end
	SETUP:
		begin
		pselect <= 1;
		penable <= 0;
		end
	ACCESS:
		begin
		pselect <= 1;
		penable <=1;
		end
	endcase
end
endmodule	
