----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------------------------------------
ENTITY rp_top IS
	PORT (
		clk : IN STD_LOGIC;
		btn_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		sw_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
		led_o : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		disp_seg_o : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		disp_dig_o : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
	);
END rp_top;
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF rp_top IS
	----------------------------------------------------------------------------------
	SIGNAL cnt_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL cnt_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL cnt_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL cnt_3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ce_100Hz : STD_LOGIC;
	SIGNAL cnt_enable : STD_LOGIC;
	SIGNAL cnt_reset : STD_LOGIC;
	SIGNAL disp_enable : STD_LOGIC;
	SIGNAL btn_debounced : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL btn_edge_pos : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL btn_edge_neg : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL btn_edge_any : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL btn_ss : STD_LOGIC;
	SIGNAL btn_lc : STD_LOGIC;
	------------------------------------------------------------------------------

	COMPONENT seg_disp_driver
		PORT (
			clk : IN STD_LOGIC;
			dig_1_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			dig_2_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			dig_3_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			dig_4_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			dp_i : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- [DP4 DP3 DP2 DP1]
			dots_i : IN STD_LOGIC_VECTOR (2 DOWNTO 0); -- [L3 L2 L1]
			disp_seg_o : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
			disp_dig_o : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
		);
	END COMPONENT seg_disp_driver;

	----------------------------------------------------------------------------------

	COMPONENT ce_gen
		GENERIC (
			DIV_FACT : POSITIVE := 2 -- clock division factor
		);
		PORT (
			CLK : IN STD_LOGIC; -- clock signal
			SRST : IN STD_LOGIC; -- synchronous reset
			CE_IN : IN STD_LOGIC; -- input clock enable
			CE_OUT : OUT STD_LOGIC -- clock enable output
		);
	END COMPONENT ce_gen;

	COMPONENT stopwatch
		PORT (
			CLK : IN STD_LOGIC;
			CE_100HZ : IN STD_LOGIC;
			CNT_ENABLE : IN STD_LOGIC;
			DISP_ENABLE : IN STD_LOGIC;
			CNT_RESET : IN STD_LOGIC;
			CNT_0 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			CNT_1 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			CNT_2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			CNT_3 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
	END COMPONENT stopwatch;

	COMPONENT btn_in
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
	END COMPONENT btn_in;

	COMPONENT stopwatch_fsm
		PORT (
			clk : IN STD_LOGIC;
			Btn_SS : IN STD_LOGIC;
			Btn_LC : IN STD_LOGIC;
			cnt_reset : OUT STD_LOGIC;
			cnt_enable : OUT STD_LOGIC;
			disp_enable : OUT STD_LOGIC
		);
	END COMPONENT stopwatch_fsm;

BEGIN
	----------------------------------------------------------------------------------

	--------------------------------------------------------------------------------
	-- display driver
	--
	--       DIG 1       DIG 2       DIG 3       DIG 4
	--                                       L3
	--       -----       -----       -----   o   -----
	--      |     |     |     |  L1 |     |     |     |
	--      |     |     |     |  o  |     |     |     |
	--       -----       -----       -----       -----
	--      |     |     |     |  o  |     |     |     |
	--      |     |     |     |  L2 |     |     |     |
	--       -----  o    -----  o    -----  o    -----  o
	--             DP1         DP2         DP3         DP4
	--
	--------------------------------------------------------------------------------

	seg_disp_driver_a : seg_disp_driver
	PORT MAP(
		clk => clk,
		dig_1_i => cnt_3,
		dig_2_i => cnt_2,
		dig_3_i => cnt_1,
		dig_4_i => cnt_0,
		dp_i => "0000",
		dots_i => "011",
		disp_seg_o => disp_seg_o,
		disp_dig_o => disp_dig_o
	);

	--------------------------------------------------------------------------------
	-- clock enable generator
	ce_gen_a : ce_gen
	GENERIC MAP(
		DIV_FACT => 500000 -- clock division factor
	)
	PORT MAP(
		CLK => clk, -- clock signal
		SRST => '0', -- synchronous reset
		CE_IN => '1', -- input clock enable
		CE_OUT => ce_100hz -- clock enable output
	);

	--------------------------------------------------------------------------------
	-- button input module

	gen_btn_in : FOR i IN 0 TO 3 GENERATE
		btn_in_inst_a : btn_in
		GENERIC MAP(
			DEB_PERIOD => 4
		)
		PORT MAP(
			clk => clk,
			ce_100Hz => ce_100Hz,
			btn => btn_i(i),
			btn_debounced => btn_debounced(i),
			btn_edge_pos => btn_edge_pos(i),
			btn_edge_neg => btn_edge_neg(i),
			btn_edge_any => btn_edge_any(i)
		);
	END GENERATE gen_btn_in;

	--------------------------------------------------------------------------------
	-- stopwatch module (4-decade BCD counter)
	stopwatch_a : stopwatch
	PORT MAP(
		CLK => clk,
		CE_100HZ => ce_100Hz,
		CNT_ENABLE => cnt_enable,
		DISP_ENABLE => disp_enable,
		CNT_RESET => cnt_reset,
		CNT_0 => cnt_0,
		CNT_1 => cnt_1,
		CNT_2 => cnt_2,
		CNT_3 => cnt_3
	);

	--------------------------------------------------------------------------------
	-- stopwatch control FSM
	stopwatch_fsm_a : stopwatch_fsm
	PORT MAP(
		clk => clk,
		Btn_SS => btn_edge_pos(0),
		Btn_LC => btn_edge_pos(2),
		cnt_reset => cnt_reset,
		cnt_enable => cnt_enable,
		disp_enable => disp_enable
	);

	----------------------------------------------------------------------------------
END Structural;
----------------------------------------------------------------------------------