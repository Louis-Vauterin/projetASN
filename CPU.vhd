LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CPU IS 
	PORT
	(
		reset :  IN  STD_LOGIC;
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
END CPU;

ARCHITECTURE bdf_type OF CPU IS 

COMPONENT seg7_lut
	PORT(iDIG : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 oSEG : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT dig2dec
	PORT(vol : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 seg0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg4 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT alu
	PORT(clock : IN STD_LOGIC;
		 A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 selR : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
     	 zero_flag : OUT STD_LOGIC

		 --val : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT fetch
	PORT(clock : IN STD_LOGIC;
		 fallback_index : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 flags : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 jump_index : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 last_index : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		 index : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_file
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
END COMPONENT;

COMPONENT decoder
	PORT(reset : IN STD_LOGIC;
		 clock : IN STD_LOGIC;
		 instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 addrDest : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 imm : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 selR : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 addrA : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 addrB : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 enable : OUT STD_LOGIC
	);
END COMPONENT;



SIGNAL	zero :  STD_LOGIC;
SIGNAL	one :  STD_LOGIC;
SIGNAL	HEX_out0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out1 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out2 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out3 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	HEX_out4 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	seg7_in0 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in2 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in3 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	seg7_in5 :  STD_LOGIC_VECTOR(7 DOWNTO 0);

--SIGNAL aluA : STD_LOGIC_VECTOR(15 DOWNTO 0);
--SIGNAL aluB : STD_LOGIC_VECTOR(15 DOWNTO 0);
--SIGNAL aluSelR : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL aluResult : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL aluZero_f : STD_LOGIC;

SIGNAL fetFB_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL fetFlags : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL fetJump_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL fetLast_i : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL fetIndex : STD_LOGIC_VECTOR(6 DOWNTO 0);

--SIGNAL rfEnable : STD_LOGIC;
--SIGNAL rfAddrD : STD_LOGIC_VECTOR(2 DOWNTO 0);
--SIGNAL rfAddrA : STD_LOGIC_VECTOR(2 DOWNTO 0);
--SIGNAL rfAddrB : STD_LOGIC_VECTOR(2 DOWNTO 0);
--SIGNAL rfData_in : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL rfOutA : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL rfOutB : STD_LOGIC_VECTOR(15 DOWNTO 0);

--SIGNAL decInst : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL decAddrD : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL decImm : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL decSelR : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL decAddrA : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL decAddrB : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL decEnable : STD_LOGIC;
SIGNAL decA : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL decB : STD_LOGIC_VECTOR(15 DOWNTO 0);


BEGIN 

b2v_inst : seg7_lut
PORT MAP(iDIG => seg7_in0,
		 oSEG => HEX_out4(6 DOWNTO 0));


b2v_inst1 : seg7_lut
PORT MAP(iDIG => seg7_in1,
		 oSEG => HEX_out3(6 DOWNTO 0));

b2v_inst2 : seg7_lut
PORT MAP(iDIG => seg7_in2,
		 oSEG => HEX_out2(6 DOWNTO 0));

b2v_inst3 : seg7_lut
PORT MAP(iDIG => seg7_in3,
		 oSEG => HEX_out1(6 DOWNTO 0));

b2v_inst4 : seg7_lut
PORT MAP(iDIG => seg7_in4,
		 oSEG => HEX_out0(6 DOWNTO 0));

b2v_inst5 : dig2dec
PORT MAP(		 vol => "1101010110101010",
		 seg0 => seg7_in4,
		 seg1 => seg7_in3,
		 seg2 => seg7_in2,
		 seg3 => seg7_in1,
		 seg4 => seg7_in0);

b2v_inst7 : fetch
PORT MAP(clock => clock,
     fallback_index => fetFB_i,
		 flags => fetFlags,
		 jump_index => fetJump_i,
		 last_index => fetLast_i,
		 index => fetIndex);


b2v_inst9 : decoder
PORT MAP(reset => reset,
		 clock => clock,
		 instruction => fetIndex,
		 addrDest => decAddrD,
		 imm => decImm,
		 selR => decSelR,
		 addrA => decAddrA,
		 addrB => decAddrB,
		 enable => decEnable);

b2v_inst6 : alu
PORT MAP(clock => clock,
     A => decA,
     B => decB,
     selR => decSelR,
     zero_flag => aluZero_f,
     result => aluResult);

b2v_inst8 : register_file
PORT MAP(clock => clock,
		 reset => reset,
		 enable => decEnable,
		 addrDest => decAddrD,
		 addrA => decAddrA,
		 addrB => decAddrB,
		 data_in => aluResult,
		 outA => rfOutA,
		 outB => rfOutB);


HEX0 <= HEX_out0;
HEX1 <= HEX_out1;
HEX2 <= HEX_out2;
HEX3 <= HEX_out3;
HEX4 <= HEX_out4;
HEX5(7) <= one;
HEX5(6) <= one;
HEX5(5) <= one;
HEX5(4) <= one;
HEX5(3) <= one;
HEX5(2) <= one;
HEX5(1) <= one;
HEX5(0) <= one;

zero <= '0';
one <= '1';
HEX_out0(7) <= '1';
HEX_out1(7) <= '1';
HEX_out2(7) <= '1';
HEX_out3(7) <= '1';
HEX_out4(7) <= '1';

LEDR <= SW;

END bdf_type;