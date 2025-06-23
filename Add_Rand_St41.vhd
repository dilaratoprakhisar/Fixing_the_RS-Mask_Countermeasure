----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:58:52 07/10/2024 
-- Design Name: 
-- Module Name:    Add_Rand_St4_1 - Behavioral 
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

entity Add_Rand_St41 is
	port(	
		d1, Rand_1, Rand_2 :	in std_logic_vector(1 downto 0);
		Os1 : out std_logic_vector(1 downto 0)
	);
end Add_Rand_St41;

architecture Behavioral of Add_Rand_St41 is



begin
	
	Os1 <= d1 xor Rand_1 xor Rand_2;
	

end Behavioral;



