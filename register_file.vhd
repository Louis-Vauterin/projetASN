library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
	PORT(clock : IN STD_LOGIC;
         reset : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 addrDest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 addrA : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 addrB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 outA : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 outB : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END register_file;

architecture Behavioral of register_file is

--8 registres de 16 bits
type register_array is array (0 to 7) of std_logic_vector(15 downto 0);
signal registers : register_array;

begin
    
    process(clock, reset)
        begin
            if reset = '1' then
            -- on reset tous les registres a zero
                registers <= (others => (others => '0'));
            elsif rising_edge(clock) then
                if enable = '1' then
                    registers(to_integer(unsigned(addrDest))) <= data_in;
                end if;
            end if;
    end process;

    outA <= registers(to_integer(unsigned(addrA)));
    outB <= registers(to_integer(unsigned(addrB)));

end Behavioral;


