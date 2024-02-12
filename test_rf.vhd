-- testbench for register file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_rf is
end test_rf;

architecture testbench2 of test_rf is

        component register_file is
        PORT(clock : IN STD_LOGIC; --initialise signals
		 reset : IN STD_LOGIC;
		 enable : IN STD_LOGIC;
		 addrDest : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 addrA : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 addrB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 outA : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 outB : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	    );
        end component;
    -- signaux
        signal sig_clock : STD_LOGIC :='0';
    	signal reset : STD_LOGIC :='0';
		signal enable : STD_LOGIC :='0';
		signal addrDest : STD_LOGIC_VECTOR(2 DOWNTO 0);
		signal addrA : STD_LOGIC_VECTOR(2 DOWNTO 0);
		signal addrB : STD_LOGIC_VECTOR(2 DOWNTO 0);
		signal data_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
		signal outA : STD_LOGIC_VECTOR(15 DOWNTO 0);
		signal outB : STD_LOGIC_VECTOR(15 DOWNTO 0);



    begin 
        sig_clock <= not sig_clock after 5 ns;
        dut : register_file
            -- map ports to testbench
            port map (
                clock => sig_clock,
                reset => reset,
                enable => enable,
                addrDest => addrDest,
                addrA => addrA,
                addrB => addrB,
                data_in => data_in,
                outA => outA,
                outB => outB
            );
        process is
            begin
            wait until rising_edge(sig_clock);
            enable <= '1';
            addrDest <= "000";
            data_in <= "0000000000000001";
            wait until rising_edge(sig_clock);
            addrDest <= "001";
            data_in <= "0000000000000001";
            enable <= '0';
            wait until rising_edge(sig_clock);
            addrA <= "000";
            addrB <= "001";
            wait until rising_edge(sig_clock);
            reset <= '1';
            wait until rising_edge(sig_clock);
            reset <='0';


            end process;
end architecture testbench2;