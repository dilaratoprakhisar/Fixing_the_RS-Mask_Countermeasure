----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: sbox_ph1
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

entity sbox_ph1 is
   port(	
		Is1, Is2, Is3  : in std_logic_vector(7 downto 0);
		Os1, Os2, Os3 	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavior of sbox_ph1 is
	
	component linear_map    -- duplicates entity port
		port(	Xs :	in std_logic_vector(7 downto 0);
				Ys :	out std_logic_vector(7 downto 0) );
	end component linear_map;

begin

	-- Linear Map
	LM1: linear_map
		port map( Is1, Os1 );
	LM2: linear_map
		port map( Is2, Os2 );
	LM3: linear_map
		port map( Is3, Os3 );
		 
end architecture;
