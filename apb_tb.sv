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

localparam CP = 10; 
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
	repeat(25) #(CP/2) PCLK <= !PCLK;
end

initial
begin
	TRANSFER <= 0;	PRESET <=0;	PREADY <=0;

	#2	PRESET <= 1;	TRANSFER <=1;

	#(CP-2)	#CP	TRANSFER <= 0;

//	#CP #CP	#(CP+CP/2)	PREADY <=1;

//	#CP	PREADY <=0;

//	#CP	$finish;


end


always@(PENABLE)
	begin
	if(PENABLE)  PREADY <=1;
	else if(!PENABLE) PREADY <= 0;
	end



always@(posedge PCLK)
	$display("TRANSFER = %b,PCLK = %b,PENABLE = %b, PREADY = %b, PSELECT = %b",TRANSFER,PCLK,PENABLE,PREADY,PSELECT);
endmodule 
