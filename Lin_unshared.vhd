----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:21:04 02/22/2017 
-- Design Name: 
-- Module Name:    Aff_unshared - Behavioral 
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

--Calculate Affine transform of x where Lin(x) = 0x05*x + 0x09*x^2 + 
--0xF9*x^4 + 0x25*x^8 + 0xF4*x^16 + 0x01*x^32 + 0xB5*x^64 + 0x8F*x^128
entity Lin_unshared is
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           x_Lin : out  STD_LOGIC_VECTOR (7 downto 0)
           );
end Lin_unshared;

architecture Behavioral of Lin_unshared is

	
begin
				
	x_Lin(7) <= x(7) xor x(6) xor x(5) xor x(4) xor x(3);
	x_Lin(6) <= x(6) xor x(5) xor x(4) xor x(3) xor x(2);
	x_Lin(5) <= x(5) xor x(4) xor x(3) xor x(2) xor x(1);
	x_Lin(4) <= x(4) xor x(3) xor x(2) xor x(1) xor x(0);
	x_Lin(3) <= x(7) xor x(3) xor x(2) xor x(1) xor x(0);
	x_Lin(2) <= x(7) xor x(6) xor x(2) xor x(1) xor x(0);
	x_Lin(1) <= x(7) xor x(6) xor x(5) xor x(1) xor x(0);
	x_Lin(0) <= x(7) xor x(6) xor x(5) xor x(4) xor x(0);
	

end Behavioral;

