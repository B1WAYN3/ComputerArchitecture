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
              output logic [31:0] MAddr,        // Memory Address Output
              input  logic [31:0] MData,			// Memory Data
              output logic        MRead,			// Memory Read Signal Output
              input  logic        MRdy);			// Memory Ready Input Signal 

    // Cache parameters
    localparam CACHE_SIZE  = 128;     // Total cache size in bytes
    localparam BLOCK_SIZE  = 4;       // Block size in bytes (1 word)
    localparam NUM_BLOCKS  = CACHE_SIZE / BLOCK_SIZE; // 32 cache lines
    localparam INDEX_BITS  = 5;       // Number of index bits (log2(NUM_BLOCKS))
    localparam TAG_BITS    = 25;      // Remaining bits for tag (32 - INDEX_BITS - 2)
    
    // Cache storage
    logic [NUM_BLOCKS-1:0]                 valid_array;
    logic [TAG_BITS-1:0]                   tag_array [0:NUM_BLOCKS-1];
    logic [31:0]                           data_array [0:NUM_BLOCKS-1];
    
    // Internal signals
    logic [TAG_BITS-1:0]                   tag_in;
    logic [INDEX_BITS-1:0]                 index;
    logic                                  hit;
    
    // Extract index and tag from address
    assign index = A[6:2];                 // Bits [6:2]
    assign tag_in = A[31:7];               // Bits [31:7]
    
    // Cache hit logic
    assign hit = valid_array[index] && (tag_array[index] == tag_in);
    
    // Sequential logic for cache operation
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_array <= '0;
            RDY <= 1'b0;
            MRead <= 1'b0;
            RD <= 32'b0;
        end else begin
            if (RE) begin
                if (hit) begin
                    // Cache hit: provide data immediately
                    RD <= data_array[index];
                    RDY <= 1'b1;
                    MRead <= 1'b0;
                end else begin
                    // Cache miss: initiate memory read
                    MAddr <= A;
                    MRead <= 1'b1;
                    RDY <= 1'b0;
                end
            end else if (MRead && MRdy) begin
                // Data from main memory is ready
                // Update cache and provide data to processor
                valid_array[index] <= 1'b1;
                tag_array[index] <= tag_in;
                data_array[index] <= MData;
                RD <= MData;
                RDY <= 1'b1;
                MRead <= 1'b0; // Reset memory read signal
            end else begin
                // No read enable and no memory operation
                RDY <= 1'b0;
            end
        end
    end

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