----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: Add_Conc_St4
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

entity Add_Conc_St42 is
port(	
	p1, q1 :	in std_logic_vector(1 downto 0);
	Rand1, Rand2 : in std_logic_vector(3 downto 0);
	Os1 : out std_logic_vector(3 downto 0)
);
end Add_Conc_St42;

architecture Behavioral of Add_Conc_St42 is
begin
		Os1 <= ((p1) & (q1)) xor Rand1 xor Rand2;
end Behavioral;
