library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
	PORT(reset : in std_logic;
		 clock : in std_logic;
		 instruction : in std_logic_vector(15 downto 0);
		 addrDest : out std_logic_vector(2 downto 0);
		 imm : out std_logic_vector(4 downto 0);
		 selR : out std_logic_vector(4 downto 0);
		 addrA : out std_logic_vector(2 downto 0);
		 addrB : out std_logic_vector(2 downto 0);
     opcode : out std_logic_vector(4 downto 0);
		 enable : out std_logic
	);
END Decoder;

architecture Decoder_arch of Decoder is

begin
    process(clock, reset)
      begin
      if reset = '1' then
        opcode <= (others => '0');
        selR <= (others => '0');
        addrDest <= (others => '0');
        addrA <= (others => '0');
        addrB <= (others => '0');
        imm <= (others => '0');
      elsif rising_edge(clock) then

      -- decode instruction
      opcode <= instruction(15 downto 11);
      selR <= instruction(15 downto 11);
      addrDest <= instruction(10 downto 8);
      addrA <= instruction(4 downto 2);
      addrB <= instruction(7 downto 5);
      imm <= instruction(4 downto 0) when instruction(15 downto 14) /= "00";

    end if;
    end process;
end Decoder_arch;