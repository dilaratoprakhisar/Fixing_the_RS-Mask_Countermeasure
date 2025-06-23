----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:13 07/12/2024 
-- Design Name: 
-- Module Name:    Add_Rand_y16i_St41 - Behavioral 
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

entity Add_Rand_y16i_St41 is
	port(	
		d1, Rand_1, Rand_2, y16i : in std_logic_vector(1 downto 0);
		Os1 : out std_logic_vector(1 downto 0)
	);
end Add_Rand_y16i_St41;

architecture Behavioral of Add_Rand_y16i_St41 is


begin

	Os1 <= d1 xor Rand_1 xor Rand_2 xor y16i;
	

end Behavioral;

