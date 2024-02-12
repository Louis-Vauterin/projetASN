-- testbench for decoder

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_decoder is
end test_decoder;

architecture testbench1 of test_decoder is
    -- signaux
	 
	component decoder is
	PORT(reset : in std_logic;
		 clock : in std_logic;
		 instruction : in std_logic_vector(15 downto 0);
		 addrDest : out std_logic_vector(2 downto 0);
		 imm : out std_logic_vector(4 downto 0);
		 selR : out std_logic_vector(4 downto 0);
		 addrA : out std_logic_vector(2 downto 0);
		 addrB : out std_logic_vector(2 downto 0);
		 enable : out std_logic
	);
	END component;

  SIGNAL reset : STD_LOGIC := '0';
  SIGNAL sig_clock : STD_LOGIC := '0';
  SIGNAL instruction : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL addrDest : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL imm : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL selR : STD_LOGIC_VECTOR(4 DOWNTO 0);
  SIGNAL addrA : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL addrB : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL enable : STD_LOGIC;

    
    begin 
        sig_clock <= not sig_clock after 5 ns;
        dut : decoder
            -- map ports to testbench
            port map (
					 reset => reset,
                    clock => sig_clock,
                    instruction => instruction,
					 addrDest => addrDest,
					 imm => imm,
					 selR => selR,
					 addrA => addrA,
                     addrB => addrB,
					 enable => enable
            );
        
        process is
            begin
            wait until rising_edge(sig_clock);
            instruction <= "0000001000100000";
            wait until rising_edge(sig_clock);
            instruction <= "1000000000001010";
            end process;
				
end architecture testbench1;