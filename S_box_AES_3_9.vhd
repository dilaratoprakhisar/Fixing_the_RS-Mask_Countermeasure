----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    
-- Design Name: 
-- Module Name:    S_box_AES_3_9 - Behavioral 
-- Project Name: d+1 Sbox 2nd Order
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

entity S_box_AES_3_9 is
   Port (	clk : in std_logic;
				Randomness : in std_logic_vector(271 downto 0);
				Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
				Os1, Os2, Os3 : out std_logic_vector(7 downto 0)
	);
end S_box_AES_3_9;

architecture Behavioral of S_box_AES_3_9 is
	-- Randomness
	--signal St2_Randomness_first : std_logic_vector(35 downto 0);
	--signal St2_Randomness_second : std_logic_vector(35 downto 0);
	signal St2_Randomness : std_logic_vector(35 downto 0);	
		
		
	--signal St3_Randomness_first : std_logic_vector(17 downto 0);
	--signal St3_Randomness_second : std_logic_vector(17 downto 0);
	signal St3_Randomness : std_logic_vector(17 downto 0);
	
	signal St41_Randomness_first : std_logic_vector(17 downto 0);
	--signal St41_Randomness_second : std_logic_vector(17 downto 0);
	
        signal St42_Randomness : std_logic_vector(3 downto 0);
	signal St42_Randomness_first : std_logic_vector(35 downto 0);

        signal St51_Randomness : std_logic_vector(35 downto 0);
	
	signal St52_1_Randomness : std_logic_vector(7 downto 0);
	signal St52_Randomness_first : std_logic_vector(71 downto 0);
	signal St52_Randomness_fix : std_logic_vector(35 downto 0);
	
	signal Randomness_St6_fix : std_logic_vector(7 downto 0);

	
	-- Output Signals
	signal St1_Os1, St1_Os2, St1_Os3 : std_logic_vector(7 downto 0);
	
	signal St2_Os1_first, St2_Os2_first, St2_Os3_first, St2_Os4_first, St2_Os5_first, St2_Os6_first, St2_Os7_first, St2_Os8_first, St2_Os9_first : std_logic_vector(3 downto 0);
	signal St2_Os1_second, St2_Os2_second, St2_Os3_second, St2_Os4_second, St2_Os5_second, St2_Os6_second, St2_Os7_second, St2_Os8_second, St2_Os9_second : std_logic_vector(3 downto 0);
		
        signal St3_Os1_first, St3_Os2_first, St3_Os3_first, St3_Os4_first, St3_Os5_first, St3_Os6_first, St3_Os7_first, St3_Os8_first, St3_Os9_first : std_logic_vector(1 downto 0);
	signal St3_Os1_second, St3_Os2_second, St3_Os3_second, St3_Os4_second, St3_Os5_second, St3_Os6_second, St3_Os7_second, St3_Os8_second, St3_Os9_second : std_logic_vector(1 downto 0);	
				
	signal St41_Os1_first, St41_Os2_first, St41_Os3_first, St41_Os4_first, St41_Os5_first, St41_Os6_first, St41_Os7_first, St41_Os8_first, St41_Os9_first : std_logic_vector(1 downto 0);
	signal St41_Os1_second, St41_Os2_second, St41_Os3_second, St41_Os4_second, St41_Os5_second, St41_Os6_second, St41_Os7_second, St41_Os8_second, St41_Os9_second : std_logic_vector(1 downto 0);

	signal St42_Os1, St42_Os2, St42_Os3, St42_Os4, St42_Os5, St42_Os6, St42_Os7, St42_Os8, St42_Os9 : std_logic_vector(3 downto 0);

	signal St51_Os1, St51_Os2, St51_Os3, St51_Os4, St51_Os5, St51_Os6, St51_Os7, St51_Os8, St51_Os9 : std_logic_vector(3 downto 0);

	signal St52_Os1, St52_Os2, St52_Os3, St52_Os4, St52_Os5, St52_Os6, St52_Os7, St52_Os8, St52_Os9 : std_logic_vector(7 downto 0);
	signal St52_Os1_fix, St52_Os2_fix, St52_Os3_fix, St52_Os4_fix, St52_Os5_fix, St52_Os6_fix, St52_Os7_fix, St52_Os8_fix, St52_Os9_fix : std_logic_vector(3 downto 0);
	
	-- Register Output Signals
	signal St2_Is1, St2_Is2, St2_Is3 : std_logic_vector(7 downto 0);
		
	signal St3_Is1_first, St3_Is2_first, St3_Is3_first, St3_Is4_first, St3_Is5_first, St3_Is6_first, St3_Is7_first, St3_Is8_first, St3_Is9_first : std_logic_vector(3 downto 0);
	signal St3_Is1_second, St3_Is2_second, St3_Is3_second, St3_Is4_second, St3_Is5_second, St3_Is6_second, St3_Is7_second, St3_Is8_second, St3_Is9_second : std_logic_vector(3 downto 0);
	
	signal St41_Is1_first, St41_Is2_first, St41_Is3_first, St41_Is4_first, St41_Is5_first, St41_Is6_first, St41_Is7_first, St41_Is8_first, St41_Is9_first : std_logic_vector(1 downto 0);
	signal St41_Is1_second, St41_Is2_second, St41_Is3_second, St41_Is4_second, St41_Is5_second, St41_Is6_second, St41_Is7_second, St41_Is8_second, St41_Is9_second : std_logic_vector(1 downto 0);
	
	signal St42_Is1_first, St42_Is2_first, St42_Is3_first, St42_Is4_first, St42_Is5_first, St42_Is6_first, St42_Is7_first, St42_Is8_first, St42_Is9_first : std_logic_vector(1 downto 0);
	signal St42_Is1_second, St42_Is2_second, St42_Is3_second, St42_Is4_second, St42_Is5_second, St42_Is6_second, St42_Is7_second, St42_Is8_second, St42_Is9_second : std_logic_vector(1 downto 0);

	signal St51_Is1, St51_Is2, St51_Is3, St51_Is4, St51_Is5, St51_Is6, St51_Is7, St51_Is8, St51_Is9 : std_logic_vector(3 downto 0);

	signal St52_Is1, St52_Is2, St52_Is3, St52_Is4, St52_Is5, St52_Is6, St52_Is7, St52_Is8, St52_Is9 : std_logic_vector(3 downto 0);
	
	signal St6_Is1, St6_Is2, St6_Is3, St6_Is4, St6_Is5, St6_Is6, St6_Is7, St6_Is8, St6_Is9 : std_logic_vector(7 downto 0);
	signal St6_Is1_fix, St6_Is2_fix, St6_Is3_fix, St6_Is4_fix, St6_Is5_fix, St6_Is6_fix, St6_Is7_fix, St6_Is8_fix, St6_Is9_fix : std_logic_vector(3 downto 0);

	-- Hull Registers
	signal St3_Is_top1_x, St3_Is_top2_x, St3_Is_top3_x, St3_Is_bottom1_x, St3_Is_bottom2_x, St3_Is_bottom3_x : std_logic_vector(3 downto 0);  
		
	signal St41_Is_Top1_x, St41_Is_Top2_x, St41_Is_Top3_x, St41_Is_Bottom1_x, St41_Is_Bottom2_x, St41_Is_Bottom3_x : std_logic_vector(3 downto 0);
	signal St41_Is_Top1_ef, St41_Is_Top2_ef, St41_Is_Top3_ef, St41_Is_Bottom1_ef, St41_Is_Bottom2_ef, St41_Is_Bottom3_ef : std_logic_vector(1 downto 0); 
	signal St41_y256_1, St41_y256_2, St41_y256_3 : std_logic_vector(3 downto 0);

	signal St42_Is_Top1_x, St42_Is_Top2_x, St42_Is_Top3_x, St42_Is_Bottom1_x, St42_Is_Bottom2_x, St42_Is_Bottom3_x : std_logic_vector(3 downto 0);
	signal St42_Is_Top1_ef, St42_Is_Top2_ef, St42_Is_Top3_ef, St42_Is_Bottom1_ef, St42_Is_Bottom2_ef, St42_Is_Bottom3_ef : std_logic_vector(1 downto 0); 
	signal St42_y256_1, St42_y256_2, St42_y256_3 : std_logic_vector(3 downto 0);

	signal St51_Is_Top1_x, St51_Is_Top2_x, St51_Is_Top3_x, St51_Is_Bottom1_x, St51_Is_Bottom2_x, St51_Is_Bottom3_x : std_logic_vector(3 downto 0);	
	signal St51_y256_1, St51_y256_2, St51_y256_3 : std_logic_vector(3 downto 0);

	signal St52_Is_Top1_x, St52_Is_Top2_x, St52_Is_Top3_x, St52_Is_Bottom1_x, St52_Is_Bottom2_x, St52_Is_Bottom3_x : std_logic_vector(3 downto 0);
	signal St52_l16_1, St52_l16_2, St52_l16_3 : std_logic_vector(3 downto 0);
	signal St52_y256_1, St52_y256_2, St52_y256_3 : std_logic_vector(3 downto 0);
	
	signal S1_St42_Randomness, S2_St42_Randomness, S3_St42_Randomness, S41_St42_Randomness : std_logic_vector(3 downto 0);
	signal S1_St52_1_Randomness, S2_St52_1_Randomness, S3_St52_1_Randomness, S41_St52_1_Randomness, S42_St52_1_Randomness, S51_St52_1_Randomness, S52_St52_1_Randomness : std_logic_vector(7 downto 0);
	signal S1_Randomness_St6_fix, S2_Randomness_St6_fix, S3_Randomness_St6_fix, S41_Randomness_St6_fix, S42_Randomness_St6_fix, S51_Randomness_St6_fix, S52_Randomness_St6_fix : std_logic_vector(7 downto 0);
	
	-- Recombined Signals
	signal St3_Recombined_Is1_first, St3_Recombined_Is2_first, St3_Recombined_Is3_first : std_logic_vector(3 downto 0);
	signal St3_Recombined_Is1_second, St3_Recombined_Is2_second, St3_Recombined_Is3_second : std_logic_vector(3 downto 0);
	
	signal St41_Recombined_Is1_first, St41_Recombined_Is2_first, St41_Recombined_Is3_first : std_logic_vector(1 downto 0);
	signal St41_Recombined_Is1_second, St41_Recombined_Is2_second, St41_Recombined_Is3_second : std_logic_vector(1 downto 0);
	signal St41_Recombined_Is1_Inv, St41_Recombined_Is2_Inv, St41_Recombined_Is3_Inv : std_logic_vector(1 downto 0);

	signal St42_Recombined_Is1_first_e, St42_Recombined_Is2_first_e, St42_Recombined_Is3_first_e : std_logic_vector(1 downto 0);
	signal St42_Recombined_Is1_first_f, St42_Recombined_Is2_first_f, St42_Recombined_Is3_first_f : std_logic_vector(1 downto 0);
	signal St42_Recombined_Is1_second, St42_Recombined_Is2_second, St42_Recombined_Is3_second : std_logic_vector(1 downto 0);

	signal St51_Recombined_Is1, St51_Recombined_Is2, St51_Recombined_Is3 : std_logic_vector(3 downto 0);

	signal St52_Recombined_Is1_yr1, St52_Recombined_Is2_yr1, St52_Recombined_Is3_yr1 : std_logic_vector(3 downto 0);
	signal St52_Recombined_Is1_yr2, St52_Recombined_Is2_yr2, St52_Recombined_Is3_yr2 : std_logic_vector(3 downto 0);
	signal St52_Recombined_Is1_yinv, St52_Recombined_Is2_yinv, St52_Recombined_Is3_yinv : std_logic_vector(3 downto 0);
	signal St52_Recombined_Is1_yyinv15, St52_Recombined_Is2_yyinv15, St52_Recombined_Is3_yyinv15 : std_logic_vector(3 downto 0);
	
        signal St6_Recombined_Is1, St6_Recombined_Is2, St6_Recombined_Is3 : std_logic_vector(7 downto 0);
	

	-- Multiplier Inputs 
        signal St41_Recombined_y16i1_first, St41_Recombined_y16i2_first, St41_Recombined_y16i3_first, St41_Recombined_y16i1_second, St41_Recombined_y16i2_second, St41_Recombined_y16i3_second : std_logic_vector(3 downto 0);

	signal St42_Recombined_eyinv1, St42_Recombined_eyinv2, St42_Recombined_eyinv3, St42_Recombined_fyinv1, St42_Recombined_fyinv2, St42_Recombined_fyinv3 : std_logic_vector(3 downto 0);

	signal St51_Is1_y256l16, St51_Is2_y256l16, St51_Is3_y256l16 : std_logic_vector(7 downto 0);

	signal St52_Is1_xinv1, St52_Is2_xinv1, St52_Is3_xinv1, St52_Is1_xinv2, St52_Is2_xinv2, St52_Is3_xinv2 : std_logic_vector(7 downto 0);
	signal St52_Is1_fix, St52_Is2_fix, St52_Is3_fix  : std_logic_vector(7 downto 0);

	
	--component St4_Concat
		--port(
			--St4_Is_Top_lvl2_1, St4_Recombined_Is1_Inv : in std_logic_vector(1 downto 0);
			--St4_Recombined_Is_Top1 : out std_logic_vector(3 downto 0)
		--);
	--end component;
	
	--component St5_Concat
		--port(
			--St5_Is_Top1, St5_Recombined_Is1 : in std_logic_vector(3 downto 0);
			--St5_Is1_Top : out std_logic_vector(7 downto 0)
		--);
	--end component;
	
	component Recomb_St3
		port(
			St3_Is1, St3_Is2, St3_Is3 : in std_logic_vector(3 downto 0);
			St3_Recombined_Is1 : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component Recomb_St41
		port(
			St41_Is1, St41_Is2, St41_Is3 : in std_logic_vector(1 downto 0);
			St41_Recombined_Is1 : out std_logic_vector(1 downto 0)
		);
	end component;
	
	component Recomb_St42
		port(
			St42_Is1, St42_Is2, St42_Is3 : in std_logic_vector(1 downto 0);
			St42_Recombined_Is1 : out std_logic_vector(1 downto 0)
		);
	end component;
	
	
   component Recomb_St42_random is
	   port(
		   St42_Is1, St42_Is2, St42_Is3 : in std_logic_vector(1 downto 0);
		   Randomness : in std_logic_vector(3 downto 0);
		   St42_Recombined_Is1,St42_Recombined_Is2: out std_logic_vector(1 downto 0)
	   );
   end component;
   

	
	component Recomb_St51
		port(
			St51_Is1, St51_Is2, St51_Is3 : in std_logic_vector(3 downto 0);
			St51_Recombined_Is1 : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component Recomb_St52 is
	   port(
		   St52_Is1, St52_Is2, St52_Is3 : in std_logic_vector(3 downto 0);
		   Randomness : in std_logic_vector(7 downto 0);
		   y, yinv : in std_logic_vector(3 downto 0);
		   St52_Recombined_Is1_yr1, St52_Recombined_Is1_yr2, St52_Recombined_Is1_yinv, St52_Recombined_Is1_yyinv15  : out std_logic_vector(3 downto 0)
	   );
   end component;
	
	component Recomb_St6
		port(
			St6_Is1, St6_Is2, St6_Is3 : in std_logic_vector(7 downto 0);
			St6_Recombined_Is1 : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component Recomb_St6_rand is
	   port(
		St6_Is1_second, St6_Is2_second, St6_Is3_second : in std_logic_vector(7 downto 0);
		randomness1, randomness2 : in std_logic_vector(7 downto 0);
		St6_Is1_fix, St6_Is2_fix, St6_Is3_fix : in std_logic_vector(3 downto 0);
		St6_Recombined_Is1 : out std_logic_vector(7 downto 0)
	   );

   end component;
	
	-- 8 bit register
	component Regs_Shares1
		port(
			clk : in std_logic;
			St1_Os1 : in std_logic_vector(7 downto 0);
			St2_Is1 : out std_logic_vector(7 downto 0)
		);
	end component Regs_Shares1;
	-- 4 bit register
	component Regs_Shares2
		port(
			clk : in std_logic;
			St1_Os1 : in std_logic_vector(3 downto 0);
			St2_Is1 : out std_logic_vector(3 downto 0)
		);
	end component Regs_Shares2;
	-- 2 bit register
	component Regs_Shares3
		port(
			clk : in std_logic;
			St1_Os1 : in std_logic_vector(1 downto 0);
			St2_Is1 : out std_logic_vector(1 downto 0)
		);
	end component Regs_Shares3;
	
	component sbox_ph1
		port(	Is1, Is2, Is3  : in std_logic_vector(7 downto 0);
				Os1, Os2, Os3 	: out std_logic_vector(7 downto 0) 
		);
	end component sbox_ph1;
	
	component sbox_ph2
		port(	Randomness : in std_logic_vector(35 downto 0);
				Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)	
		);
	end component sbox_ph2;
	
	component sbox_ph3
		port(	
		Randomness : in std_logic_vector( 17 downto 0);
		Is1, Is2, Is3 : in std_logic_vector(3 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(1 downto 0)
		);
	end component sbox_ph3;
	
	
	component sbox_ph41
		port(	
		Randomness1, Randomness2 : in std_logic_vector(17 downto 0);
		Is1_first, Is2_first, Is3_first : in std_logic_vector(3 downto 0);
		Is1_second, Is2_second, Is3_second : in std_logic_vector(3 downto 0);
		y16_1, y16_2, y16_3 : in std_logic_vector(1 downto 0); --y16
		i_1, i_2, i_3 : in std_logic_vector(1 downto 0);
		Os1_first, Os2_first, Os3_first, Os4_first, Os5_first, Os6_first, Os7_first, Os8_first, Os9_first : out std_logic_vector(1 downto 0);
		Os1_second, Os2_second, Os3_second, Os4_second, Os5_second, Os6_second, Os7_second, Os8_second, Os9_second : out std_logic_vector(1 downto 0)
	
		);
	end component sbox_ph41;

	
	component sbox_ph42
		port(	
		Randomness : in std_logic_vector(3 downto 0); 
		Randomness1 : in std_logic_vector(35 downto 0);
		Is1_Top, Is2_Top, Is3_Top : in std_logic_vector(3 downto 0);
		Is1_Bot, Is2_Bot, Is3_Bot : in std_logic_vector(3 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
		);
	end component sbox_ph42;
	

component sbox_ph51 is
	port(
				Randomness : in std_logic_vector(35 downto 0);
				Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
);				
end component sbox_ph51;

component sbox_ph52_second is
   port(	
		Randomness: in std_logic_vector(71 downto 0);
		Randomness_fix : in std_logic_vector(35 downto 0);
		Is1_Top, Is2_Top, Is3_Top : in std_logic_vector(7 downto 0);
		Is1_Bot, Is2_Bot, Is3_Bot : in std_logic_vector(7 downto 0);
		Is1_fix, Is2_fix, Is3_fix : in std_logic_vector(7 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(7 downto 0);
		Os1_fix, Os2_fix, Os3_fix, Os4_fix, Os5_fix, Os6_fix, Os7_fix, Os8_fix, Os9_fix : out std_logic_vector(3 downto 0)
);		

end component sbox_ph52_second;
	
	component sbox_ph6
		port(	
		Is1, Is2, Is3	: in std_logic_vector(7 downto 0);
		Os1, Os2, Os3	: out std_logic_vector(7 downto 0)
		);
	end component sbox_ph6;
	
	
	component GF4_Multiplier_3_9
      port(	Is1, Is2, Is3 : in  std_logic_vector(3 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(1 downto 0)
		);
  end component GF4_Multiplier_3_9;
	
begin
	-- Assign Randomness
--St2_Randomness_first <= Randomness(343 downto 308);   --36 bits
--St2_Randomness_second <= Randomness(307 downto 272); --36 bits

St2_Randomness <= Randomness(271 downto 236); --36 bits   

--St3_Randomness_first <= Randomness(271 downto 254); --18 bits
--St3_Randomness_second <= Randomness(253 downto 236); --18 bits

St3_Randomness <= Randomness(235 downto 218); --18 bits

St41_Randomness_first <= Randomness(217 downto 200); --18 bits
--St41_Randomness_second <= Randomness(217 downto 200); --18 bits
    
St42_Randomness <= Randomness(199 downto 196); --4 bits      -- CONSTANT
St42_Randomness_first <= Randomness(195 downto 160); --36 bits

St51_Randomness <= Randomness(159 downto 124); --36 bits  

St52_1_Randomness <= Randomness(123 downto 116); --8 bits   -- CONSTANT 
St52_Randomness_first  <= Randomness(115 downto 44); --72 bits
St52_Randomness_fix <= Randomness(43 downto 8); --36 bits  

Randomness_St6_fix <= Randomness(7 downto 0); --8 bits -- CONSTANT
	
	--
	-- Stage 1
	--
	Stage1_Register_S1 : Regs_Shares1
		port map (clk, St1_Os1, St2_Is1);
	Stage1_Register_S2 : Regs_Shares1
		port map (clk, St1_Os2, St2_Is2);
	Stage1_Register_S3 : Regs_Shares1
		port map (clk, St1_Os3, St2_Is3);	
	Stage1_first : sbox_ph1
		port map ( Is1, Is2, Is3, St1_Os1, St1_Os2, St1_Os3);
		
	Stage1_St42_Randomness: Regs_Shares2
		port map (clk, St42_Randomness, S1_St42_Randomness);	
	Stage1_St52_1_Randomness: Regs_Shares1
		port map (clk, St52_1_Randomness, S1_St52_1_Randomness);
   Stage1_Randomness_St6_fix: Regs_Shares1
		port map (clk, Randomness_St6_fix, S1_Randomness_St6_fix);		
	--
	-- Stage 2
	--
	Stage2_first : sbox_ph2
		port map ( St2_Randomness, St2_Is1, St2_Is2, St2_Is3, St2_Os1_first, St2_Os2_first, St2_Os3_first, St2_Os4_first, St2_Os5_first, St2_Os6_first, St2_Os7_first, St2_Os8_first, St2_Os9_first );
	Stage2_Register_S1_first : Regs_Shares2
		port map (clk, St2_Os1_first, St3_Is1_first);
	Stage2_Register_S2_first : Regs_Shares2
		port map (clk, St2_Os2_first, St3_Is2_first);
	Stage2_Register_S3_first : Regs_Shares2
		port map (clk, St2_Os3_first, St3_Is3_first);
	Stage2_Register_S4_first : Regs_Shares2
		port map (clk, St2_Os4_first, St3_Is4_first);
	Stage2_Register_S5_first : Regs_Shares2
		port map (clk, St2_Os5_first, St3_Is5_first);
	Stage2_Register_S6_first : Regs_Shares2
		port map (clk, St2_Os6_first, St3_Is6_first);
	Stage2_Register_S7_first : Regs_Shares2
		port map (clk, St2_Os7_first, St3_Is7_first);
	Stage2_Register_S8_first : Regs_Shares2
		port map (clk, St2_Os8_first, St3_Is8_first);
	Stage2_Register_S9_first : Regs_Shares2
		port map (clk, St2_Os9_first, St3_Is9_first);
		
	Stage2_second : sbox_ph2
		port map ( St2_Randomness, St2_Is1, St2_Is2, St2_Is3, St2_Os1_second, St2_Os2_second, St2_Os3_second, St2_Os4_second, St2_Os5_second, St2_Os6_second, St2_Os7_second, St2_Os8_second, St2_Os9_second );
	Stage2_Register_S1_second : Regs_Shares2
		port map (clk, St2_Os1_second, St3_Is1_second);
	Stage2_Register_S2_second : Regs_Shares2
		port map (clk, St2_Os2_second, St3_Is2_second);
	Stage2_Register_S3_second : Regs_Shares2
		port map (clk, St2_Os3_second, St3_Is3_second);
	Stage2_Register_S4_second : Regs_Shares2
		port map (clk, St2_Os4_second, St3_Is4_second);
	Stage2_Register_S5_second : Regs_Shares2
		port map (clk, St2_Os5_second, St3_Is5_second);
	Stage2_Register_S6_second : Regs_Shares2
		port map (clk, St2_Os6_second, St3_Is6_second);
	Stage2_Register_S7_second : Regs_Shares2
		port map (clk, St2_Os7_second, St3_Is7_second);
	Stage2_Register_S8_second : Regs_Shares2
		port map (clk, St2_Os8_second, St3_Is8_second);
	Stage2_Register_S9_second : Regs_Shares2
		port map (clk, St2_Os9_second, St3_Is9_second);	
		
	Stage2_Register_S_Top1_x : Regs_Shares2
		port map (clk, St2_Is1(7 downto 4), St3_Is_Top1_x);
	Stage2_Register_S_Top2_x : Regs_Shares2
		port map (clk, St2_Is2(7 downto 4), St3_Is_Top2_x);
	Stage2_Register_S_Top3_x : Regs_Shares2
		port map (clk, St2_Is3(7 downto 4), St3_Is_Top3_x);
	Stage2_Register_S_Bot1_x : Regs_Shares2
		port map (clk, St2_Is1(3 downto 0), St3_Is_Bottom1_x);
	Stage2_Register_S_Bot2_x : Regs_Shares2
		port map (clk, St2_Is2(3 downto 0), St3_Is_Bottom2_x);
	Stage2_Register_S_Bot3_x : Regs_Shares2
		port map (clk, St2_Is3(3 downto 0), St3_Is_Bottom3_x);
	
	Stage2_St42_Randomness: Regs_Shares2
		port map (clk, S1_St42_Randomness, S2_St42_Randomness);	
	Stage2_St52_1_Randomness: Regs_Shares1
		port map (clk, S1_St52_1_Randomness, S2_St52_1_Randomness);
   Stage2_Randomness_St6_fix: Regs_Shares1
		port map (clk, S1_Randomness_St6_fix, S2_Randomness_St6_fix);		

	--
	-- Stage 3
	--
	-- dc
	Stage3_Recombination1_first : Recomb_St3
		port map (St3_Is1_first, St3_Is2_first, St3_Is3_first, St3_Recombined_Is1_first);
	Stage3_Recombination2_first : Recomb_St3
		port map (St3_Is4_first, St3_Is5_first, St3_Is6_first, St3_Recombined_Is2_first);
	Stage3_Recombination3_first : Recomb_St3
		port map (St3_Is7_first, St3_Is8_first, St3_Is9_first, St3_Recombined_Is3_first);
		
	-- y256	
	Stage3_Recombination1_second : Recomb_St3
		port map (St3_Is1_second, St3_Is2_second, St3_Is3_second, St3_Recombined_Is1_second);
	Stage3_Recombination2_second : Recomb_St3
		port map (St3_Is4_second, St3_Is5_second, St3_Is6_second, St3_Recombined_Is2_second);
	Stage3_Recombination3_second : Recomb_St3
		port map (St3_Is7_second, St3_Is8_second, St3_Is9_second, St3_Recombined_Is3_second);
		
	
	Stage3_first : sbox_ph3 --g+h
		port map ( St3_Randomness, St3_Recombined_Is1_first, St3_Recombined_Is2_first, St3_Recombined_Is3_first, St3_Os1_first, St3_Os2_first, St3_Os3_first, St3_Os4_first, St3_Os5_first, St3_Os6_first, St3_Os7_first, St3_Os8_first, St3_Os9_first);
	Stage3_Register_S1_first : Regs_Shares3
		port map (clk, St3_Os1_first, St41_Is1_first);
	Stage3_Register_S2_first : Regs_Shares3
		port map (clk, St3_Os2_first, St41_Is2_first);
	Stage3_Register_S3_first : Regs_Shares3
		port map (clk, St3_Os3_first, St41_Is3_first);
	Stage3_Register_S4_first : Regs_Shares3
		port map (clk, St3_Os4_first, St41_Is4_first);
	Stage3_Register_S5_first : Regs_Shares3
		port map (clk, St3_Os5_first, St41_Is5_first);
	Stage3_Register_S6_first : Regs_Shares3
		port map (clk, St3_Os6_first, St41_Is6_first);
	Stage3_Register_S7_first : Regs_Shares3
		port map (clk, St3_Os7_first, St41_Is7_first);
	Stage3_Register_S8_first : Regs_Shares3
		port map (clk, St3_Os8_first, St41_Is8_first);
	Stage3_Register_S9_first : Regs_Shares3
		port map (clk, St3_Os9_first, St41_Is9_first);
		
	
	Stage3_second : sbox_ph3 --y16
		port map ( St3_Randomness, St3_Recombined_Is1_first, St3_Recombined_Is2_first, St3_Recombined_Is3_first, St3_Os1_second, St3_Os2_second, St3_Os3_second, St3_Os4_second, St3_Os5_second, St3_Os6_second, St3_Os7_second, St3_Os8_second, St3_Os9_second);
	Stage3_Register_S1_second : Regs_Shares3
		port map (clk, St3_Os1_second, St41_Is1_second);
	Stage3_Register_S2_second : Regs_Shares3
		port map (clk, St3_Os2_second, St41_Is2_second);
	Stage3_Register_S3_second : Regs_Shares3
		port map (clk, St3_Os3_second, St41_Is3_second);
	Stage3_Register_S4_second : Regs_Shares3
		port map (clk, St3_Os4_second, St41_Is4_second);
	Stage3_Register_S5_second : Regs_Shares3
		port map (clk, St3_Os5_second, St41_Is5_second);
	Stage3_Register_S6_second : Regs_Shares3
		port map (clk, St3_Os6_second, St41_Is6_second);
	Stage3_Register_S7_second : Regs_Shares3
		port map (clk, St3_Os7_second, St41_Is7_second);
	Stage3_Register_S8_second : Regs_Shares3
		port map (clk, St3_Os8_second, St41_Is8_second);
	Stage3_Register_S9_second : Regs_Shares3
		port map (clk, St3_Os9_second, St41_Is9_second);
	
	Stage3_Register_S_Top1_x : Regs_Shares2
		port map (clk, St3_Is_Top1_x, St41_Is_Top1_x);
	Stage3_Register_S_Top2_x : Regs_Shares2
		port map (clk, St3_Is_Top2_x, St41_Is_Top2_x);
	Stage3_Register_S_Top3_x : Regs_Shares2
		port map (clk, St3_Is_Top3_x, St41_Is_Top3_x);
	Stage3_Register_S_Bot1_x : Regs_Shares2
		port map (clk, St3_Is_Bottom1_x, St41_Is_Bottom1_x);
	Stage3_Register_S_Bot2_x : Regs_Shares2
		port map (clk, St3_Is_Bottom2_x, St41_Is_Bottom2_x);
	Stage3_Register_S_Bot3_x : Regs_Shares2
		port map (clk, St3_Is_Bottom3_x, St41_Is_Bottom3_x);	


	Stage3_Register_S_Top1_ef : Regs_Shares3
		port map (clk, St3_Recombined_Is1_first(3 downto 2), St41_Is_Top1_ef);
	Stage3_Register_S_Top2_ef : Regs_Shares3
		port map (clk, St3_Recombined_Is2_first(3 downto 2), St41_Is_Top2_ef);
	Stage3_Register_S_Top3_ef : Regs_Shares3
		port map (clk, St3_Recombined_Is3_first(3 downto 2), St41_Is_Top3_ef);
	Stage3_Register_S_Bot1_ef : Regs_Shares3
		port map (clk, St3_Recombined_Is1_first(1 downto 0), St41_Is_Bottom1_ef);
	Stage3_Register_S_Bot2_ef : Regs_Shares3
		port map (clk, St3_Recombined_Is2_first(1 downto 0), St41_Is_Bottom2_ef);
	Stage3_Register_S_Bot3_ef : Regs_Shares3
		port map (clk, St3_Recombined_Is3_first(1 downto 0), St41_Is_Bottom3_ef);
		

	Stage3_Register_S_y256_1 : Regs_Shares2
		port map (clk, St3_Recombined_Is1_second, St41_y256_1);
	Stage3_Register_S_y256_2 : Regs_Shares2
		port map (clk, St3_Recombined_Is2_second, St41_y256_2);
	Stage3_Register_S_y256_3 : Regs_Shares2
		port map (clk, St3_Recombined_Is3_second, St41_y256_3);

	Stage3_St42_Randomness: Regs_Shares2
		port map (clk, S2_St42_Randomness, S3_St42_Randomness);	
	Stage3_St52_1_Randomness: Regs_Shares1
		port map (clk, S2_St52_1_Randomness, S3_St52_1_Randomness);
   Stage3_Randomness_St6_fix: Regs_Shares1
		port map (clk, S2_Randomness_St6_fix, S3_Randomness_St6_fix);		

	--
	-- Stage 41
	--
	
	St41_Recombined_y16i1_first <= St41_Recombined_Is1_second & St41_Recombined_Is1_Inv;
	
	St41_Recombined_y16i2_first <= St41_Recombined_Is2_second & St41_Recombined_Is2_Inv;
	
	St41_Recombined_y16i3_first <= St41_Recombined_Is3_second & St41_Recombined_Is3_Inv;
	
	St41_Recombined_y16i1_second <= St41_Recombined_Is1_second & St41_Recombined_Is1_Inv;
	
	St41_Recombined_y16i2_second <= St41_Recombined_Is2_second & St41_Recombined_Is2_Inv;
	
	St41_Recombined_y16i3_second <= St41_Recombined_Is3_second & St41_Recombined_Is3_Inv;
	
	-- g+h
	Stage41_Recombination1_first : Recomb_St41
		port map (St41_Is1_first, St41_Is2_first, St41_Is3_first, St41_Recombined_Is1_first);
	Stage4_1_Recombination2_first : Recomb_St41
		port map (St41_Is4_first, St41_Is5_first, St41_Is6_first, St41_Recombined_Is2_first);
	Stage4_1_Recombination3_first : Recomb_St41
		port map (St41_Is7_first, St41_Is8_first, St41_Is9_first, St41_Recombined_Is3_first);
	--y16	
	Stage41_Recombination1_second : Recomb_St41
		port map (St41_Is1_second, St41_Is2_second, St41_Is3_second, St41_Recombined_Is1_second);
	Stage41_Recombination2_second : Recomb_St41
		port map (St41_Is4_second, St41_Is5_second, St41_Is6_second, St41_Recombined_Is2_second);
	Stage41_Recombination3_second : Recomb_St41
		port map (St41_Is7_second, St41_Is8_second, St41_Is9_second, St41_Recombined_Is3_second);

   -- Inversion - i from h+g
	St41_Recombined_Is1_Inv <= St41_Recombined_Is1_first(0) & St41_Recombined_Is1_first(1);
	St41_Recombined_Is2_Inv <= St41_Recombined_Is2_first(0) & St41_Recombined_Is2_first(1);
	St41_Recombined_Is3_Inv <= St41_Recombined_Is3_first(0) & St41_Recombined_Is3_first(1);
	
	Stage41 : sbox_ph41
	port map ( St41_Randomness_first, St41_Randomness_first, 
						St41_Recombined_y16i1_first, St41_Recombined_y16i2_first, St41_Recombined_y16i3_first, 
						St41_Recombined_y16i1_second, St41_Recombined_y16i2_second, St41_Recombined_y16i3_second, 
						St41_Recombined_Is1_second, St41_Recombined_Is2_second, St41_Recombined_Is3_second, --y16
						St41_Recombined_Is1_Inv, St41_Recombined_Is2_Inv, St41_Recombined_Is3_Inv, --i
						St41_Os1_first, St41_Os2_first, St41_Os3_first, St41_Os4_first, St41_Os5_first, St41_Os6_first, St41_Os7_first, St41_Os8_first, St41_Os9_first,
						St41_Os1_second, St41_Os2_second, St41_Os3_second, St41_Os4_second, St41_Os5_second, St41_Os6_second, St41_Os7_second, St41_Os8_second, St41_Os9_second);
	
	
  	Stage41_Register_S1_first : Regs_Shares3
		port map (clk, St41_Os1_first, St42_Is1_first);
	Stage41_Register_S2_first : Regs_Shares3
		port map (clk, St41_Os2_first, St42_Is2_first);
	Stage41_Register_S3_first : Regs_Shares3
		port map (clk, St41_Os3_first, St42_Is3_first);
	Stage41_Register_S4_first : Regs_Shares3
		port map (clk, St41_Os4_first, St42_Is4_first);
	Stage41_Register_S5_first : Regs_Shares3
		port map (clk, St41_Os5_first, St42_Is5_first);
	Stage41_Register_S6_first : Regs_Shares3
		port map (clk, St41_Os6_first, St42_Is6_first);
	Stage41_Register_S7_first : Regs_Shares3
		port map (clk, St41_Os7_first, St42_Is7_first);
	Stage41_Register_S8_first : Regs_Shares3
		port map (clk, St41_Os8_first, St42_Is8_first);
	Stage41_Register_S9_first : Regs_Shares3
		port map (clk, St41_Os9_first, St42_Is9_first);
		
        Stage41_Register_S1_second : Regs_Shares3 
		port map (clk, St41_Os1_second, St42_Is1_second);
	Stage41_Register_S2_second : Regs_Shares3
		port map (clk, St41_Os2_second, St42_Is2_second);
	Stage41_Register_S3_second : Regs_Shares3
		port map (clk, St41_Os3_second, St42_Is3_second);
	Stage41_Register_S4_second : Regs_Shares3
		port map (clk, St41_Os4_second, St42_Is4_second);
	Stage41_Register_S5_second : Regs_Shares3
		port map (clk, St41_Os5_second, St42_Is5_second);
	Stage41_Register_S6_second : Regs_Shares3
		port map (clk, St41_Os6_second, St42_Is6_second);
	Stage41_Register_S7_second : Regs_Shares3
		port map (clk, St41_Os7_second, St42_Is7_second);
	Stage41_Register_S8_second : Regs_Shares3
		port map (clk, St41_Os8_second, St42_Is8_second);
	Stage41_Register_S9_second : Regs_Shares3
		port map (clk, St41_Os9_second, St42_Is9_second);

	Stage41_Register_S_Top1_x : Regs_Shares2
		port map (clk, St41_Is_Top1_x, St42_Is_Top1_x);
	Stage41_Register_S_Top2_x : Regs_Shares2
		port map (clk, St41_Is_Top2_x, St42_Is_Top2_x);
	Stage41_Register_S_Top3_x : Regs_Shares2
		port map (clk, St41_Is_Top3_x, St42_Is_Top3_x);
	Stage41_Register_S_Bot1_x : Regs_Shares2
		port map (clk, St41_Is_Bottom1_x, St42_Is_Bottom1_x);
	Stage41_Register_S_Bot2_x : Regs_Shares2
		port map (clk, St41_Is_Bottom2_x, St42_Is_Bottom2_x);
	Stage41_Register_S_Bot3_x : Regs_Shares2
		port map (clk, St41_Is_Bottom3_x, St42_Is_Bottom3_x);


	Stage41_Register_S_Top1_ef : Regs_Shares3
		port map (clk, St41_Is_Top1_ef, St42_Is_Top1_ef);
	Stage41_Register_S_Top2_ef : Regs_Shares3
		port map (clk, St41_Is_Top2_ef, St42_Is_Top2_ef);
	Stage41_Register_S_Top3_ef : Regs_Shares3
		port map (clk, St41_Is_Top3_ef, St42_Is_Top3_ef);
	Stage41_Register_S_Bot1_ef : Regs_Shares3
		port map (clk, St41_Is_Bottom1_ef, St42_Is_Bottom1_ef);
	Stage41_Register_S_Bot2_ef : Regs_Shares3
		port map (clk, St41_Is_Bottom2_ef, St42_Is_Bottom2_ef);
	Stage41_Register_S_Bot3_ef : Regs_Shares3
		port map (clk, St41_Is_Bottom3_ef, St42_Is_Bottom3_ef);
		

	Stage41_Register_y256_1 : Regs_Shares2
		port map (clk, St41_y256_1, St42_y256_1);
	Stage41_Register_y256_2 : Regs_Shares2
		port map (clk, St41_y256_2, St42_y256_2);
	Stage41_Register_y256_3 : Regs_Shares2
		port map (clk, St41_y256_3, St42_y256_3);
  
  	Stage41_St42_Randomness: Regs_Shares2
		port map (clk, S3_St42_Randomness, S41_St42_Randomness);	
	Stage41_St52_1_Randomness: Regs_Shares1
		port map (clk, S3_St52_1_Randomness, S41_St52_1_Randomness);
   Stage41_Randomness_St6_fix: Regs_Shares1
		port map (clk, S3_Randomness_St6_fix, S41_Randomness_St6_fix);		
  
   --	
	-- Stage 42
	--

	St42_Recombined_eyinv1 <= (St42_Recombined_Is1_first_e xor St42_Is_Top1_ef) & St42_Recombined_Is1_second;	
	St42_Recombined_eyinv2 <= (St42_Recombined_Is2_first_e xor St42_Is_Top2_ef) & St42_Recombined_Is2_second;	
	St42_Recombined_eyinv3 <= (St42_Recombined_Is3_first_e xor St42_Is_Top3_ef) & St42_Recombined_Is3_second;
	
	St42_Recombined_fyinv1 <= (St42_Recombined_Is1_first_f xor St42_Is_Bottom1_ef) & St42_Recombined_Is1_second;	
	St42_Recombined_fyinv2 <= (St42_Recombined_Is2_first_f xor St42_Is_Bottom2_ef) & St42_Recombined_Is2_second;	
	St42_Recombined_fyinv3 <= (St42_Recombined_Is3_first_f xor St42_Is_Bottom3_ef) & St42_Recombined_Is3_second;
	
	
	Stage42_Recombination1_first_ef : Recomb_St42_random
		port map (St42_Is1_first, St42_Is2_first, St42_Is3_first, S41_St42_Randomness, St42_Recombined_Is1_first_e, St42_Recombined_Is1_first_f); --CONSTANT RANDOMNESS
	Stage42_Recombination2_first_ef : Recomb_St42_random
		port map (St42_Is4_first, St42_Is5_first, St42_Is6_first, S41_St42_Randomness, St42_Recombined_Is2_first_e, St42_Recombined_Is2_first_f);
	Stage42_Recombination3_first_ef : Recomb_St42_random
		port map (St42_Is7_first, St42_Is8_first, St42_Is9_first, S41_St42_Randomness, St42_Recombined_Is3_first_e, St42_Recombined_Is3_first_f);


	Stage42_Recombination1_second : Recomb_St42
		port map (St42_Is1_second, St42_Is2_second, St42_Is3_second, St42_Recombined_Is1_second);
	Stage42_Recombination2_second : Recomb_St42
		port map (St42_Is4_second, St42_Is5_second, St42_Is6_second, St42_Recombined_Is2_second);
	Stage42_Recombination3_second : Recomb_St42
		port map (St42_Is7_second, St42_Is8_second, St42_Is9_second, St42_Recombined_Is3_second);
	

	Stage42 : sbox_ph42  
	port map ( S41_St42_Randomness, St42_Randomness_first, 
						St42_Recombined_eyinv1, St42_Recombined_eyinv2, St42_Recombined_eyinv3,
						St42_Recombined_fyinv1, St42_Recombined_fyinv2, St42_Recombined_fyinv3,
						St42_Os1, St42_Os2, St42_Os3, St42_Os4, St42_Os5, St42_Os6, St42_Os7, St42_Os8, St42_Os9);
	
	Stage42_Register_S1 : Regs_Shares2
		port map (clk, St42_Os1, St51_Is1);
	Stage42_Register_S2 : Regs_Shares2
		port map (clk, St42_Os2, St51_Is2);
	Stage42_Register_S3 : Regs_Shares2
		port map (clk, St42_Os3, St51_Is3);
	Stage42_Register_S4 : Regs_Shares2
		port map (clk, St42_Os4, St51_Is4);
	Stage42_Register_S5 : Regs_Shares2
		port map (clk, St42_Os5, St51_Is5);
	Stage42_Register_S6 : Regs_Shares2
		port map (clk, St42_Os6, St51_Is6);
	Stage42_Register_S7 : Regs_Shares2
		port map (clk, St42_Os7, St51_Is7);
	Stage42_Register_S8 : Regs_Shares2
		port map (clk, St42_Os8, St51_Is8);
	Stage42_Register_S9 : Regs_Shares2
		port map (clk, St42_Os9, St51_Is9);
			
		
	Stage42_Register_S_Top1_x : Regs_Shares2
		port map (clk, St42_Is_Top1_x, St51_Is_Top1_x);
	Stage42_Register_S_Top2_x : Regs_Shares2
		port map (clk, St42_Is_Top2_x, St51_Is_Top2_x);
	Stage42_Register_S_Top3_x : Regs_Shares2
		port map (clk, St42_Is_Top3_x, St51_Is_Top3_x);
	Stage42_Register_S_Bot1_x : Regs_Shares2
		port map (clk, St42_Is_Bottom1_x, St51_Is_Bottom1_x);
	Stage42_Register_S_Bot2_x : Regs_Shares2
		port map (clk, St42_Is_Bottom2_x, St51_Is_Bottom2_x);
	Stage42_Register_S_Bot3_x : Regs_Shares2
		port map (clk, St42_Is_Bottom3_x, St51_Is_Bottom3_x);

	Stage42_Register_y256_1 : Regs_Shares2
		port map (clk, St42_y256_1, St51_y256_1);
	Stage42_Register_y256_2 : Regs_Shares2
		port map (clk, St42_y256_2, St51_y256_2);
	Stage42_Register_y256_3 : Regs_Shares2
		port map (clk, St42_y256_3, St51_y256_3);
	
	Stage42_St52_1_Randomness: Regs_Shares1
		port map (clk, S41_St52_1_Randomness, S42_St52_1_Randomness);
   Stage42_Randomness_St6_fix: Regs_Shares1
		port map (clk, S41_Randomness_St6_fix, S42_Randomness_St6_fix);		
	
	--
	-- Stage 51
	--		
	-- y256 & l16	
	St51_Is1_y256l16 <= St51_y256_1 & St51_Recombined_Is1;
	St51_Is2_y256l16 <= St51_y256_2 & St51_Recombined_Is2;	
	St51_Is3_y256l16 <= St51_y256_3 & St51_Recombined_Is3;
	
        --l16	
	Stage51_Recombination1 : Recomb_St51
		port map (St51_Is1, St51_Is2, St51_Is3, St51_Recombined_Is1);
	Stage51_Recombination2 : Recomb_St51
		port map (St51_Is4, St51_Is5, St51_Is6, St51_Recombined_Is2);
	Stage51_Recombination3 : Recomb_St51
		port map (St51_Is7, St51_Is8, St51_Is9, St51_Recombined_Is3);
		
	Stage51 : sbox_ph51 -- y256*l16 + 15
		port map ( St51_Randomness, 
						St51_Is1_y256l16, St51_Is2_y256l16, St51_Is3_y256l16,
						St51_Os1, St51_Os2, St51_Os3, 
						St51_Os4, St51_Os5, St51_Os6, 
						St51_Os7, St51_Os8, St51_Os9);
						
	Stage51_Register_S1 : Regs_Shares2
		port map (clk, St51_Os1, St52_Is1);
	Stage51_Register_S2 : Regs_Shares2
		port map (clk, St51_Os2, St52_Is2);
	Stage51_Register_S3 : Regs_Shares2
		port map (clk, St51_Os3, St52_Is3);
	Stage51_Register_S4 : Regs_Shares2
		port map (clk, St51_Os4, St52_Is4);
	Stage51_Register_S5 : Regs_Shares2
		port map (clk, St51_Os5, St52_Is5);
	Stage51_Register_S6 : Regs_Shares2
		port map (clk, St51_Os6, St52_Is6);
	Stage51_Register_S7 : Regs_Shares2
		port map (clk, St51_Os7, St52_Is7);
	Stage51_Register_S8 : Regs_Shares2
		port map (clk, St51_Os8, St52_Is8);
	Stage51_Register_S9 : Regs_Shares2
		port map (clk, St51_Os9, St52_Is9);
		
	Stage51_Register_S_Top1_x : Regs_Shares2
		port map (clk, St51_Is_Top1_x, St52_Is_Top1_x);
	Stage51_Register_S_Top2_x : Regs_Shares2
		port map (clk, St51_Is_Top2_x, St52_Is_Top2_x);
	Stage51_Register_S_Top3_x : Regs_Shares2
		port map (clk, St51_Is_Top3_x, St52_Is_Top3_x);
	Stage51_Register_S_Bot1_x : Regs_Shares2
		port map (clk, St51_Is_Bottom1_x, St52_Is_Bottom1_x);
	Stage51_Register_S_Bot2_x : Regs_Shares2
		port map (clk, St51_Is_Bottom2_x, St52_Is_Bottom2_x);
	Stage51_Register_S_Bot3_x : Regs_Shares2
		port map (clk, St51_Is_Bottom3_x, St52_Is_Bottom3_x);
 	
        --l16	
	Stage51_Register_l16_1 : Regs_Shares2
		port map (clk, St51_Recombined_Is1, St52_l16_1);
	Stage51_Register_l16_2 : Regs_Shares2
		port map (clk, St51_Recombined_Is2, St52_l16_2);
	Stage51_Register_l16_3 : Regs_Shares2
		port map (clk, St51_Recombined_Is3, St52_l16_3);

        --y256
	Stage51_Register_y256_1 : Regs_Shares2
		port map (clk, St51_y256_1, St52_y256_1);
	Stage51_Register_y256_2 : Regs_Shares2
		port map (clk, St51_y256_2, St52_y256_2);
	Stage51_Register_y256_3 : Regs_Shares2
		port map (clk, St51_y256_3, St52_y256_3);
		
	Stage51_St52_1_Randomness: Regs_Shares1
		port map (clk, S42_St52_1_Randomness, S51_St52_1_Randomness);
   Stage51_Randomness_St6_fix: Regs_Shares1
		port map (clk, S42_Randomness_St6_fix, S51_Randomness_St6_fix);			
	--
	-- Stage 52
	--		
	-- (a2b2+yr) - yinv
	St52_Is1_xinv1 <= (St52_Is_Top1_x xor St52_Recombined_Is1_yr1) & St52_Recombined_Is1_yinv;
	St52_Is2_xinv1 <= (St52_Is_Top2_x xor St52_Recombined_Is2_yr1) & St52_Recombined_Is2_yinv;	
	St52_Is3_xinv1 <= (St52_Is_Top3_x xor St52_Recombined_Is3_yr1) & St52_Recombined_Is3_yinv;
	
	St52_Is1_xinv2 <= (St52_Is_Bottom1_x xor St52_Recombined_Is1_yr2) & St52_Recombined_Is1_yinv;
	St52_Is2_xinv2 <= (St52_Is_Bottom2_x xor St52_Recombined_Is2_yr2) & St52_Recombined_Is2_yinv;	
	St52_Is3_xinv2 <= (St52_Is_Bottom3_x xor St52_Recombined_Is3_yr2) & St52_Recombined_Is3_yinv;
	
	-- (yyinv+15) - l16
	St52_Is1_fix <= St52_Recombined_Is1_yyinv15 & St52_l16_1;
	St52_Is2_fix <= St52_Recombined_Is2_yyinv15 & St52_l16_2;	
	St52_Is3_fix <= St52_Recombined_Is3_yyinv15 & St52_l16_3;
		
	-- (yinv+15)
	Stage52_Recombination1_yyinv15 : Recomb_St52
		port map (St52_Is1, St52_Is2, St52_Is3, S51_St52_1_Randomness, St52_y256_1, St52_l16_1, St52_Recombined_Is1_yr1, St52_Recombined_Is1_yr2, St52_Recombined_Is1_yinv, St52_Recombined_Is1_yyinv15);
	Stage52_Recombination2_yyinv15 : Recomb_St52
		port map (St52_Is4, St52_Is5, St52_Is6, S51_St52_1_Randomness, St52_y256_2, St52_l16_2, St52_Recombined_Is2_yr1, St52_Recombined_Is2_yr2, St52_Recombined_Is2_yinv, St52_Recombined_Is2_yyinv15);
	Stage52_Recombination3_yyinv15 : Recomb_St52
		port map (St52_Is7, St52_Is8, St52_Is9, S51_St52_1_Randomness, St52_y256_3, St52_l16_3, St52_Recombined_Is3_yr1, St52_Recombined_Is3_yr2, St52_Recombined_Is3_yinv, St52_Recombined_Is3_yyinv15);
						
  
	Stage52_second : sbox_ph52_second  
	port map (St52_Randomness_first, St52_Randomness_fix,
						St52_Is1_xinv1, St52_Is2_xinv1, St52_Is3_xinv1,
						St52_Is1_xinv2, St52_Is2_xinv2, St52_Is3_xinv2,
						St52_Is1_fix, St52_Is2_fix, St52_Is3_fix,
						St52_Os1, St52_Os2, St52_Os3, St52_Os4, St52_Os5, St52_Os6, St52_Os7, St52_Os8, St52_Os9,
						St52_Os1_fix, St52_Os2_fix, St52_Os3_fix, St52_Os4_fix, St52_Os5_fix, St52_Os6_fix, St52_Os7_fix, St52_Os8_fix, St52_Os9_fix);						
	
		
	Stage52_Register_S1 : Regs_Shares1
		port map (clk, St52_Os1, St6_Is1);
	Stage52_Register_S2 : Regs_Shares1
		port map (clk, St52_Os2, St6_Is2);
	Stage52_Register_S3 : Regs_Shares1
		port map (clk, St52_Os3, St6_Is3);
	Stage52_Register_S4 : Regs_Shares1
		port map (clk, St52_Os4, St6_Is4);
	Stage52_Register_S5 : Regs_Shares1
		port map (clk, St52_Os5, St6_Is5);
	Stage52_Register_S6 : Regs_Shares1
		port map (clk, St52_Os6, St6_Is6);
	Stage52_Register_S7 : Regs_Shares1
		port map (clk, St52_Os7, St6_Is7);
	Stage52_Register_S8 : Regs_Shares1
		port map (clk, St52_Os8, St6_Is8);
	Stage52_Register_S9 : Regs_Shares1
		port map (clk, St52_Os9, St6_Is9);	
		
	Stage52_Register_S1_fix : Regs_Shares2
		port map (clk, St52_Os1_fix, St6_Is1_fix);
	Stage52_Register_S2_fix : Regs_Shares2
		port map (clk, St52_Os2_fix, St6_Is2_fix);
	Stage52_Register_S3_fix : Regs_Shares2
		port map (clk, St52_Os3_fix, St6_Is3_fix);
	Stage52_Register_S4_fix : Regs_Shares2
		port map (clk, St52_Os4_fix, St6_Is4_fix);
	Stage52_Register_S5_fix : Regs_Shares2
		port map (clk, St52_Os5_fix, St6_Is5_fix);
	Stage52_Register_S6_fix : Regs_Shares2
		port map (clk, St52_Os6_fix, St6_Is6_fix);
	Stage52_Register_S7_fix : Regs_Shares2
		port map (clk, St52_Os7_fix, St6_Is7_fix);
	Stage52_Register_S8_fix : Regs_Shares2
		port map (clk, St52_Os8_fix, St6_Is8_fix);
	Stage52_Register_S9_fix : Regs_Shares2
		port map (clk, St52_Os9_fix, St6_Is9_fix);

	Stage52_St52_1_Randomness: Regs_Shares1
		port map (clk, S51_St52_1_Randomness, S52_St52_1_Randomness);
   Stage52_Randomness_St6_fix: Regs_Shares1
		port map (clk, S51_Randomness_St6_fix, S52_Randomness_St6_fix);		
	--
	-- Stage 6
	--			
		
        Stage6_Recombination1_second: Recomb_St6_rand
		port map (St6_Is1, St6_Is2, St6_Is3, S52_St52_1_Randomness, S52_Randomness_St6_fix, St6_Is1_fix, St6_Is2_fix, St6_Is3_fix, St6_Recombined_Is1);
        Stage6_Recombination2_second: Recomb_St6_rand
		port map (St6_Is4, St6_Is5, St6_Is6, "00000000", S52_Randomness_St6_fix, St6_Is4_fix, St6_Is5_fix, St6_Is6_fix, St6_Recombined_Is2);
        Stage6_Recombination3_second: Recomb_St6_rand
		port map (St6_Is7, St6_Is8, St6_Is9, "00000000", S52_Randomness_St6_fix, St6_Is7_fix, St6_Is8_fix, St6_Is9_fix, St6_Recombined_Is3);
	Stage6_second : sbox_ph6
		port map ( St6_Recombined_Is1, St6_Recombined_Is2, St6_Recombined_Is3, 
						Os1, Os2, Os3);

end Behavioral;