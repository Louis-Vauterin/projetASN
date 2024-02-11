library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
	PORT(clock : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 selR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 zero_flag : OUT STD_LOGIC
	);
END alu;

architecture Behavioral of alu is
signal shift_amount : natural range 0 to 15;
begin
    process(A, B, selR)
    begin
        case selR is
            --premier format Rddest RA RB
            when "00000" =>  --ADD
                result <= A+B;
            when "00001" => --SUB
                result <= A-B;
            when "00010" => --RSHIFT
                shift_amount <= to_integer(unsigned(A(3 downto 0))); -- 4 bits moins signifiants de A
                result <= B(4-shift_amount-1 downto 0) & (others => '0');
            when "00011" => --LSHIFT
                shift_amount <= to_integer(unsigned(A(3 downto 0)));
                result <= <= (others => '0') & B(shift_amount-1 downto 0);
            when "00100" => --AND
                result <= A AND B;
            when "00101" => --OR
                result <= A OR B;
            when "00110" => --MOV
                result <= B;

            --deuxieme format Rdest RB Imm

            when "01000" => --ADD
                result <= B + resize(A,16);
            when "01001" => --SUB
                result <= B - resize(A,16);
            when "01010" => --RSHIFT
                shift_amount <= to_integer(unsigned(A(3 downto 0))); -- 4 bits moins signifiants de A
                result <= B(4-shift_amount-1 downto 0) & (others => '0');
            when "01011" => --LSHIFT
                shift_amount <= to_integer(unsigned(A(3 downto 0)));
                result <= <= (others => '0') & B(shift_amount-1 downto 0);
            when "01100" => --AND
                 result <= resize(A,16) AND B;
            when "01101" => --OR
                 result <= resize(A,16) AND B;
            when "10110" => --MOV
                result <= resize(A,16);

            --troisieme format Rdest Imm
            when "10000" => --MOV
                result <= resize(B,16);

        end case;

        zero <= '1' when result = "0000000000000000" else '0'; -- Set Zero flag 
    end process;
end Behavioral;
