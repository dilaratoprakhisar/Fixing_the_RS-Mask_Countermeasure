library ieee;
use ieee.std_logic_1164.all;

entity linear_map is
	port(	
		Xs : in std_logic_vector(7 downto 0);
		Ys : out std_logic_vector(7 downto 0)
	);
end linear_map;

architecture behavior of linear_map is

	signal Ys1, Ys2, Ys3, Ys4, Ys5, Ys6, Ys7, Ys8 : std_logic_vector(7 downto 0);

begin
	process(Xs)
	begin
		if Xs(0) = '1' then Ys1 <= x"FF"; else Ys1 <= x"00"; end if;
		if Xs(1) = '1' then Ys2 <= x"A9"; else Ys2 <= x"00"; end if;
		if Xs(2) = '1' then Ys3 <= x"81"; else Ys3 <= x"00"; end if;
		if Xs(3) = '1' then Ys4 <= x"09"; else Ys4 <= x"00"; end if;
		if Xs(4) = '1' then Ys5 <= x"48"; else Ys5 <= x"00"; end if;
		if Xs(5) = '1' then Ys6 <= x"F2"; else Ys6 <= x"00"; end if;
		if Xs(6) = '1' then Ys7 <= x"F3"; else Ys7 <= x"00"; end if;
		if Xs(7) = '1' then Ys8 <= x"98"; else Ys8 <= x"00"; end if;
	end process;

	Ys <= Ys1 xor Ys2 xor Ys3 xor Ys4 xor Ys5 xor Ys6 xor Ys7 xor Ys8;

end behavior;
