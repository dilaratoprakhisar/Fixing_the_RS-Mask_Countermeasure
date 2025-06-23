--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library STD;
 use STD.textio.all;


  library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.NUMERIC_STD.ALL;
    

library work;


package MPC_globals is

	constant D : integer := 3; -- warning: making d even will introduce bugs 

--types

	type shared_value		is array (0 to D-1) of std_logic_vector(7 downto 0);
	--ATTENTION!!!!!!!!!!! Keeping all shares together in the same recors might induce to leakage,
	--coz probably they will be kept together when Synthesized
  
  type shared_bit   is array(0 to D-1) of std_logic;
  
  type array32 is array(0 to 31) of std_logic_vector(7 downto 0);
  type array48 is array(0 to 47) of std_logic_vector(7 downto 0);
  type array16 is array(0 to 15) of std_logic_vector(7 downto 0);
  
  type random is array(0 to 2) of std_logic_vector(7 downto 0);
  --type mult_random is array(0 to 2) of random;
  --type box_random is array(0 to 14) of random;
  
  type matrix is array(0 to 7) of std_logic_vector(7 downto 0);
  type shared_matrix is array(0 to D-1) of matrix;

  type infect_random is array(0 to 3) of std_logic_vector(7 downto 0);

--Records

  type shared_value_tag is record 
    v : shared_value;
    t : shared_value;
  end record;

  type shared_bit_tag is record 
    v : shared_bit;
    t : shared_bit;
  end record;

  type box_random is record 
    af : random;
    inv1 : std_logic_vector(161 downto 0);
    inv2 : std_logic_vector(161 downto 0);
  end record;
  
  
--type of record

  type column is array (0 to 3) of shared_value_tag;
  type state  is array (0 to 3) of column;
  
  type mix_col_type is array (3 downto 0) of shared_value_tag; 
  --Mix columns uses (31 downto 0) bit strings, i.e a concatenation of 4 bytes. This type concatenates 4 shared_value_tag
  

end MPC_globals;

package body MPC_globals is


 
end MPC_globals;
