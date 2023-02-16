// Jessika Jimenez 
//
// Just the beginnings of a test bench file
// A full test bench should check ALL the hex values
// It might also use "if" statements to make things
// self-checking. That is, instead of just printing
// out the value of z, check to make sure it's at the
// value you expect, and print an error message if 
// it's not. 
//
module stimulus;
  // inputs to the DUT (Device Under Test)
  reg [3:0] x;
  //outputs from the DUT
  wire [6:0] z;

  //instantiate the hex to 7seg circuit
  hexTo7Seg de1soc (
                    .x(x), 
                    .z(z)
                         );

  // Generate the inputs, and check the outputs. 		
  initial begin
  // initialize inputs
  x=0; 
  // then walk through the test cases		
  #20 x=1; $display("x = %b, z = %b", x, z); 
  #20 x=2; $display("x = %b, z = %b", x, z); 
  #20 x=3; $display("x = %b, z = %b", x, z); 
  #20 x=4; $display("x = %b, z = %b", x, z); 
  #20 x=5; $display("x = %b, z = %b", x, z); 
  #20 x=6; $display("x = %b, z = %b", x, z); 
  #20 x=7; $display("x = %b, z = %b", x, z); 
  #20 x=8; $display("x = %b, z = %b", x, z); 
  #20 x=9; $display("x = %b, z = %b", x, z); 
  #20 x=10; $display("x = %b, z = %b", x, z); 
  #20 x=11; $display("x = %b, z = %b", x, z); 
  #20 x=12; $display("x = %b, z = %b", x, z); 
  #20 x=13; $display("x = %b, z = %b", x, z); 
  #20 x=14; $display("x = %b, z = %b", x, z); 
  #20 x=15; $display("x = %b, z = %b", x, z); 
  #20 x=16; $display("x = %b, z = %b", x, z); 
  end
	
endmodule
