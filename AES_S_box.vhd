----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:49:14 05/03/2017 
-- Design Name: 
-- Module Name:    AES_box_CAPA3 - Behavioral 
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
library work;
 use work.MPC_globals.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_S_box is
	Port ( clk : in  STD_LOGIC;
		  I1, I2, I3 : in  std_logic_vector(7 downto 0);
		  r : in std_logic_vector(271 downto 0);
		  O1, O2, O3: out std_logic_vector(7 downto 0)
	);
end AES_S_box;

architecture Behavioral of AES_S_box is



	--Block to calculate the inverse
	COMPONENT S_box_AES_3_9
		Port (	clk : in std_logic;
					Randomness : in std_logic_vector(271 downto 0);
					Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
				   Os1, Os2, Os3: out std_logic_vector(7 downto 0)
		);
	end COMPONENT;

	COMPONENT Aff_with_tag
	  port (
		 clk : in std_logic;
		 Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
		 Os1, Os2, Os3: out std_logic_vector(7 downto 0)
	  );
	end COMPONENT;

signal Sin_inv_1,Sin_inv_2,Sin_inv_3 : std_logic_vector(7 downto 0);

begin
   
	---------
	--Inverse
	---------
	--CYCLE 1->5
	--Inverse of the Values
	val_inv : S_box_AES_3_9
		--port map(clk => clk, Randomness => r, 
			--		Is1_first => S_in.v(0), Is2_first => S_in.v(1), Is3_first => S_in.v(2), Is1_second => S_in.t(0), Is2_second => S_in.t(1), Is3_second => S_in.t(2),
				--	Os1_first => S_out.v(0), Os2_first => S_out.v(1), Os3_first => S_out.v(2), Os1_second => S_out.t(0), Os2_second => S_out.t(1), Os3_second => S_out.t(2)			
					--);
		port map(clk => clk, Randomness => r, 
					Is1 => I1, Is2 => I2, Is3 => I3,
					Os1 => Sin_inv_1, Os2 => Sin_inv_2, Os3 => Sin_inv_3		
					);

	Affffine : Aff_with_tag
		port map(clk => clk, Is1 => Sin_inv_1, Is2 => Sin_inv_2, Is3 => Sin_inv_3, Os1 => O1, Os2 => O2, Os3 => O3);



end Behavioral;

