----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: sbox_ph2
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

entity sbox_ph2 is
   port(	Randomness : in std_logic_vector(35 downto 0);
			Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
			Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)	
	);
end entity;

architecture behavior of sbox_ph2 is

	signal sq_sc1, sq_sc2, sq_sc3 : std_logic_vector(3 downto 0);
	signal mult_1, mult_2, mult_3, mult_4, mult_5, mult_6, mult_7, mult_8, mult_9 : std_logic_vector(3 downto 0);
	
	component Square_Scale 
		port (
			Is1 		:	in std_logic_vector(7 downto 0);
			sq_sc1 	:  out std_logic_vector(3 downto 0)			
		);
	end component Square_Scale;
	
	component GF16_Multiplier_3_9
		port(	
			Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
			Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
		);
	end component GF16_Multiplier_3_9;

	component Add_Rand -- 
		port(	mult_1, Rand_1, Rand_2 : in std_logic_vector(3 downto 0);
				Os1 : out std_logic_vector(3 downto 0)
		);
	end component Add_Rand;
	
	component Add_Rand_Sq_Sc --
		port(	mult_1, Rand_1, Rand_2, Sq_Sc1 :	in std_logic_vector(3 downto 0);
				Os1 : out std_logic_vector(3 downto 0)
		);
	end component Add_Rand_Sq_Sc;

begin
	
	-- GF16 Square Scale
	Sq_Sc_1: Square_Scale
		port map( Is1, sq_sc1);
	Sq_Sc_2: Square_Scale
		port map( Is2, sq_sc2);
	Sq_Sc_3: Square_Scale
		port map( Is3, sq_sc3);
	
	-- GF16 Multiplier
	GF16_Multiplier: GF16_Multiplier_3_9
		port map( Is1, Is2, Is3, mult_1, mult_2, mult_3, mult_4, mult_5, mult_6, mult_7, mult_8, mult_9 );
	
		
	Add_Rand_Sq_Sc_1: Add_Rand_Sq_Sc
		port map(mult_1, Randomness(  7 downto   4), Randomness(  3 downto  0), sq_sc1, Os1 );
	Add_Rand_2: Add_Rand
		port map(mult_2, Randomness( 11 downto   8), Randomness(  7 downto  4), Os2);
	Add_Rand_3: Add_Rand
		port map(mult_3, Randomness( 15 downto  12), Randomness( 11 downto  8), Os3);
	
	Add_Rand_4: Add_Rand
		port map(mult_4, Randomness( 19 downto  16), Randomness( 15 downto  12), Os4 );
	Add_Rand_Sq_Sc_2: Add_Rand_Sq_Sc
		port map(mult_5, Randomness( 23 downto  20), Randomness( 19 downto  16), sq_sc2, Os5 );
	Add_Rand_6: Add_Rand
		port map(mult_6, Randomness( 27 downto  24), Randomness( 23 downto  20), Os6);
	
	Add_Rand_7: Add_Rand
		port map(mult_7, Randomness( 31 downto  28), Randomness( 27 downto  24), Os7);
	Add_Rand_8: Add_Rand
		port map(mult_8, Randomness( 35 downto  32), Randomness( 31 downto  28), Os8 );
	Add_Rand_Sq_Sc_3: Add_Rand_Sq_Sc
		port map(mult_9, Randomness(  3 downto   0), Randomness( 35 downto  32), sq_sc3, Os9 );
	
end architecture;
