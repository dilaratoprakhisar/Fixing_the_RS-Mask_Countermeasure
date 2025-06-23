library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
 use work.MPC_globals.all;

entity Aff_with_tag is
  port (
   clk : in std_logic;
		 Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
		 Os1, Os2, Os3: out std_logic_vector(7 downto 0)
  );
end Aff_with_tag;



architecture Behavioral of Aff_with_tag is 

  component Lin_unshared 
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           x_Lin : out  STD_LOGIC_VECTOR (7 downto 0)
           );
  end component;
  
  component Aff_unshared 
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           x_Aff : out  STD_LOGIC_VECTOR (7 downto 0)
           );
  end component;
  
  
  signal x_Aff_value_next1, x_Aff_value_reg1,x_Aff_value_next2, x_Aff_value_reg2,x_Aff_value_next3, x_Aff_value_reg3 : std_logic_vector(7 downto 0);

begin 
  
  -- Apply affine transform to values (affine to share 0 and linear to the rest) (no registers)
  share_0 : Aff_unshared port map( x => Is1, x_Aff => x_Aff_value_next1);

    share_1 : Lin_unshared port map( x=> Is2, x_Lin => x_Aff_value_next2);
share_2 : Lin_unshared port map( x=> Is3, x_Lin => x_Aff_value_next3);
  
  
  Os1 <= x_Aff_value_reg1;
  Os2 <= x_Aff_value_reg2;
  Os3 <= x_Aff_value_reg3;
  
  sequential : process(clk)
	begin
		if (rising_edge(clk)) then
			x_Aff_value_reg1 <= x_Aff_value_next1;
			x_Aff_value_reg2 <= x_Aff_value_next2;
			x_Aff_value_reg3 <= x_Aff_value_next3;
		end if;
	end process;

end Behavioral;
