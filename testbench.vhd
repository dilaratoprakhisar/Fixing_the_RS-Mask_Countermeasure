--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:34:38 03/31/2025
-- Design Name:   
-- Module Name:   /users/cosic/dtoprakh/combined_stability/testbench.vhd
-- Project Name:  combined_stability
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AES_S_box
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
library work;
 use work.MPC_globals.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AES_S_box
    PORT(
         clk : IN  std_logic;
         S_in_1 : IN  shared_value;
         S_in_2 : IN  shared_value;
         r : IN  std_logic_vector(161 downto 0);
         S_out_1 : OUT  shared_value;
         S_out_2 : OUT  shared_value
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   --signal S_in_1 : std_logic_vector(0 to 2) := (others => '0');
   --signal S_in_2 : std_logic_vector(0 to 2) := (others => '0');
   signal r : std_logic_vector(161 downto 0) := (others => '0');
	signal Is1_1 : std_logic_vector(7 downto 0) := (others => '0');
   signal Is2_1 : std_logic_vector(7 downto 0) := (others => '0');
   signal Is3_1 : std_logic_vector(7 downto 0) := (others => '0');
	signal Is1_2 : std_logic_vector(7 downto 0) := (others => '0');
   signal Is2_2 : std_logic_vector(7 downto 0) := (others => '0');
   signal Is3_2 : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Os1_1 : std_logic_vector(7 downto 0);
   signal Os2_1 :  std_logic_vector(7 downto 0);
   signal Os3_1 :  std_logic_vector(7 downto 0);
	signal Os1_2 : std_logic_vector(7 downto 0);
   signal Os2_2 :  std_logic_vector(7 downto 0);
   signal Os3_2 :  std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: AES_S_box PORT MAP (
          clk => clk,
          S_in_1(0) => Is1_1,
			 S_in_1(1) => Is2_1,
			 S_in_1(2) => Is3_1,
          S_in_2(0) => Is1_2,
			 S_in_2(1) => Is2_2,
			 S_in_2(2) => Is3_2,
          r => r,
          S_out_1(0) => Os1_1,
			 S_out_1(1) => Os2_1,
			 S_out_1(2) => Os3_1,
          S_out_2(0) => Os1_2,
			 S_out_2(1) => Os2_2,
			 S_out_2(2) => Os3_2
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      Is1_1 <= x"01";
		Is1_2 <= x"01";
wait for clk_period*15;
Is1_1 <= x"02";
Is1_2 <= x"02";
wait for clk_period*15;
Is1_1 <= x"03";
Is1_2 <= x"03";
wait for clk_period*15;
Is1_1 <= x"04";
Is1_2 <= x"04";
wait for clk_period*15;
   end process;

END;
