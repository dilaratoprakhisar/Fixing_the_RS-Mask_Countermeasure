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

entity Recomb_St3 is
	port(
		St3_Is1, St3_Is2, St3_Is3 : in std_logic_vector(3 downto 0);
		St3_Recombined_Is1 : out std_logic_vector(3 downto 0)
	);
end Recomb_St3;

architecture Behavioral of Recomb_St3 is

begin

	St3_Recombined_Is1 <= St3_Is1 xor St3_Is2 xor St3_Is3;

end Behavioral;

