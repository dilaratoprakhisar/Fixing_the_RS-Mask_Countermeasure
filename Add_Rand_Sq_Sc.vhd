----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: Add_Rand_Sq_Sc
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

entity Add_Rand_Sq_Sc is
	port(	
		mult_1, Rand_1, Rand_2, Sq_Sc1 : in std_logic_vector(3 downto 0);
		Os1 : out std_logic_vector(3 downto 0)
	);
end Add_Rand_Sq_Sc;

architecture Behavioral of Add_Rand_Sq_Sc is
begin

	Os1 <= mult_1 xor Sq_Sc1 xor Rand_1 xor Rand_2;
		
end Behavioral;
