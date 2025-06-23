----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:21 07/09/2024 
-- Design Name: 
-- Module Name:    sbox_ph51 - Behavioral 
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

entity sbox_ph51 is
	port(
				Randomness : in std_logic_vector(35 downto 0);
				Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
);				
end entity;

architecture behaviour of sbox_ph51 is

   signal d1, d2, d3, d4, d5, d6, d7, d8, d9 : std_logic_vector(3 downto 0);

	component GF16_Multiplier_3_9
      port(	Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
		);
  end component GF16_Multiplier_3_9;
  
  
component Add_Rand_15_St51 
	port(	
		d1, Rand_1, Rand_2 : in std_logic_vector(3 downto 0);
		Os1 : out std_logic_vector(3 downto 0)
	);
end component Add_Rand_15_St51;

	component Add_Rand_St51  
		port(	d1, Rand_1, Rand_2 :	in std_logic_vector(3 downto 0);
				Os1 : out std_logic_vector(3 downto 0)
		);
	end component Add_Rand_St51;

begin

	Mult: GF16_Multiplier_3_9
		port map( 	Is1, Is2, Is3,
					   d1, d2, d3, d4, d5, d6, d7, d8, d9 );

							
 
   Add_Rand1_15: Add_Rand_15_St51
		port map(d1, Randomness( 7 downto  4), Randomness( 3 downto  0), Os1);
	Add_Rand2: Add_Rand_St51
		port map(d2, Randomness( 11 downto  8), Randomness( 7 downto  4), Os2);
	Add_Rand3: Add_Rand_St51
		port map(d3, Randomness( 15 downto  12), Randomness( 11 downto  8), Os3);

	Add_Rand4: Add_Rand_St51
		port map(d4, Randomness(19 downto  16), Randomness(15 downto  12), Os4);
	Add_Rand5: Add_Rand_St51
		port map(d5, Randomness(23 downto 20), Randomness(19 downto  16), Os5);
	Add_Rand6: Add_Rand_St51
		port map(d6, Randomness(27 downto 24), Randomness(23 downto 20), Os6);

	Add_Rand7: Add_Rand_St51
		port map(d7, Randomness(31 downto 28), Randomness(27 downto 24), Os7);
	Add_Rand8: Add_Rand_St51
		port map(d8, Randomness(35 downto 32), Randomness(31 downto 28), Os8);
	Add_Rand9: Add_Rand_St51
		port map(d9, Randomness( 3 downto  0), Randomness(35 downto 32), Os9);


end architecture;