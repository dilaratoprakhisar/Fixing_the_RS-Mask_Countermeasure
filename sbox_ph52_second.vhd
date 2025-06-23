----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:  
-- Design Name:  
-- Module Name: sbox_ph52_first
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

entity sbox_ph52_second is
   port(	
		Randomness: in std_logic_vector(71 downto 0);
		Randomness_fix : in std_logic_vector(35 downto 0);
		Is1_Top, Is2_Top, Is3_Top : in std_logic_vector(7 downto 0);
		Is1_Bot, Is2_Bot, Is3_Bot : in std_logic_vector(7 downto 0);
		Is1_fix, Is2_fix, Is3_fix : in std_logic_vector(7 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(7 downto 0);
		Os1_fix, Os2_fix, Os3_fix, Os4_fix, Os5_fix, Os6_fix, Os7_fix, Os8_fix, Os9_fix : out std_logic_vector(3 downto 0)
);
end entity;

architecture behavior of sbox_ph52_second is
	signal p1, p2, p3, p4, p5, p6, p7, p8, p9 : std_logic_vector(3 downto 0);
	signal q1, q2, q3, q4, q5, q6, q7, q8, q9 : std_logic_vector(3 downto 0);
	signal f1, f2, f3, f4, f5, f6, f7, f8, f9 : std_logic_vector(3 downto 0);

	component GF16_Multiplier_3_9
      port(	Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
		);
  end component GF16_Multiplier_3_9;
  
	component Add_Conc_St52_first
		port(	p1, q1 :	in std_logic_vector(3 downto 0);
				Rand1, Rand2 : in std_logic_vector(7 downto 0);
				Os1 : out std_logic_vector(7 downto 0)
		);
	end component Add_Conc_St52_first;
	
	component Add_Rand is
	port(	
		mult_1, Rand_1, Rand_2 : in std_logic_vector(3 downto 0);
		Os1 : out std_logic_vector(3 downto 0)
	);
end component Add_Rand;
	
begin
			
	Top_Multiplier: GF16_Multiplier_3_9
		port map( 	Is1_Top, Is2_Top, Is3_Top,
					   q1, q2, q3, q4, q5, q6, q7, q8, q9 );
	
	Bottom_Multiplier: GF16_multiplier_3_9
		port map( 	Is1_Bot, Is2_Bot, Is3_Bot,
					   p1, p2, p3, p4, p5, p6, p7, p8, p9	);
						
	Fix_Multiplier: GF16_multiplier_3_9
		port map( 	Is1_fix, Is2_fix, Is3_fix,
					   f1, f2, f3, f4, f5, f6, f7, f8, f9	);

	Add_Conc_1 : Add_Conc_St52_first
		port map(p1, q1, Randomness(15 downto  8), Randomness( 7 downto  0), Os1);
	Add_Conc_2 : Add_Conc_St52_first
		port map(p2, q2, Randomness(23 downto 16), Randomness(15 downto  8), Os2);
	Add_Conc_3 : Add_Conc_St52_first
		port map(p3, q3, Randomness(31 downto 24), Randomness(23 downto 16), Os3);  
	Add_Conc_4 : Add_Conc_St52_first
		port map(p4, q4, Randomness(39 downto 32), Randomness(31 downto 24), Os4);
	Add_Conc_5 : Add_Conc_St52_first
		port map(p5, q5, Randomness(47 downto 40), Randomness(39 downto 32), Os5);
	Add_Conc_6 : Add_Conc_St52_first
		port map(p6, q6, Randomness(55 downto 48), Randomness(47 downto 40), Os6);
	Add_Conc_7 : Add_Conc_St52_first
		port map(p7, q7, Randomness(63 downto 56), Randomness(55 downto 48), Os7);  
	Add_Conc_8 : Add_Conc_St52_first
		port map(p8, q8, Randomness(71 downto 64), Randomness(63 downto 56), Os8);
	Add_Conc_9 : Add_Conc_St52_first
		port map(p9, q9, Randomness( 7 downto  0), Randomness(71 downto 64), Os9);
		
		
	Add_Rand_1 : Add_Rand
		port map(f1, Randomness_fix(7 downto  4), Randomness_fix( 3 downto  0), Os1_fix);
	Add_Rand_2 : Add_Rand
		port map(f2, Randomness_fix(11 downto 8), Randomness_fix( 7 downto  4), Os2_fix);
	Add_Rand_3 : Add_Rand
		port map(f3, Randomness_fix(15 downto 12), Randomness_fix(11 downto 8), Os3_fix);  
	Add_Rand_4 : Add_Rand
		port map(f4, Randomness_fix(19 downto 16), Randomness_fix(15 downto 12), Os4_fix);
	Add_Rand_5 : Add_Rand
		port map(f5, Randomness_fix(23 downto 20), Randomness_fix(19 downto 16), Os5_fix);
	Add_Rand_6 : Add_Rand
		port map(f6, Randomness_fix(27 downto 24), Randomness_fix(23 downto 20), Os6_fix);
	Add_Rand_7 : Add_Rand
		port map(f7, Randomness_fix(31 downto 28), Randomness_fix(27 downto 24), Os7_fix);  
	Add_Rand_8 : Add_Rand
		port map(f8, Randomness_fix(35 downto 32), Randomness_fix(31 downto 28), Os8_fix);
	Add_Rand_9 : Add_Rand
		port map(f9, Randomness_fix( 3 downto  0), Randomness_fix(35 downto 32), Os9_fix);
		

end architecture;
