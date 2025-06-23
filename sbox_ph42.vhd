----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:  
-- Design Name:  
-- Module Name: sbox_ph42
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

entity sbox_ph42 is
   port(	
		Randomness : in std_logic_vector(3 downto 0); 
		Randomness1 : in std_logic_vector(35 downto 0);
		Is1_Top, Is2_Top, Is3_Top : in std_logic_vector(3 downto 0);
		Is1_Bot, Is2_Bot, Is3_Bot : in std_logic_vector(3 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
);
end entity;

architecture behavior of sbox_ph42 is
	signal p1, p2, p3, p4, p5, p6, p7, p8, p9 : std_logic_vector(1 downto 0);
	signal q1, q2, q3, q4, q5, q6, q7, q8, q9 : std_logic_vector(1 downto 0);

	component GF4_Multiplier_3_9
      port(	Is1, Is2, Is3 : in  std_logic_vector(3 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(1 downto 0)
		);
  end component GF4_Multiplier_3_9;
  
	component Add_Conc_St42 
		port(	p1, q1 :	in std_logic_vector(1 downto 0);
				Rand1, Rand2 : in std_logic_vector(3 downto 0);
				Os1 : out std_logic_vector(3 downto 0)
		);
	end component Add_Conc_St42;
	
	component Add_Conc_St42_rand 
		port(	p1, r1, q1, r2 :	in std_logic_vector(1 downto 0);
				Rand1, Rand2 : in std_logic_vector(3 downto 0);
				Os1 : out std_logic_vector(3 downto 0)
		);
	end component Add_Conc_St42_rand;
	
begin
			
	Top_Multiplier: GF4_Multiplier_3_9
		port map( 	Is1_Top, Is2_Top, Is3_Top,
					   q1, q2, q3, q4, q5, q6, q7, q8, q9 );
	
	Bottom_Multiplier: GF4_multiplier_3_9
		port map( 	Is1_Bot, Is2_Bot, Is3_Bot,
					   p1, p2, p3, p4, p5, p6, p7, p8, p9	);

	Add_Conc_1 : Add_Conc_St42_rand
		port map(p1, Randomness (1 downto 0), q1, Randomness (3 downto 2), Randomness1( 7 downto  4), Randomness1( 3 downto  0), Os1);
	Add_Conc_2 : Add_Conc_St42
		port map(p2, q2, Randomness1(11 downto  8), Randomness1( 7 downto  4), Os2);
	Add_Conc_3 : Add_Conc_St42
		port map(p3, q3, Randomness1(15 downto 12), Randomness1(11 downto  8), Os3);  
	Add_Conc_4 : Add_Conc_St42
		port map(p4, q4, Randomness1(19 downto 16), Randomness1(15 downto 12), Os4);
	Add_Conc_5 : Add_Conc_St42
		port map(p5, q5, Randomness1(23 downto 20), Randomness1(19 downto 16), Os5);
	Add_Conc_6 : Add_Conc_St42
		port map(p6, q6, Randomness1(27 downto 24), Randomness1(23 downto 20), Os6);
	Add_Conc_7 : Add_Conc_St42
		port map(p7, q7, Randomness1(31 downto 28), Randomness1(27 downto 24), Os7);  
	Add_Conc_8 : Add_Conc_St42
		port map(p8, q8, Randomness1(35 downto 32), Randomness1(31 downto 28), Os8);
	Add_Conc_9 : Add_Conc_St42
		port map(p9, q9, Randomness1( 3 downto  0), Randomness1(35 downto 32), Os9);
	 
end architecture;
