----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 	Thomas De Cnudde
-- 
-- Create Date:    13:08:54 11/30/2015 
-- Design Name: 
-- Module Name:    Regs_Shares1 - Behavioral 
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

entity Regs_Shares3 is
	port(
		clk : in std_logic;
		St1_Os1 : in std_logic_vector(1 downto 0);
		St2_Is1 : out std_logic_vector(1 downto 0)
	);
end Regs_Shares3;

architecture Behavioral of Regs_Shares3 is

begin

	process(clk)
	begin
		if rising_edge(clk) then
			St2_Is1 <= St1_Os1; 
		end if;
	end process;


end Behavioral;

