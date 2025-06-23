----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:45:33 07/17/2024 
-- Design Name: 
-- Module Name:    Add_Conc_St42_rand - Behavioral 
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

entity Add_Conc_St42_rand is
port(	
	p1, r1, q1, r2 :	in std_logic_vector(1 downto 0);
	Rand1, Rand2 : in std_logic_vector(3 downto 0);
	Os1 : out std_logic_vector(3 downto 0)
);
end Add_Conc_St42_rand;

architecture Behavioral of Add_Conc_St42_rand is

begin
		Os1 <= ((p1 xor r1) & (q1 xor r2)) xor Rand1 xor Rand2;

end Behavioral;

