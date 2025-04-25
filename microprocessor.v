////////////////////////////////////////////////////[ALU]//////////////////////////////////////////////////
//Lana Musaffer 1210455
module alu (opcode, a, b, result);
  input [5:0] opcode;
  input signed [31:0] a, b;
  output reg signed [31:0] result;

  always @(*)
	  begin
	  case (opcode)
	    // opcode = 3 --> a+b (addition)
	    6'b000011: result = a + b;

	    // opcode = 15 --> a-b (subtraction)
	    6'b001111: result = a - b;

	    // opcode = 13 --> |a| (the absolute value of a)
	    6'b001101: if (a < 0)
	                  result = -$signed(a);
	                else
	                  result = a;

	    // opcode = 12 --> negate the value of a
	    6'b001100: result = -$signed(a);

	    // opcode = 7 --> max(a, b) (the maximum of a and b)
	    6'b000111: if (a > b)
	                  result = a;
	                else
	                  result = b;

	    // opcode = 1 --> min(a, b) (the minimum of a and b)
	    6'b000001: if (a < b)
	                  result = a;
	                else
	                  result = b;

	    // opcode = 9 --> avg(a,b)
		//(the average of a and b �> the integer part only and remainder is ignored)
	    6'b001001: result = (a + b) / 2;

	    // opcode = 10 --> not a
	    6'b001010: result = ~a;

	    // opcode = 14 --> a or b
	    6'b001110: result = (a | b);

	    // opcode = 11 --> a and b
	    6'b001011: result = (a & b);

	    // opcode = 5 --> a xor b
	    6'b000101: result = (a ^ b);

	    // INVALID OPCODE
	    default: begin
	              $display("INVALID OPCODE! %b", opcode);
	              result = result;
	             end
	  endcase
	end

endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module alu_tb;
  reg [5:0] opcode;
  reg signed [31:0] a, b;
  wire signed [31:0] result;

  alu ALU(opcode, a, b, result);

  reg clk = 0;
  always #5 clk = ~clk;

  initial begin
    $monitor("TIME=%0t OPCODE=%b A=%d B=%d RESULT=%d", $time, opcode, a, b, result);

    // ADDITION TEST
    opcode = 6'b000011;
    a = 10;
    b = 5;
    #10;

    // SUBTRACTION TEST
    opcode = 6'b001111;
    a = -20;
    b = 8;
    #10;

    // ABSOLUTE TEST
    opcode = 6'b001101;
    a = -15;
    b = 0;
    #10;

    // INVERSE TEST
    opcode = 6'b001100;
    a = -15;
    b = 0;
    #10;

    // MAX TEST
    opcode = 6'b000111;
    a = 4;
    b = -9;
    #10;

    // MIN TEST
    opcode = 6'b000001;
    a = 8;
    b = -4;
    #10;

    // AVERAGE TEST
    opcode = 6'b001001;
    a = 7;
    b = 7;
    #10;

    // BIT-WISE NOT TEST
    opcode = 6'b001010;
    a = 7;
    b = 0;
    #10;

    // BIT-WISE OR TEST
    opcode = 6'b001110;
    a = 5;
    b = 4;
    #10;

    // BIT-WISE AND TEST
    opcode = 6'b001011;
    a = 5;
    b = 4;
    #10;

    // BIT-WISE XOR TEST
    opcode = 6'b000101;
    a = 5;
    b = 4;
    #10;

	// INVALID TEST
    opcode = 6'b111111;
    a = 0;
    b = 0;
    #10;

    $finish;
  end
endmodule

//////////////////////////////////////////////[REG_FILE]////////////////////////////////////////////////////
//Lana Musaffer 1210455
module reg_file (clk, valid_opcode, addr1, addr2, addr3, in , out1, out2);
	input clk;
	input valid_opcode;
	input [4:0] addr1, addr2, addr3;
	input [31:0] in;
	output reg [31:0] out1, out2;

	//INITIALE DATA
	reg [31:0] mem [0:31] = '{32'h00000000, 32'h00002E9A, 32'h000014E4, 32'h00001C8C, 32'h00003D44, 32'h0000303A, 32'h000025F4,
		32'h00001E8C, 32'h00001446, 32'h0000396E, 32'h000015FE, 32'h00000930, 32'h00003C40, 32'h00000A6E, 32'h0000104C,
		32'h000010CC, 32'h00001288, 32'h00000506, 32'h00001FBA, 32'h000011CE, 32'h00002156, 32'h0000341C, 32'h00001B06,
		32'h00002DB4, 32'h000029E2, 32'h00000D12, 32'h00000CE4, 32'h00000952, 32'h00002BCC, 32'h00000DB0, 32'h00002208,
		32'h00000000};

	//When the enable input=1 the register file will operate normally.
	//Otherwise the register file will ignore its inputs, and will not update its outputs.
	always@(posedge clk)
		begin
			if(valid_opcode)
			  begin
				//Input is used to supply a value that is written into the location addressed by Address 3 --> Write operation
				mem[addr3] <= in;

				//Out1 produces the item within the register file that is address by Address 1 --> Read Operation
				out1 <= mem[addr1];

				//Out2 produces the item within the register file that is address by Address 2 --> Read Operation
				out2 <= mem[addr2];
			  end

		end
endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module regFile_tb;

  reg clk;
  reg valid_opcode;
  reg [4:0] addr1, addr2, addr3;
  reg [31:0] in;
  wire [31:0] out1, out2;

  reg_file RF(clk, valid_opcode, addr1, addr2, addr3, in, out1, out2);

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test
    initial begin
        // Test Case 1: Read operation with valid_opcode
		valid_opcode = 1;
		addr1 = 5'b00100; // address 4
		addr2 = 5'b01000; // address 8
		#10;
		if (valid_opcode)
		  $display("Test Case 1: out1 = %h, out2 = %h", out1, out2);  //out1=value at address 4, out2=value at address 8
		else
		  $display("Test Case 1: Invalid opcode");

		// Test Case 2: Write operation with valid_opcode
		valid_opcode = 1;
		addr3 = 5'b01100; // address 12
		in = 32'h0000000A;
		#10;
		if (valid_opcode)
		  $display("Test Case 2: DATA = %h", in);  //in=data written in address 12
		else
		  $display("Test Case 2: Invalid opcode");

		// Test Case 3: Read operation with invalid_opcode
		valid_opcode = 0;
		addr1 = 5'b00110; // address 6
		addr2 = 5'b01010; // address 10
		#10;
		if (valid_opcode)
		  $display("INVALID OPCODE");
		else
		  $display("Test Case 3: Invalid opcode");

		// Test Case 4: Write operation with invalid_opcode
		valid_opcode = 0;
		addr3 = 5'b01111; // address 15
		in = 32'h000000AA;
		#10;
		if (valid_opcode)
		  $display("INVALID OPCODE");
		else
		  $display("Test Case 4: Invalid opcode");


        // Finish the simulation
        #10 $finish;
    end

endmodule
///////////////////////////////////////////////[MP_TOP]//////////////////////////////////////////////////////////////
//Lana Musaffer 1210455
module mp_top (clk, instruction , result );
	input clk;
	input [31:0] instruction;
	output reg signed [31:0] result;

	reg [5:0] opcode;  //The first 6 bits identify the opcode
	reg [4:0] addr1, addr2, addr3;
	reg [31:0] out1, out2;
	reg [31:0] instructionUnused;
    reg [5:0] valid_opcode;

	//Extract opcode from instruction, then check if opcode is valid
	always @(posedge clk) begin
		opcode = instruction[5:0];
	    valid_opcode = (opcode == 6'b000011) || (opcode == 6'b001111) || (opcode == 6'b001101) || (opcode == 6'b001100) ||
                        (opcode == 6'b000111) || (opcode == 6'b000001) || (opcode == 6'b001001) || (opcode == 6'b001010) ||
                        (opcode == 6'b001110) || (opcode == 6'b001011) || (opcode == 6'b000101);

		if(valid_opcode) begin
			addr1 = instruction[10:6];	  //The next 5 bits identify first source register
			addr2 = instruction[15:11];	  //The next 5 bits identify second source register
			addr3 =	instruction[20:16];	  //The next 5 bits identify destination register
			instructionUnused = instruction;  //To unused bits in instruction for later use
			instructionUnused[31:21] = 0;   //The final 11 bits are unused
		end
	end

	reg_file Reg(clk, valid_opcode, addr1, addr2, addr3, result, out1, out2);  //CONNECT THE REGISTER FILE FIRST

	alu MyAlu(instruction[5:0], out1, out2, result); //CONNECT THE ALU MODULE
endmodule

////////////////////////////////////////////////////////////////////////////////////////////
//Lana Musaffer 1210455
module mp_top_tb;

  reg clk;
  reg [31:0] instruction;
  wire signed [31:0] result;

  reg test_failed;  //Flag to indicate test failure
  reg [5:0] opcode = instruction[5:0];

  //Instantiate the mp_top module
  mp_top MP_TOP(clk, instruction, result);

	//Clock generation
	initial begin
	   clk = 0;
	   forever #5 clk = ~clk;
	end

	//task for delays
    task DELAY;
	  #20;
	endtask

	//calculate the expected value of maximum value
	function [31:0] maxVALUE(input [31:0] a, input [31:0] b);
	    if (a > b)
	        maxVALUE = a;
	    else
	        maxVALUE = b;
	endfunction

	//calculate the expected value of minimum value
	function [31:0] minVALUE(input [31:0] a, input [31:0] b);
	    if (a < b)
	        minVALUE = a;
	    else
	        minVALUE = b;
	endfunction

    reg [31:0] instructions [0:14];    //Define an array of instructions

	/************************ARRAY OF INSTRUCTIONS****************************/
	initial begin
		instructions[0] = 32'b00000000000_00000_00001_00000_100001;  // INVALID OPCODE
	    instructions[1]  = 32'b00000000000_11111_00001_00000_000011;  // ADDITION; RESULT = VALUE AT ADDR0 + VALUE AT ADDR1
	    instructions[2]  = 32'b00000000000_00000_00001_00000_001111;  // SUBTRACTION; RESULT = VALUE AT ADDR0 - VALUE AT ADDR1
	    instructions[3]  = 32'b00000000000_00000_00000_00001_001101;  // ABSOLUTE; RESULT = VALUE AT ADDR1
	    instructions[4]  = 32'b00000000000_00000_00000_00001_001100;  // NEGATIVE; RESULT = - VALUE AT ADDR1
	    instructions[5]  = 32'b00000000000_11111_00001_00000_000111;  // MAX; RESULT = MAX(VALUE AT ADDR0,VALUE AT ADDR1)
	    instructions[6]  = 32'b00000000000_00000_00001_00011_000001;  // MIN; RESULT = MIN(VALUE AT ADDR3,VALUE AT ADDR1)
	    instructions[7]  = 32'b00000000000_00000_00101_00100_001001;  // AVERAGE; RESULT = (VALUE AT ADDR4 + VALUE AT ADDR5)/2
	    instructions[8]  = 32'b00000000000_00000_00000_00001_001010;  // NOT; RESULT = ~VALUE AT ADDR1
	    instructions[9]  = 32'b00000000000_00000_01011_01010_001110;  // ORR; RESULT = VALUE AT ADDR10 | VALUE AT ADDR11
	    instructions[10]  = 32'b00000000000_00000_00111_00110_001011;  // AND; RESULT = VALUE AT ADDR6 & VALUE AT ADDR7
	    instructions[11] = 32'b00000000000_00000_01001_01000_000101;  // XOR; RESULT = VALUE AT ADDR8 | VALUE AT ADDR9
	    instructions[12] = 32'b00000000000_00000_00001_00000_111111;  // INVALID OPCODE; RESULT = LAST RESULT
	end

	  /************************START THE TEST****************************/
	  initial begin
		  test_failed = 0;  // Initialize the flag

		// Iterate through all tests
	    for (int test_num = 0; test_num <= 12; test_num = test_num + 1) begin
	      instruction = instructions[test_num];

	      // Check for invalid opcode in Test 0
	      if (test_num == 0 && instruction[5:0] !== (opcode == 6'b000011) || (opcode == 6'b001111) || (opcode == 6'b001101) ||
			  (opcode == 6'b001100) || (opcode == 6'b000111) || (opcode == 6'b000001) || (opcode == 6'b001001) ||
			  (opcode == 6'b001010) || (opcode == 6'b001110) || (opcode == 6'b001011) || (opcode == 6'b000101))
			  begin
		        DELAY;
		        if (result == 32'h00000000) begin
		          $display("Test %0d FAILED!, instruction = %b, result = %h", test_num, instruction, result);
		        end
	      end

		/************************************************************************************/
		// TEST CASE 0: INVALID OPCODE
		if (test_num == 0) begin  // RESULT IS NOT DEFINED
		 	DELAY;
			if (instruction[5:0] === 6'b100001) begin
				$display("Test 0 FAILED! instruction= %b, result = %h", instruction, result);
				test_failed = 0;  // Set the flag to indicate failure
		    end
		end
		/************************************************************************************/
	    //TEST CASE 1: ADDITION --> OPCODE = 3
	    if (test_num == 1) begin
	        DELAY;
	        if (result !== (32'h00002E9A + 32'h00000000)) begin
	          $display("Test 1 FAILED! Expected: %h, Got: %h", (32'h00002E9A + 32'h00000000), result);
	          test_failed = 1;  // Set the flag to indicate failure
	        end else begin
	          $display("Test 1 PASSED!, instruction= %b, result = %h", instruction, result);
	        end
		end

		/***********************************************************************************************/

	    //TEST CASE 2: SUBTRACTION --> OPCODE = 15
	    if (test_num == 2) begin
		 	DELAY;
			if (result !== (32'h00000000 - 32'h00002E9A)) begin
				$display("Test 2 FAILED! Expected: %h, Got: %h", (32'h00000000 - 32'h00002E9A), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 2 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/***********************************************************************************************/

		//TEST CASE 3: ABSOLUTE --> OPCODE = 13
	    if (test_num == 3) begin
		 	DELAY;
			if (result !== (32'h00002E9A)) begin
				$display("Test 3 FAILED! Expected: %h, Got: %h", (32'h00002E9A), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 3 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/***********************************************************************************************/

		//TEST CASE 4: NEGATIVE --> OPCODE = 12
		if (test_num == 4) begin
		 	DELAY;
			if (result !== -$signed(32'h00002E9A)) begin
				$display("Test 4 FAILED! Expected: %h, Got: %h", -$signed(32'h00002E9A), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 4 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/***********************************************************************************************/

		//TEST CASE 5: MAX --> OPCODE = 7
		if (test_num == 5) begin
		 	DELAY;
			if (result !== maxVALUE(32'h00002E9A, 32'h00000000)) begin
				$display("Test 5 FAILED! Expected: %h, Got: %h", maxVALUE(32'h00002E9A, 32'h00000000), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin  $display("Test 5 PASSED!, instruction = %b, result = %h", instruction, result);
			end
		end
		/*********************************************************************************************/

		//TEST CASE 6: MIN --> OPCODE = 1
		if (test_num == 6) begin
		 	DELAY;
			if (result !== minVALUE(32'h00002E9A, 32'h00001C8C)) begin
				$display("Test 6 FAILED! Expected: %h, Got: %h", minVALUE(32'h00002E9A, 32'h00001C8C), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin  $display("Test 6 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/*********************************************************************************************/

		//TEST CASE 7: AVERAGE --> OPCODE = 9
		if (test_num == 7) begin
		 	DELAY;
			if (result !== ((32'h00003D44 + 32'h0000303A)/32'h00000002)) begin
				$display("Test 7 FAILED! Expected: %h, Got: %h", ((32'h00003D44 + 32'h0000303A)/32'h00000002), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 7 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/*********************************************************************************************/

		 //TEST CASE 8: NOT --> OPCODE = 10
		if (test_num == 8) begin
		 	DELAY;
			if (result !== (~(32'h00002E9A))) begin
				$display("Test 8 FAILED! Expected: %h, Got: %h", (~(32'h00002E9A)), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 8 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/*********************************************************************************************/

		//TEST CASE 9: ORR --> OPCODE = 14
		if (test_num == 9) begin
		 	DELAY;
			if (result !== (32'h000015FE | 32'h00000930)) begin
				$display("Test 9 FAILED! Expected: %h, Got: %h", (32'h000015FE | 32'h00000930), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 9 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/*********************************************************************************************/

		 //TEST CASE 10: AND --> OPCODE = 11
		if (test_num == 10) begin
		 	DELAY;
			if (result !== (32'h000025F4 & 32'h00001E8C)) begin
				$display("Test 10 FAILED! Expected: %h, Got: %h", (32'h000025F4 & 32'h00001E8C), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 10 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/*********************************************************************************************/

		//TEST CASE 11: XOR --> OPCODE = 5
		if (test_num == 11) begin
		 	DELAY;
			if (result !== (32'h00001446 ^ 32'h0000396E)) begin
				$display("Test 11 FAILED! Expected: %h, Got: %h", (32'h00001446 ^ 32'h0000396E), result);
				test_failed = 1;  // Set the flag to indicate failure
		    end else begin $display("Test 11 PASSED!, instruction= %b, result = %h", instruction, result);
			end
		end
		/*********************************************************************************************/

		// TEST CASE 12: INVALID OPCODE
		if (test_num == 12) begin
		 	DELAY;
			if (instruction[5:0] === 6'b111111) begin
				$display("Test 12 FAILED! instruction= %b, result = %h", instruction, result);
				test_failed = 0;  // Set the flag to indicate failure
		    end
		end
		/*********************************************************************************************/
	 end

    //Check if any test failed
    if (test_failed == 1) begin
		$display("SIMULATION PASSED: ALL TESTS PASSED");
    end else begin
      	$display("SIMULATION FAILED: SOME TESTS DID NOT PASS");
    end

    //FINISH SIMULATION
    #10 $finish;
  end

endmodule