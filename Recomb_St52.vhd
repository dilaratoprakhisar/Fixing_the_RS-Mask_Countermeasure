----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:06:05 07/16/2024 
-- Design Name: 
-- Module Name:    Recomb_St52 - Behavioral 
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

entity Recomb_St52 is
	port(
		St52_Is1, St52_Is2, St52_Is3 : in std_logic_vector(3 downto 0);
		Randomness : in std_logic_vector(7 downto 0);
		y, yinv : in std_logic_vector(3 downto 0);
		St52_Recombined_Is1_yr1, St52_Recombined_Is1_yr2, St52_Recombined_Is1_yinv, St52_Recombined_Is1_yyinv15  : out std_logic_vector(3 downto 0)
	);
end Recomb_St52;

architecture Behavioral of Recomb_St52 is

signal comb, comb1 : std_logic_vector(3 downto 0);

	component GF16_Mult_Y1   
      port	(	A, B 	:	in std_logic_vector(3 downto 0);
					Y 		:	out std_logic_vector(3 downto 0)
			);
    end component GF16_Mult_Y1;

begin

comb <= St52_Is1 xor St52_Is2 xor St52_Is3;

St52_Recombined_Is1_yyinv15 <= comb;

comb1 <= comb xor y;

M1: GF16_Mult_Y1
	port map(comb1, Randomness(7 downto 4), St52_Recombined_Is1_yr1);
	
M2: GF16_Mult_Y1
	port map(comb1, Randomness(3 downto 0), St52_Recombined_Is1_yr2);

	St52_Recombined_Is1_yinv <= comb xor yinv;

end Behavioral;