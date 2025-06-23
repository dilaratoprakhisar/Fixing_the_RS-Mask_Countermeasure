----------------------------------------------------------------------------------
-- Company: 
-- Engineer:  Thomas De Cnudde
-- 
-- Create Date: 01/12/2015 
-- Design Name: AES d+1 
-- Module Name: sbox_ph6
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

entity sbox_ph6 is
   port(	
		Is1, Is2, Is3	: in std_logic_vector(7 downto 0);
		Os1, Os2, Os3	: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavior of sbox_ph6 is

--	component inverse_linear_map
--			port(	Xs :	in std_logic_vector(7 downto 0);
--					Ys :	out std_logic_vector(7 downto 0)
--			);
--	end component inverse_linear_map;
--	
--	component inverse_linear_map_no63
--			port(	Xs :	in std_logic_vector(7 downto 0);
--					Ys :	out std_logic_vector(7 downto 0)
--			);
--	end component inverse_linear_map_no63;
	
	component inverse_base_change is
		port(	
			Xs :	in std_logic_vector(7 downto 0);
			Ys :	out std_logic_vector(7 downto 0)
		);
	end component;
begin
	--Calculate affine	
--	ILM1: inverse_linear_map
--		port map(	Is1, Os1 );
--	ILM2: inverse_linear_map_no63
--		port map(	Is2, Os2 );
--	ILM3: inverse_linear_map_no63
--		port map(	Is3, Os3 );

	ILM1: inverse_base_change
		port map(	Is1, Os1 );
	ILM2: inverse_base_change
		port map(	Is2, Os2 );
	ILM3: inverse_base_change
		port map(	Is3, Os3 );
			
end architecture;
