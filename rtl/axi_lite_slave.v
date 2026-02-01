module axi_lite_slave (
    input  wire        clk,
    input  wire        rst,

    // Write address channel
    input  wire        awvalid,
    input  wire [31:0] awaddr,
    output reg         awready,

    // Write data channel
    input  wire        wvalid,
    input  wire [31:0] wdata,
    output reg         wready,

    // Write response channel
    output reg         bvalid,
    input  wire        bready,

    // Read address channel
    input  wire        arvalid,
    input  wire [31:0] araddr,
    output reg         arready,

    // Read data channel
    output reg         rvalid,
    output reg [31:0]  rdata,
    input  wire        rready
);

    // Simple register map
    reg [31:0] reg0;

    always @(posedge clk) begin
        if (rst) begin
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            arready <= 0;
            rvalid  <= 0;
            reg0    <= 0;
        end else begin
            // WRITE HANDSHAKE
            if (awvalid && !awready)
                awready <= 1;
            else
                awready <= 0;

            if (wvalid && !wready)
                wready <= 1;
            else
                wready <= 0;

            if (awvalid && wvalid) begin
                reg0 <= wdata;
                bvalid <= 1;
            end else if (bready) begin
                bvalid <= 0;
            end

            // READ HANDSHAKE
            if (arvalid && !arready) begin
                arready <= 1;
                rdata <= reg0;
                rvalid <= 1;
            end else if (rready) begin
                rvalid <= 0;
                arready <= 0;
            end
        end
    end

endmodule
