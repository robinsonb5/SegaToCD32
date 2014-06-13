
//`#start header` -- edit after this line, do not edit this line
// ========================================
//
// Copyright YOUR COMPANY, THE YEAR
// All Rights Reserved
// UNPUBLISHED, LICENSED SOFTWARE.
//
// CONFIDENTIAL AND PROPRIETARY INFORMATION
// WHICH IS THE PROPERTY OF your company.
//
// ========================================
`include "cypress.v"
//`#end` -- edit above this line, do not edit this line
// Generated on 05/20/2014 at 23:58
// Component: CD32Shifter
module CD32Shifter (
	output  db9_6_out,
	output  db9_9_out,
	input   clock,
	input   db9_5_in,
	input   db9_6_in
);

//`#start body` -- edit after this line, do not edit this line

//        Your code goes here

localparam OPERATION_SHIFT=3'b000;
localparam OPERATION_NOP=3'b001;
localparam OPERATION_LOAD=3'b010;
localparam OPERATION_LOADSHIFT=3'b011;
reg[2:0] operation;

localparam STATE_IDLE=2'b00;
localparam STATE_IDLE2=2'b01;
localparam STATE_SHIFT1=2'b10;
localparam STATE_SHIFT2=2'b11;
reg[1:0] shiftstate;

wire mode;
assign mode=db9_5_in;  // Shift register enable signal on DB9 pin 5.

wire shift;
assign shift=db9_6_in;  // Shift register clock signal on DB9 pin 6.

wire firebutton; // Gets its value from the DataPath z1 signal (1 when A1=0).

// If the mode signal is high, then buttons 0 and 1 are passed through to DB9 pins 6 and 9, respectively
// If the mode signal is low, then the output of the shifter is passed to DB9 pin 9,
// while pin 6 becomes a clock signal.

wire shifted_data;
assign db9_9_out = shifted_data;
assign db9_6_out = mode ? firebutton : 1'b1;

// FIXME - do we need more filtering on DB9_6_in?

always @(posedge clock)
begin
    if(shiftstate==STATE_IDLE)
    begin
        shiftstate<=STATE_IDLE;

        // Contintually load the current button status into the shift register while idle.
        // This allows the first button's status to reach the s0 signal.
        operation<=OPERATION_LOAD;

        // Wait for mode signal to drop.  When it does, start shifting.
        if(mode==1'b0 && shift==1'b0)
        begin
            shiftstate<=STATE_SHIFT1;
        end
    end
    else if(shiftstate==STATE_SHIFT1)
    begin
        operation<=OPERATION_NOP;
        // Wait for posedge of the shift signal, shift data on transition.
        if(shift==1'b1)
        begin
            shiftstate<=STATE_SHIFT2;
            operation<=OPERATION_SHIFT;
        end
        
        if(mode==1'b1)
            shiftstate<=STATE_IDLE;
    end
    else if(shiftstate==STATE_SHIFT2)
    begin
        operation<=OPERATION_NOP;
        // Wait for negedge of the shift signal.
        if(shift==1'b0)
        begin
            shiftstate<=STATE_SHIFT1;
        end
    
        if(mode==1'b1)
            shiftstate<=STATE_IDLE;
    end
    else
        shiftstate<=STATE_IDLE;
end


cy_psoc3_dp8 #(.cy_dpconfig_a(
{
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP___SL, `CS_A0_SRC__ALU, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM0:    SHIFT*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM1:    NOP*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC___D0, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM2:    LOAD*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP___SL, `CS_A0_SRC___D0, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM3:   LOADSHIFT*/
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM4:             */
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM5:             */
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM6:             */
    `CS_ALU_OP_PASS, `CS_SRCA_A0, `CS_SRCB_D0,
    `CS_SHFT_OP_PASS, `CS_A0_SRC_NONE, `CS_A1_SRC_NONE,
    `CS_FEEDBACK_DSBL, `CS_CI_SEL_CFGA, `CS_SI_SEL_CFGA,
    `CS_CMP_SEL_CFGA, /*CFGRAM7:             */
    8'hFF, 8'hFF,  /*CFG9:             */
    8'hFF, 8'hFF,  /*CFG11-10:             */
    `SC_CMPB_A1_D1, `SC_CMPA_A1_D1, `SC_CI_B_ARITH,
    `SC_CI_A_ARITH, `SC_C1_MASK_DSBL, `SC_C0_MASK_DSBL,
    `SC_A_MASK_DSBL, `SC_DEF_SI_1, `SC_SI_B_DEFSI,
    `SC_SI_A_DEFSI, /*CFG13-12:      */
    `SC_A0_SRC_ACC, `SC_SHIFT_SL, 1'h0,
    1'h0, `SC_FIFO1_BUS, `SC_FIFO0_BUS,
    `SC_MSB_DSBL, `SC_MSB_BIT0, `SC_MSB_NOCHN,
    `SC_FB_NOCHN, `SC_CMP1_NOCHN,
    `SC_CMP0_NOCHN, /*CFG15-14:             */
    10'h00, `SC_FIFO_CLK__DP,`SC_FIFO_CAP_AX,
    `SC_FIFO_LEVEL,`SC_FIFO__SYNC,`SC_EXTCRC_DSBL,
    `SC_WRK16CAT_DSBL /*CFG17-16:             */
}
)) CD32Shifter_DP(
        /*  input                   */  .reset(1'b0),
        /*  input                   */  .clk(clock),
        /*  input   [02:00]         */  .cs_addr(operation),
        /*  input                   */  .route_si(1'b0),
        /*  input                   */  .route_ci(1'b0),
        /*  input                   */  .f0_load(1'b0),
        /*  input                   */  .f1_load(1'b0),
        /*  input                   */  .d0_load(1'b0),
        /*  input                   */  .d1_load(1'b0),
        /*  output                  */  .ce0(),
        /*  output                  */  .cl0(),
        /*  output                  */  .z0(),
        /*  output                  */  .ff0(),
        /*  output                  */  .ce1(),
        /*  output                  */  .cl1(),
        /*  output                  */  .z1(firebutton), // We use A1 to bring the fire button's status into the component
        /*  output                  */  .ff1(),
        /*  output                  */  .ov_msb(),
        /*  output                  */  .co_msb(),
        /*  output                  */  .cmsb(),
        /*  output                  */  .so(shifted_data),
        /*  output                  */  .f0_bus_stat(),
        /*  output                  */  .f0_blk_stat(),
        /*  output                  */  .f1_bus_stat(),
        /*  output                  */  .f1_blk_stat()
);
//`#end` -- edit above this line, do not edit this line
endmodule
//`#start footer` -- edit after this line, do not edit this line
//`#end` -- edit above this line, do not edit this line









