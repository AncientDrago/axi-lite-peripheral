module tb_axi_lite;
    reg clk = 0;
    reg rst = 1;

    always #5 clk = ~clk;

    reg awvalid;
    reg [31:0] awaddr;
    wire awready;

    reg wvalid;
    reg [31:0] wdata;
    wire wready;

    wire bvalid;
    reg bready;

    reg arvalid;
    reg [31:0] araddr;
    wire arready;

    wire rvalid;
    wire [31:0] rdata;
    reg rready;

    axi_lite_slave dut (
        .clk(clk), .rst(rst),
        .awvalid(awvalid), .awaddr(awaddr), .awready(awready),
        .wvalid(wvalid), .wdata(wdata), .wready(wready),
        .bvalid(bvalid), .bready(bready),
        .arvalid(arvalid), .araddr(araddr), .arready(arready),
        .rvalid(rvalid), .rdata(rdata), .rready(rready)
    );

    initial begin
        $dumpfile("waveforms/axi.vcd");
        $dumpvars(0, tb_axi_lite);

        // Reset
        #20 rst = 0;

        // Write
        awaddr = 32'h0;
        awvalid = 1;
        wdata = 32'hDEADBEEF;
        wvalid = 1;
        bready = 1;

        #20;
        awvalid = 0;
        wvalid = 0;

        // Read
        araddr = 32'h0;
        arvalid = 1;
        rready = 1;

        #40 $finish;
    end
endmodule
