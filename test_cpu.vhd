-- testbench for CPU

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

entity test_cpu is
end test_cpu;

architecture testbenchcpu of test_cpu is

    component CPU is
        PORT(reset :  IN  STD_LOGIC;
            clock :  IN  STD_LOGIC;
            MAX10_CLK1_50 :  IN  STD_LOGIC;
            SW :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            HEX0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
            HEX1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
            HEX2 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
            HEX3 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
            HEX4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
            HEX5 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
            LEDR :  OUT  STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END component;

    signal reset : STD_LOGIC;
    signal clock : STD_LOGIC;
    signal MAX10_CLK1_50 : STD_LOGIC;
    signal SW : STD_LOGIC_VECTOR(9 DOWNTO 0);
    signal HEX0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal HEX1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal HEX2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal HEX3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal HEX4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal HEX5 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal LEDR : STD_LOGIC_VECTOR(9 DOWNTO 0);

    begin
        dut : CPU 
        port map (
            reset => reset,
            clock => clock,
            MAX10_CLK1_50 => MAX10_CLK1_50,
            SW => SW,
            HEX0 => HEX0,
            HEX1 => HEX1,
            HEX2 => HEX2,
            HEX3 => HEX3, 
            HEX4 => HEX4, 
            HEX5 => HEX5, 
            LEDR => LEDR


        );

        MAX10_CLK1_50 <= not MAX10_CLK1_50 after 10 ns;

        process is
        begin
            wait until rising_edge(MAX10_CLK1_50);
        end process;
end architecture testbenchcpu;




