----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:33:40 05/18/2016 
-- Design Name: 
-- Module Name:    Keccak_p200 - Behavioral 
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
use ieee.numeric_std.all;

library work;
 use work.keccak_globals.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Keccak_p800 is
    Port ( start, clk, rst : in std_logic;
			  seed : in STD_LOGIC_VECTOR (39 downto 0);
           s_out_r : out  STD_LOGIC_VECTOR (799 downto 0);
			  rand_unreg : out STD_LOGIC_VECTOR (31 downto 0)
			);
end Keccak_p800;

architecture Behavioral of Keccak_p800 is
		
	component keccak_round_constants_gen
		 port( round_number: in unsigned(4 downto 0);
					round_constant_signal_out    : out std_logic_vector(31 downto 0));
	end component;
	
	component keccak_round 
		 port ( round_in     : in  k_state;
				  round_constant_signal    : in std_logic_vector(31 downto 0);
				  round_out    : out k_state);
	end component;

	signal round_next, round_out, round_reg, round_init : k_state;
	signal ready_int, ready_reg : std_logic;--Handle value for ready
	signal round: unsigned(4 downto 0);
	signal n_round : unsigned (4 downto 0);
	signal round_cntnt : STD_LOGIC_VECTOR (31 downto 0);
	
	signal s_init : STD_LOGIC_VECTOR (799 downto 0);
	
begin
	
	s_init <= (799 downto 40 => '0') & seed;
	
	init1: for y in 0 to 4 generate
		init2: for x in 0 to 4 generate
			init3: for i in 0 to 3 generate
				init4: for z in 0 to 7 generate
			
					round_init(y)(x)(8*i+z) <= s_init((32*5*(4-y))+(32*(4-x))+8*(3-i)+z); 
														
				end generate;
			end generate;	
		end generate;
	end generate;
	
	
	--Load state or assign the previous step
	i1: for y in 0 to 4 generate
		i2: for x in 0 to 4 generate
			i3: for i in 0 to 3 generate
				i4: for z in 0 to 7 generate
			
					round_next(y)(x)(8*i+z) <= round_out(y)(x)(8*i+z) when start='1' else 
														round_reg(y)(x)(8*i+z);
				end generate;
			end generate;	
		end generate;
	end generate;
	
	--Count rounds
	n_round <= round+1 when (start = '1' and (round <= 21)) else 
				round;
	
		
	--Compute Keccak

	Kecc_cntnt:	component keccak_round_constants_gen
						port map( round_number => round, round_constant_signal_out => round_cntnt);
	Kecc_round:	component keccak_round 
						port map( round_in => round_reg, round_constant_signal => round_cntnt, round_out => round_out);



	F_proc : process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				round <=  (others => '0');
				round_reg <= round_init;
			else
				round <= n_round;
				round_reg <= round_next;
			end if;
		end if;
	end process;	
	
	--Output
	o002: for x in 0 to 4 generate
		o002: for i in 0 to 3 generate
			o003: for z in 0 to 7 generate
				s_out_r(32*(4-x)+8*(3-i)+z+640)<= round_reg(0)(x)(8*i+z);-- when (ready_reg = '1') else '0';

				s_out_r(32*(4-x)+8*(3-i)+z+480)<= round_reg(1)(x)(8*i+z);-- when (ready_reg = '1') else '0';

				s_out_r(32*(4-x)+8*(3-i)+z+320)<= round_reg(2)(x)(8*i+z);--  when (ready_reg = '1') else '0';

				s_out_r(32*(4-x)+8*(3-i)+z+160)<= round_reg(3)(x)(8*i+z);--  when (ready_reg = '1') else '0';

				s_out_r(32*(4-x)+8*(3-i)+z)<= round_reg(4)(x)(8*i+z);--     when (ready_reg = '1') else '0';
				
				-- Artemii new addition to output rand without a reg
				rand_unreg(8*(3-i)+z)<= round_next(0)(0)(8*i+z);
			end generate;
		end generate;
	end generate;
end Behavioral;

