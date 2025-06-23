----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: NxF_St3
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

entity NxF_St3 is
	port(	
		Is1 : in std_logic_vector(3 downto 0);
		c1 : out std_logic_vector(1 downto 0)
	);
end NxF_St3;

architecture Behavioral of NxF_St3 is

	signal a1, b1 : std_logic_vector(1 downto 0);

begin
	a1 <= Is1(3 downto 2) xor Is1(1 downto 0);
	
	b1 <= a1(0) & a1(1);
	
	c1 <= b1(0) & (b1(1) xor b1(0));
	
end Behavioral;
