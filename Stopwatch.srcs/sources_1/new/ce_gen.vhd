----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
----------------------------------------------------------------------------------
ENTITY ce_gen IS
	GENERIC (
		DIV_FACT : POSITIVE := 2 -- clock division factor
	);
	PORT (
		CLK : IN STD_LOGIC; -- clock signal
		SRST : IN STD_LOGIC; -- synchronous reset
		CE_IN : IN STD_LOGIC; -- input clock enable
		CE_OUT : OUT STD_LOGIC -- clock enable output
	);
END ce_gen;
----------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF ce_gen IS
	SIGNAL cnt_sig : INTEGER RANGE 0 TO DIV_FACT := 0;
BEGIN
	PROCESS (clk) BEGIN

	IF rising_edge(clk) THEN
		IF SRST = '1' THEN
			CE_OUT <= '0';
			cnt_sig <= 0;
		ELSIF CE_IN = '1' THEN
			IF cnt_sig = DIV_FACT THEN
				CE_OUT <= '1';
				cnt_sig <= 0;
			ELSE
				cnt_sig <= cnt_sig + 1;
				CE_OUT <= '0';
			END IF;
		ELSE
			CE_OUT <= '0';
		END IF;
	END IF;

END PROCESS;
 
 
 
END Behavioral;