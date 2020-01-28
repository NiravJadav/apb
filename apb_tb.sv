module stimuls ();

parameter WIDTH =16;

reg TRANSFER;
reg PCLK;
reg PRESET;
reg PREADY;
reg [WIDTH-1:0]PRDATA;
reg RD_WR;
reg [WIDTH-1:0]DATA =0;

wire PSELECT;
wire PENABLE;
wire PWRITE;
wire [WIDTH-1:0] PWDATA;
wire [WIDTH-1:0] PADDR;

localparam CP = 10; 
apb_bridge brige (	.rd_wr(RD_WR),
		        .transfer(TRANSFER),	// peripheral transfer 
			.pclk(PCLK),		// peripheral clock
			.preset_n(PRESET),	// peripheral reser 
			.pready(PREADY), 	// peripheral ready signal 
			.prdata(PRDATA),	// peripheral read data bus
			.pselect(PSELECT),
			.penable(PENABLE),
			.pwrite(PWRITE),
			.pwdata(PWDATA),
			.paddr(PADDR));



initial
begin 
	PCLK <= 0;
	repeat(25) #(CP/2) PCLK <= !PCLK;
end

initial
begin
	TRANSFER = 0;	PRESET =0;  PREADY =0;  RD_WR =0;

	#(CP/2)	PRESET = 1;  TRANSFER =1; RD_WR =1; 
	#(CP/2) TRANSFER =0; 
	#(CP) 
	#(CP/2)	TRANSFER =1; RD_WR = 0; DATA = 'hee; 
	#(CP/2)	TRANSFER = 0;
	#CP
	#CP $finish;



end


always@(PENABLE)
	begin
	if(PENABLE)
		begin
		  PREADY <=1;
	          	if(PSELECT &  PWRITE)
			DATA <= PWDATA;
			else if(PSELECT & (!PWRITE))
			PRDATA <= DATA;
		end
	else if(!PENABLE) begin PREADY <= 0; PRDATA <= 0; end
	end


//always@(posedge PCLK)
//	$display("TRANSFER = %b,PCLK = %b,PENABLE = %b, PREADY = %b, PSELECT = %b",TRANSFER,PCLK,PENABLE,PREADY,PSELECT);
endmodule 
