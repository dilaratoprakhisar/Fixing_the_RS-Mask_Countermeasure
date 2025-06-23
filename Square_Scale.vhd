----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: Square_Scale
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

entity Square_Scale is
	port(	
		Is1 :	in std_logic_vector(7 downto 0);
		sq_sc1 : out std_logic_vector(3 downto 0)
	);
end Square_Scale;

architecture behavior of Square_Scale is
	signal Is1_ss : std_logic_vector(3 downto 0);
begin

	-- Square Scale
	Is1_ss <= Is1(7 downto 4) xor Is1(3 downto 0);
	sq_sc1 <= (Is1_ss(0) xor Is1_ss(2)) & (Is1_ss(1) xor Is1_ss(3)) & (Is1_ss(0) xor Is1_ss(1)) & (Is1_ss(0));
		
end behavior;
