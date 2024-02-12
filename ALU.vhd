library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	PORT(clock : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
         IMM : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 selR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 zero_flag : OUT STD_LOGIC
	);
END alu;

architecture Behavioral of alu is
signal shift_amount : natural range 0 to 15;
signal result_read : std_logic_vector(15 downto 0);
begin
    process(A, B, IMM, selR)
    begin
        case selR is
            --premier format Rddest RA RB
            when "00000" =>  --ADD
                result_read <= std_logic_vector(unsigned(A) + unsigned(B));
            when "00001" => --SUB
                result_read <= std_logic_vector(unsigned(A) - unsigned(B));
            when "00010" => --RSHIFT
                result_read <= std_logic_vector(shift_right(unsigned(B),to_integer(unsigned(A))));
            when "00011" => --LSHIFT
                result_read <= std_logic_vector(shift_left(unsigned(B),to_integer(unsigned(A))));
            when "00100" => --AND
                result_read <= A AND B;
            when "00101" => --OR
                result_read <= A OR B;
            when "00110" => --MOV
                result_read <= B;

            --deuxieme format Rdest RB Imm

            when "01000" => --ADD
               result_read <= std_logic_vector(unsigned(B) + resize(unsigned(IMM),16));
            when "01001" => --SUB
                result_read <=std_logic_vector(unsigned(B) - resize(unsigned(IMM),16));
            when "01010" => --RSHIFT
                result_read <= std_logic_vector(shift_right(unsigned(B),to_integer(unsigned(IMM))));
            when "01011" => --LSHIFT
                shift_amount <= to_integer(unsigned(A(3 downto 0)));
                result_read <= std_logic_vector(shift_left(unsigned(B),to_integer(unsigned(IMM))));
            when "01100" => --AND
                 result_read <= std_logic_vector(resize(unsigned(IMM),16)) AND B;
            when "01101" => --OR
                 result_read <= std_logic_vector(resize(unsigned(IMM),16)) OR B;
            when "10110" => --MOV
                 result_read <= std_logic_vector(resize(unsigned(IMM),16));

            --troisieme format Rdest Imm
            when "10000" => --MOV
                result_read <= std_logic_vector(resize(unsigned(IMM),16));

            when others =>
                null;
        end case;
        if result_read = "0000000000000000" then
            zero_flag <= '1';
        else
            zero_flag <= '0';
        end if;
    end process;
    result <= result_read;
end Behavioral;
