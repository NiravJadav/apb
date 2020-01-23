module stimuls ();

parameter WIDTH =16;

reg TRANSFER;
reg PCLK;
reg PRESET;
reg PREADY;
reg [WIDTH-1:0]PRDATA;

wire PSELECT;
wire PENABLE;
wire PWRITE;
wire [WIDTH-1:0] PWDATA;
wire [WIDTH-1:0] PADDR;


apb_bridge brige (
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
	repeat(25) #5 PCLK <= !PCLK;
end

initial
begin
	TRANSFER <= 0;
	PRESET <=0;
	PREADY <=1;
	#2
	PRESET <= 1;
	TRANSFER <=1;
end

//always @(posedge PENABLE)
//	if(PENABLE)begin PREADY <= 1; #10  PREADY<= 0; end
	


endmodule 

