// instrmem.sv
//
// RISC-V instruction memory
// November 2024
// roger@wustl.edu
//
// run 2000
// Observe at least clk, PCF, IMRead, InstrF, IMRdy, MAddr, MRead, MData, and MRdy
// to check correct operation.
//
//

parameter N = 46;

module testbench();

  logic clk;
  logic reset;

  logic [31:0] PCF;            // PC in Fetch stage
  logic [31:0] InstrF;         // Instr in Fetch stage
  logic        IMRead, IMRdy;  // Control signals for instruction memory

  logic [31:0] MAddr;          // Main memory address
  logic [31:0] MData;          // Main memory data
  logic        MRead, MRdy;    // Control signals for main memory

  logic [31:0] index;              // Index into test instructions
  logic [31:0] InstrAddrs[N-1:0];  // Test instruction addresses

  // instantiate dut to be tested
  icache dut(clk, reset, PCF, InstrF, IMRead, IMRdy, MAddr, MData, MRead, MRdy);
  
  // instantiate main memory
  mmemory mem(clk, reset, MAddr, MData, MRead, MRdy);

  // initialize test
  initial
    begin
      $readmemh("testaddresses.txt",InstrAddrs);
      index <= 0;
		PCF <= 32'h00000010;        // setup initial instruction
		IMRead <= 0;
      reset <= 1; #22; reset <=0; // provide reset
      IMRead <= 1;                // initiate first instruction fetch
    end

  // generate clock
  always
    begin
      clk <= 1; #5; clk <= 0; #5;
    end

  // provide tests
  always @(negedge clk)
    begin
      if (IMRdy === 1) begin
        index <= index + 1;
        if (index === N) begin
          $display("All instructions fetched");
          $stop;
        end
        PCF <= InstrAddrs[index];  // provide next address
      end
    end
endmodule

// icache - this is what is to be designed
module icache(input  logic        clk, reset,
              input  logic [31:0] A,            // address
              output logic [31:0] RD,           // read data
              input  logic        RE,           // read enable
              output logic        RDY,          // data ready
              output logic [31:0] MAddr,
              input  logic [31:0] MData,
              output logic        MRead,
              input  logic        MRdy);

  // INSERT YOUR DESIGN FOR ICACHE HERE

endmodule

// main memory
// NOTE: this is testbench code, so is not synthesizable
module mmemory(input  logic        clk, reset,
               input  logic [31:0] A,            // address
               output logic [31:0] RD,           // read data
               input  logic        RE,           // read enable
               output logic        RDY);         // data ready

  logic [31:0] mem[63:0]; // size 64 words (256 bytes)
  logic        busy;      // memory is currently responding to an earlier request

  initial
    begin
      $readmemh("memcontents.txt",mem);
      RDY <= 0;
      RD <= 0;
      busy <= 0;
    end

  always @(posedge clk)
    begin
      if (RE === 0)
        begin
          RDY <= 0;
          RD <= 0;
          busy <= 0;
        end
      else if (busy !== 1)
        begin
          RDY <= 0;
          RD <= 0;
          busy <= 1;
          #92;
          RDY <= 1;
          RD <= mem[A[31:2]]; // word aligned
          busy <= 0;
        end
    end

endmodule