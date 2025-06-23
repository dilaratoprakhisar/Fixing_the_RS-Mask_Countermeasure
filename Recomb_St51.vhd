----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:43 12/01/2015 
-- Design Name: 
-- Module Name:    Recomb_St51 - Behavioral 
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

entity Recomb_St51 is
	port(
		St51_Is1, St51_Is2, St51_Is3 : in std_logic_vector(3 downto 0);
		St51_Recombined_Is1 : out std_logic_vector(3 downto 0)
	);
end Recomb_St51;

architecture Behavioral of Recomb_St51 is

begin

	St51_Recombined_Is1 <= St51_Is1 xor St51_Is2 xor St51_Is3;

end Behavioral;

