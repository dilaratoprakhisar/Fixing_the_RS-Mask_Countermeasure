----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:50:21 07/09/2024 
-- Design Name: 
-- Module Name:    sbox_ph41 - Behavioral 
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

entity sbox_ph41 is
	port(
				Randomness1, Randomness2 : in std_logic_vector(17 downto 0);
				Is1_first, Is2_first, Is3_first : in std_logic_vector(3 downto 0);
				Is1_second, Is2_second, Is3_second : in std_logic_vector(3 downto 0);
				y16_1, y16_2, y16_3 : in std_logic_vector(1 downto 0); --y16
				i_1, i_2, i_3 : in std_logic_vector(1 downto 0);
				Os1_first, Os2_first, Os3_first, Os4_first, Os5_first, Os6_first, Os7_first, Os8_first, Os9_first : out std_logic_vector(1 downto 0);
				Os1_second, Os2_second, Os3_second, Os4_second, Os5_second, Os6_second, Os7_second, Os8_second, Os9_second : out std_logic_vector(1 downto 0)
);				
end entity;

architecture behaviour of sbox_ph41 is
   signal temp1, temp2 : std_logic_vector(1 downto 0);
   signal d1, d2, d3, d4, d5, d6, d7, d8, d9 : std_logic_vector(1 downto 0);
	signal d10, d11, d12, d13, d14, d15, d16, d17, d18 : std_logic_vector(1 downto 0);

	component GF4_Multiplier_3_9
      port(	Is1, Is2, Is3 : in  std_logic_vector(3 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(1 downto 0)
		);
  end component GF4_Multiplier_3_9;
  
  
component Add_Rand_y16i_St41 
	port(	
		d1, Rand_1, Rand_2, y16i : in std_logic_vector(1 downto 0);
		Os1 : out std_logic_vector(1 downto 0)
	);
end component Add_Rand_y16i_St41;

	component Add_Rand_St41  
		port(	d1, Rand_1, Rand_2 :	in std_logic_vector(1 downto 0);
				Os1 : out std_logic_vector(1 downto 0)
		);
	end component Add_Rand_St41;

begin
   temp1 <= y16_1 xor "11";
	temp2 <= i_1 xor "11";

	First_Multiplier: GF4_Multiplier_3_9
		port map( 	Is1_first, Is2_first, Is3_first,
					   d1, d2, d3, d4, d5, d6, d7, d8, d9 );
	
	Second_Multiplier: GF4_multiplier_3_9
		port map( 	Is1_second, Is2_second, Is3_second,
					   d10, d11, d12, d13, d14, d15, d16, d17, d18);
							
 
   Add_Rand_y16_1_first: Add_Rand_y16i_St41
		port map(d1, Randomness1( 3 downto  2), Randomness1( 1 downto  0), temp1, Os1_first);
	Add_Rand_2_first: Add_Rand_St41
		port map(d2, Randomness1( 5 downto  4), Randomness1( 3 downto  2), Os2_first);
	Add_Rand_3_first: Add_Rand_St41
		port map(d3, Randomness1( 7 downto  6), Randomness1( 5 downto  4), Os3_first);

	Add_Rand_4_first: Add_Rand_St41
		port map(d4, Randomness1( 9 downto  8), Randomness1( 7 downto  6), Os4_first);
	Add_Rand_y16_2_first: Add_Rand_y16i_St41
		port map(d5, Randomness1(11 downto 10), Randomness1( 9 downto  8), y16_2, Os5_first );
	Add_Rand_6_first: Add_Rand_St41
		port map(d6, Randomness1(13 downto 12), Randomness1(11 downto 10), Os6_first);

	Add_Rand_7_first: Add_Rand_St41
		port map(d7, Randomness1(15 downto 14), Randomness1(13 downto 12), Os7_first);
	Add_Rand_9_first: Add_Rand_St41
		port map(d8, Randomness1(17 downto 16), Randomness1(15 downto 14), Os8_first);
	Add_Rand_y16_3_first: Add_Rand_y16i_St41
		port map(d9, Randomness1( 1 downto  0), Randomness1(17 downto 16), y16_3, Os9_first );

	Add_Rand_i_1_second: Add_Rand_y16i_St41
		port map(d10, Randomness2( 3 downto  2), Randomness2( 1 downto  0), temp2, Os1_second );
	Add_Rand_2_second: Add_Rand_St41
		port map(d11, Randomness2( 5 downto  4), Randomness2( 3 downto  2), Os2_second);
	Add_Rand_3_second: Add_Rand_St41
		port map(d12, Randomness2( 7 downto  6), Randomness2( 5 downto  4), Os3_second);

	Add_Rand_4_second: Add_Rand_St41
		port map(d13, Randomness2( 9 downto  8), Randomness2( 7 downto  6), Os4_second);
	Add_Rand_i_2_second: Add_Rand_y16i_St41
		port map(d14, Randomness2(11 downto 10), Randomness2( 9 downto  8), i_2, Os5_second );
	Add_Rand_6_second: Add_Rand_St41
		port map(d15, Randomness2(13 downto 12), Randomness2(11 downto 10), Os6_second);

	Add_Rand_7_second: Add_Rand_St41
		port map(d16, Randomness2(15 downto 14), Randomness2(13 downto 12), Os7_second);
	Add_Rand_9_second: Add_Rand_St41
		port map(d17, Randomness2(17 downto 16), Randomness2(15 downto 14), Os8_second);
	Add_Rand_i_3_second: Add_Rand_y16i_St41
		port map(d18, Randomness2( 1 downto  0), Randomness2(17 downto 16), i_3, Os9_second );

end architecture;

