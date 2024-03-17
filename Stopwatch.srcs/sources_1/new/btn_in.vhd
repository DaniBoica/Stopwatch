LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------

ENTITY btn_in IS
	GENERIC (
		DEB_PERIOD : POSITIVE := 3
	);
	PORT (
		clk : IN STD_LOGIC;
		ce_100Hz : IN STD_LOGIC;
		btn : IN STD_LOGIC;
		btn_debounced : OUT STD_LOGIC;
		btn_edge_pos : OUT STD_LOGIC;
		btn_edge_neg : OUT STD_LOGIC;
		btn_edge_any : OUT STD_LOGIC
	);
END btn_in;


ARCHITECTURE Behavioral OF btn_in IS

	SIGNAL sigDeb : std_logic;
	SIGNAL sigEdge : std_logic;

	--------------------------------------------------------------------------
	COMPONENT sync_reg
		PORT (
			clock : IN STD_LOGIC;
			sig_in : IN STD_LOGIC;
			sig_out : OUT STD_LOGIC
		);
	END COMPONENT sync_reg;
	

	COMPONENT debouncer
	

		GENERIC (
			shift_length : POSITIVE := 7
		);
			PORT (

		bt_in : IN STD_LOGIC;
		ce  : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		btn_out : OUT STD_LOGIC
	);
	END COMPONENT debouncer;

	COMPONENT edge_detector
		PORT (
			clk : IN STD_LOGIC;
			sig_in : IN STD_LOGIC;
			edge_pos : OUT STD_LOGIC;
			edge_neg : OUT STD_LOGIC;
			edge_any : OUT STD_LOGIC
		);
	END COMPONENT edge_detector;
	-------------------------------------------------------------------------

	SIGNAL sig_in : STD_LOGIC := '0';
	SIGNAL sig_out : STD_LOGIC := '0';
	SIGNAL btn_in : STD_LOGIC;
	SIGNAL btn_out : STD_LOGIC := '0';

	--------------------------------------------------------------------------
BEGIN
	--------------------------------------------------------------------------

	sync_reg_a : sync_reg
	PORT MAP(
		clock => clk,
		sig_in => btn,
		sig_out => sigDeb
	);

	debouncer_a : debouncer
			GENERIC MAP(
			shift_length=>5
		)
	PORT MAP(
		clk => clk,
		ce   => ce_100Hz,
		bt_in => sigDeb,
		btn_out => sigEdge
	);

	edge_detector_a : edge_detector
	PORT MAP(
		clk => clk,
		sig_in => sigEdge,
		edge_pos => btn_edge_pos,
		edge_neg => btn_edge_neg,
		edge_any => btn_edge_any
	);
    btn_debounced<=sigEdge;
END Behavioral;