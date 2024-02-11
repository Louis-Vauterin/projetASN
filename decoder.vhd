library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Decoder is
	PORT(reset : in std_logic;
		 clock : in std_logic;
		 instruction : in std_logic_vector(15 downto 0);
		 addrDest : out std_logic_vector(3 downto 0);
		 imm : out std_logic_vector(5 downto 0);
		 selR : out std_logic_vector(4 downto 0);
		 addrA : out std_logic_vector(3 downto 0);
		 addrB : out std_logic_vector(3 downto 0);
		 enable : out std_logic
	);
END Decoder;

architecture Decoder_arch of Decoder is

    --signal NB_WAIT:     natural range 0 to 4;       -- nb of operations to wait
    --signal SP:          natural range 0 to 4095;    -- stack pointer

    signal ins:         std_logic_vector(15 downto 0);
    signal op:          std_logic_vector(3 downto 0);
    --signal funct:       std_logic_vector(1 downto 0);
    --signal jump_sig:    std_logic;
    --signal enable_RAM_sig: std_logic;

begin

    -- decode instruction
    format <= ins(15 downto 14);
    op <= ins(13 down to 11)
    addrA <= ins(4 downto 2);
    addrB <= ins(7 downto 5);
    addrDest <= ins(10 downto 8);
    imm <=
        "000000" & ins(4 downto 0) when ins(15 downto 14) = "01" else
        ins(5 downto 0) when ins(15 downto 14) = "10";

    -- use
    use_reg_imm <= '1' when not(format = "01") else '0';
    use_addrA <= '1' when ins(15 downto 14) = "00" else '0';

end Decoder_arch;