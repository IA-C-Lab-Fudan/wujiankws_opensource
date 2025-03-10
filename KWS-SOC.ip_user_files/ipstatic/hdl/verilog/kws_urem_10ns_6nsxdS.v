// ==============================================================
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.2 (64-bit)
// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1 ns / 1 ps

module kws_urem_10ns_6nsxdS_div_u
#(parameter
    in0_WIDTH = 32,
    in1_WIDTH = 32,
    out_WIDTH = 32
)
(
    input                       clk,
    input                       reset,
    input                       ce,
    input       [in0_WIDTH-1:0] dividend,
    input       [in1_WIDTH-1:0] divisor,
    output wire [out_WIDTH-1:0] quot,
    output wire [out_WIDTH-1:0] remd
);

localparam cal_WIDTH = (in0_WIDTH > in1_WIDTH)? in0_WIDTH : in1_WIDTH;

//------------------------Local signal-------------------
reg  [in0_WIDTH-1:0] dividend_tmp[0:in0_WIDTH];
reg  [in1_WIDTH-1:0] divisor_tmp[0:in0_WIDTH];
reg  [in0_WIDTH-1:0] remd_tmp[0:in0_WIDTH];
wire [in0_WIDTH-1:0] comb_tmp[0:in0_WIDTH-1];
wire [cal_WIDTH:0]   cal_tmp[0:in0_WIDTH-1];
//------------------------Body---------------------------
assign  quot    = dividend_tmp[in0_WIDTH];
assign  remd    = remd_tmp[in0_WIDTH];

// dividend_tmp[0], divisor_tmp[0], remd_tmp[0]
always @(posedge clk)
begin
    if (ce) begin
        dividend_tmp[0] <= dividend;
        divisor_tmp[0]  <= divisor;
        remd_tmp[0]     <= 1'b0;
    end
end

genvar i;
generate 
    for (i = 0; i < in0_WIDTH; i = i + 1)
    begin : loop
        if (in0_WIDTH == 1) assign  comb_tmp[i]     = dividend_tmp[i][0];
        else                assign  comb_tmp[i]     = {remd_tmp[i][in0_WIDTH-2:0], dividend_tmp[i][in0_WIDTH-1]};
        assign  cal_tmp[i]      = {1'b0, comb_tmp[i]} - {1'b0, divisor_tmp[i]};

        always @(posedge clk)
        begin
            if (ce) begin
                if (in0_WIDTH == 1) dividend_tmp[i+1] <= ~cal_tmp[i][cal_WIDTH];
                else                dividend_tmp[i+1] <= {dividend_tmp[i][in0_WIDTH-2:0], ~cal_tmp[i][cal_WIDTH]};
                divisor_tmp[i+1]  <= divisor_tmp[i];
                remd_tmp[i+1]     <= cal_tmp[i][cal_WIDTH]? comb_tmp[i] : cal_tmp[i][in0_WIDTH-1:0];
            end
        end
    end
endgenerate

endmodule

module kws_urem_10ns_6nsxdS_div
#(parameter
        in0_WIDTH   = 32,
        in1_WIDTH   = 32,
        out_WIDTH   = 32
)
(
        input                           clk,
        input                           reset,
        input                           ce,
        input           [in0_WIDTH-1:0] dividend,
        input           [in1_WIDTH-1:0] divisor,
        output  reg     [out_WIDTH-1:0] quot,
        output  reg     [out_WIDTH-1:0] remd
);
//------------------------Local signal-------------------
reg     [in0_WIDTH-1:0] dividend0;
reg     [in1_WIDTH-1:0] divisor0;
wire    [in0_WIDTH-1:0] dividend_u;
wire    [in1_WIDTH-1:0] divisor_u;
wire    [out_WIDTH-1:0] quot_u;
wire    [out_WIDTH-1:0] remd_u;
//------------------------Instantiation------------------
kws_urem_10ns_6nsxdS_div_u #(
    .in0_WIDTH      ( in0_WIDTH ),
    .in1_WIDTH      ( in1_WIDTH ),
    .out_WIDTH      ( out_WIDTH )
) kws_urem_10ns_6nsxdS_div_u_0 (
    .clk      ( clk ),
    .reset    ( reset ),
    .ce       ( ce ),
    .dividend ( dividend_u ),
    .divisor  ( divisor_u ),
    .quot     ( quot_u ),
    .remd     ( remd_u )
);
//------------------------Body---------------------------
assign dividend_u = dividend0;
assign divisor_u = divisor0;

always @(posedge clk)
begin
    if (ce) begin
        dividend0 <= dividend;
        divisor0  <= divisor;
    end
end

always @(posedge clk)
begin
    if (ce) begin
        quot <= quot_u;
        remd <= remd_u;
    end
end

endmodule


`timescale 1 ns / 1 ps
module kws_urem_10ns_6nsxdS(
    clk,
    reset,
    ce,
    din0,
    din1,
    dout);

parameter ID = 32'd1;
parameter NUM_STAGE = 32'd1;
parameter din0_WIDTH = 32'd1;
parameter din1_WIDTH = 32'd1;
parameter dout_WIDTH = 32'd1;
input clk;
input reset;
input ce;
input[din0_WIDTH - 1:0] din0;
input[din1_WIDTH - 1:0] din1;
output[dout_WIDTH - 1:0] dout;

wire[dout_WIDTH - 1:0] sig_quot;


kws_urem_10ns_6nsxdS_div #(
.in0_WIDTH( din0_WIDTH ),
.in1_WIDTH( din1_WIDTH ),
.out_WIDTH( dout_WIDTH ))
kws_urem_10ns_6nsxdS_div_U(
    .dividend( din0 ),
    .divisor( din1 ),
    .remd( dout ),
    .quot( sig_quot ),
    .clk( clk ),
    .ce( ce ),
    .reset( reset ));

endmodule

