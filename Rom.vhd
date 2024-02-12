library ieee;

use IEEE.STD_LOGIC_1164.ALL;
Use ieee.numeric_std.all ;


entity rom is
	port(
			en			:	in std_logic;
			clk		:	in std_logic;
			rst		:	in std_logic;
			Adress	:	in std_logic_vector(7 downto 0);
			Data_out:	out std_logic_vector(15 downto 0)
			);
end rom;

architecture rom_a of rom is

type rom is array(0 to 255) of std_logic_vector(15 downto 0); --16 bits to hold 1 instruction
-- instructions pour programme de test
rom(0) <= "1000000000001010"; --  MOV 000 10        --> A = 10
rom(1) <= "1000000000100101"; --  MOV 001 5         --> B = 5 
rom(2) <= "1000000001001000"; --  MOV 010 8         --> C =8
rom(3) <= "0000010000100000"; --  ADD 100 001 000   --> D = A + B
rom(4) <= "0100110101010011"; --  SUB 101 010 3     --> E = C -3
rom(5) <= "0010000010010100"; --  AND 000 100 101   --> A = D & E
rom(6) <= "0010100110010100"; --  OR 001 100 101    --> B = D || E
rom(7) <= "0101001000100001"; --  RSHIFT 010 001 1  --> C = B // 2


signal Data_Rom : rom ;



--------------- BEGIN -----------------------------------------------------------------
begin
-- rw='1' alors lecture
	acces_rom:process(rst, clk)
		begin
		
		if rst='1' then

				Data_Rom(0) <= (others=>'0');
				Data_Rom(1) <= (others=>'0');

		else
			if rising_edge(clk) then
				if en='1'then
					Data_out <= Data_Rom(to_integer(unsigned(Adress)));
				end if;

			end if;
		end if;
		
	end process acces_rom;

end rom_a;
