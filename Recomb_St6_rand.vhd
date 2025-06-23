----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:07:42 07/16/2024 
-- Design Name: 
-- Module Name:    Recomb_St6_rand - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Recomb_St6_rand is
	port(
		St6_Is1_second, St6_Is2_second, St6_Is3_second : in std_logic_vector(7 downto 0);
		randomness1, randomness2 : in std_logic_vector(7 downto 0);
		St6_Is1_fix, St6_Is2_fix, St6_Is3_fix : in std_logic_vector(3 downto 0);
		St6_Recombined_Is1 : out std_logic_vector(7 downto 0)
	);

end Recomb_St6_rand;

architecture Behavioral of Recomb_St6_rand is

signal comb1, comb2, comb3 : std_logic_vector(3 downto 0);

	component GF16_Mult_Y1   
      port	(	A, B 	:	in std_logic_vector(3 downto 0);
					Y 		:	out std_logic_vector(3 downto 0)
			);
    end component GF16_Mult_Y1;

begin

comb1 <= St6_Is1_fix xor St6_Is2_fix xor St6_Is3_fix;
	M1: GF16_Mult_Y1
		port map( 	comb1, randomness2(7 downto 4), comb2 );
	M2: GF16_Mult_Y1
		port map( 	comb1, randomness2(3 downto 0), comb3 );
		
St6_Recombined_Is1 <= St6_Is1_second xor St6_Is2_second xor St6_Is3_second xor (randomness1(3 downto 0)&randomness1(7 downto 4)) xor (comb2 & comb3);

end Behavioral;







