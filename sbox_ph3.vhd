----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: sbox_ph3
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

entity sbox_ph3 is
   port(	
		Randomness : in std_logic_vector( 17 downto 0);
		Is1, Is2, Is3 : in std_logic_vector(3 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(1 downto 0)
	);
end entity;

architecture behavior of sbox_ph3 is
	signal c1, c2, c3 : std_logic_vector(1 downto 0);
	signal d1, d2, d3, d4, d5, d6, d7, d8, d9 : std_logic_vector(1 downto 0);
	
	component NxF_St3 
		port(
				Is1 : in std_logic_vector(3 downto 0);
				c1 : out std_logic_vector(1 downto 0)
		);
	end component NxF_St3;

	component GF4_Multiplier_3_9
      port(	Is1, Is2, Is3 : in  std_logic_vector(3 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(1 downto 0)
		);
  end component GF4_Multiplier_3_9;

	component Add_Rand_St3  
		port(	d1, Rand_1, Rand_2 :	in std_logic_vector(1 downto 0);
				Os1 : out std_logic_vector(1 downto 0)
		);
	end component Add_Rand_St3;
	
	component Add_Rand_NxF_St3 
		port(	d1, Rand_1, Rand_2, NxF1 :	in std_logic_vector(1 downto 0);
				Os1 : out std_logic_vector(1 downto 0)
		);
	end component Add_Rand_NxF_St3;

begin	

	NxF1 : NxF_St3
		port map(Is1, c1);
	NxF2 : NxF_St3
		port map(Is2, c2);
	NxF3 : NxF_St3
		port map(Is3, c3);

	GF4_Multiplier : GF4_Multiplier_3_9
		port map( Is1, Is2, Is3, d1, d2, d3, d4, d5, d6, d7, d8, d9 );
			
	Add_Rand_NxF_1: Add_Rand_NxF_St3
		port map(d1, Randomness( 3 downto  2), Randomness( 1 downto  0), c1, Os1 );
	Add_Rand_2: Add_Rand_St3
		port map(d2, Randomness( 5 downto  4), Randomness( 3 downto  2), Os2);
	Add_Rand_3: Add_Rand_St3
		port map(d3, Randomness( 7 downto  6), Randomness( 5 downto  4), Os3);

	Add_Rand_4: Add_Rand_St3
		port map(d4, Randomness( 9 downto  8), Randomness( 7 downto  6), Os4);
	Add_Rand_NxF_2: Add_Rand_NxF_St3
		port map(d5, Randomness(11 downto 10), Randomness( 9 downto  8), c2, Os5 );
	Add_Rand_6: Add_Rand_St3
		port map(d6, Randomness(13 downto 12), Randomness(11 downto 10), Os6);

	Add_Rand_7: Add_Rand_St3
		port map(d7, Randomness(15 downto 14), Randomness(13 downto 12), Os7);
	Add_Rand_9: Add_Rand_St3
		port map(d8, Randomness(17 downto 16), Randomness(15 downto 14), Os8);
	Add_Rand_NxF_3: Add_Rand_NxF_St3
		port map(d9, Randomness( 1 downto  0), Randomness(17 downto 16), c3, Os9 );

end architecture;
