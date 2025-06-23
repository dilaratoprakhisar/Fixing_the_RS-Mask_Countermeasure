----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:43 12/01/2015 
-- Design Name: 
-- Module Name:    Recomb_St3 - Behavioral 
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

entity Recomb_St6 is
	port(
		St6_Is1, St6_Is2, St6_Is3 : in std_logic_vector(7 downto 0);
		St6_Recombined_Is1 : out std_logic_vector(7 downto 0)
	);
end Recomb_St6;

architecture Behavioral of Recomb_St6 is

begin

	St6_Recombined_Is1 <= St6_Is1 xor St6_Is2 xor St6_Is3;

end Behavioral;

