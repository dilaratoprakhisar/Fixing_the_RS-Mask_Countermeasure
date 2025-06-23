----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: GF16_Multiplier_3_9
-- Project Name: 
-- Target Devices:
-- Tool versions:
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- unsigned datatype is not used
--use ieee.numeric_std.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF16_Multiplier_3_9 is
	port(	
		Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
	);
end GF16_Multiplier_3_9;

architecture behavior of GF16_Multiplier_3_9 is
	
	signal Xs1, Ys1, Xs2, Ys2, Xs3, Ys3 : std_logic_vector(3 downto 0);
  	component GF16_Mult_Y1    
      port	(	A, B 	:	in std_logic_vector(3 downto 0);
					Y 		:	out std_logic_vector(3 downto 0)
		);
   end component GF16_Mult_Y1;
	

begin	 
 	
	Xs1 <= Is1(7 downto 4);
	Ys1 <= Is1(3 downto 0);
	Xs2 <= Is2(7 downto 4);
	Ys2 <= Is2(3 downto 0);
	Xs3 <= Is3(7 downto 4);
	Ys3 <= Is3(3 downto 0);
	
	Multiplier_1 : GF16_Mult_Y1
			port map( 	Xs1, Ys1,
							Os1);
	Multiplier_2 : GF16_Mult_Y1
			port map( 	Xs1, Ys2,
							Os2);
	Multiplier_3 : GF16_Mult_Y1
			port map( 	Xs1, Ys3,
							Os3);
							
	Multiplier_4 : GF16_Mult_Y1
			port map( 	Xs2, Ys1,
							Os4);
	Multiplier_5 : GF16_Mult_Y1
			port map( 	Xs2, Ys2,
							Os5);
	Multiplier_6 : GF16_Mult_Y1
			port map( 	Xs2, Ys3,
							Os6);
							
	Multiplier_7 : GF16_Mult_Y1
			port map( 	Xs3, Ys1,
							Os7);
	Multiplier_8 : GF16_Mult_Y1
			port map( 	Xs3, Ys2,
							Os8);
	Multiplier_9 : GF16_Mult_Y1
			port map( 	Xs3, Ys3,
							Os9);
		
end behavior;