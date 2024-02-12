-- testbench for ALU

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_alu is
end test_alu;

architecture testbench1 of test_alu is
    -- signaux
        signal clock : STD_LOGIC;
    	signal A : STD_LOGIC_VECTOR(15 DOWNTO 0);
		signal B : STD_LOGIC_VECTOR(15 DOWNTO 0);
		signal selR : STD_LOGIC_VECTOR(4 DOWNTO 0);
		signal result : STD_LOGIC_VECTOR(15 DOWNTO 0);
		signal zero_flag : STD_LOGIC;

        component alu is
        PORT(
         clock : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 selR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 zero_flag : OUT STD_LOGIC
	    );
        end component;

    begin 
        dut : alu
            -- map ports to testbench
            port map (
                clock => clock,
                A => A,
                B => B,
                selR => selR,
                result => result,
                zero_flag => zero_flag
            );
        
        process is
            begin
            loop
            A <= "0000000000000001";
            B <= "0000000000000001";
            selR <= "00011";
            wait for 10 ns;
            end loop;
            end process;
end architecture testbench1;

