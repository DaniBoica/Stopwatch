
--------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
ENTITY stopwatch_fsm IS
	PORT (
		clk : IN STD_LOGIC;
		Btn_SS : IN STD_LOGIC;
		Btn_LC : IN STD_LOGIC;
		cnt_reset : OUT STD_LOGIC;
		cnt_enable : OUT STD_LOGIC;
		disp_enable : OUT STD_LOGIC
	);
END stopwatch_fsm;
--------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF stopwatch_fsm IS
	--------------------------------------------------------------------------------

	SIGNAL SS : STD_LOGIC;
	SIGNAL LC : STD_LOGIC;

	TYPE t_state IS (st_Idle, st_Run, st_Lap, st_Refresh, st_Stop);
	SIGNAL pres_state : t_state := st_Idle;
	SIGNAL next_state : t_state;

	SIGNAL disp_EN : STD_LOGIC;
	SIGNAL cnt_EN : STD_LOGIC;
	SIGNAL cnt_rst : STD_LOGIC;
	--------------------------------------------------------------------------------
BEGIN
	--------------------------------------------------------------------------------

	SS <= Btn_SS;
	LC <= Btn_LC;

	PROCESS (pres_state, SS, LC) BEGIN
		CASE pres_state IS
			WHEN st_Idle => IF SS = '1' THEN
				                next_state <= st_Run;
			                 ELSIF LC = '1' THEN
				                next_state <= st_Idle;
			                 ELSE
			                     next_state <= st_Idle;
		                     END IF;
		WHEN st_Run => IF SS = '1' THEN
		next_state <= st_Stop;
	ELSIF LC = '1' THEN
		next_state <= st_Lap;
	ELSE next_state <= st_Run;
	END IF;
	WHEN st_Lap => IF SS = '1' THEN
	next_state <= st_Run;
ELSIF LC = '1' THEN
	next_state <= st_Refresh;
ELSE next_state <= st_Lap;
END IF;

WHEN st_Refresh => next_state <= st_Lap;

WHEN st_Stop => IF SS = '1' THEN
next_state <= st_Run;
ELSIF LC = '1' THEN
next_state <= st_Idle;
ELSE next_state <= st_Stop;
END IF;

END CASE;
END PROCESS;

PROCESS (clk) BEGIN
	IF rising_edge(clk) THEN
		pres_state <= next_state;
	END IF;
END PROCESS;

PROCESS (pres_state) BEGIN
	CASE pres_state IS
		WHEN st_Idle => cnt_rst <= '1';
			cnt_EN <= '0';
			disp_EN <= '1';

		WHEN st_Run => cnt_rst <= '0';
			cnt_EN <= '1';
			disp_EN <= '1';

		WHEN st_Lap => cnt_rst <= '0';
			cnt_EN <= '1';
			disp_EN <= '0';

		WHEN st_Refresh => cnt_rst <= '0';
			cnt_EN <= '1';
			disp_EN <= '1';

		WHEN st_Stop => cnt_rst <= '0';
			cnt_EN <= '0';
			disp_EN <= '1';
	END CASE;
END PROCESS;

PROCESS (clk) BEGIN
	IF rising_edge(clk) THEN
		disp_enable <= disp_EN;
		cnt_reset <= cnt_rst;
		cnt_enable <= cnt_EN;
	END IF;
END PROCESS;

--------------------------------------------------------------------------------
END Behavioral;
--------------------------------------------------------------------------------