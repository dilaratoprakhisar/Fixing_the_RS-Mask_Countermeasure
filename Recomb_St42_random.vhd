----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:12:18 07/12/2024 
-- Design Name: 
-- Module Name:    Recomb_St42_random - Behavioral 
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

entity Recomb_St42_random is
	port(
		St42_Is1, St42_Is2, St42_Is3 : in std_logic_vector(1 downto 0);
		Randomness : in std_logic_vector(3 downto 0);
		St42_Recombined_Is1, St42_Recombined_Is2 : out std_logic_vector(1 downto 0)
	);
end Recomb_St42_random;

architecture Behavioral of Recomb_St42_random is

signal comb : std_logic_vector(1 downto 0);

	component GF4_Mult_Y1   
      port	(	A, B 	:	in std_logic_vector(1 downto 0);
					Y 		:	out std_logic_vector(1 downto 0)
			);
    end component GF4_Mult_Y1;

begin

comb <= St42_Is1 xor St42_Is2 xor St42_Is3;

	M1: GF4_Mult_Y1
		port map( 	comb, Randomness(3 downto 2), St42_Recombined_Is1 );
		
	M2: GF4_Mult_Y1
		port map( 	comb, Randomness(1 downto 0), St42_Recombined_Is2 );

end Behavioral;

