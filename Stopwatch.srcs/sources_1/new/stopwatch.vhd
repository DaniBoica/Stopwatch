
----------------------------------------------------------------------------------


library IEEE;
USE IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_1164.ALL;

entity stopwatch is

  PORT (
    CLK                         : IN  STD_LOGIC;
    CE_100HZ                    : IN  STD_LOGIC;
    CNT_ENABLE                  : IN  STD_LOGIC;
    DISP_ENABLE                 : IN  STD_LOGIC;
    CNT_RESET                   : IN  STD_LOGIC;
    CNT_0                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_1                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_2                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
    CNT_3                       : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0)
  );

end stopwatch;

architecture Behavioral of stopwatch is

SIGNAL cnt0 : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');
SIGNAL cnt1 : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');
SIGNAL cnt2 : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');
SIGNAL cnt3 : UNSIGNED (3 DOWNTO 0) := (OTHERS => '0');


begin

PROCESS (clk) BEGIN
IF rising_edge(clk) THEN
IF DISP_ENABLE='1' THEN
CNT_0<=STD_LOGIC_VECTOR(cnt0);
CNT_1<=STD_LOGIC_VECTOR(cnt1);
CNT_2<=STD_LOGIC_VECTOR(cnt2);
CNT_3<=STD_LOGIC_VECTOR(cnt3);
END IF;
END IF;
END PROCESS;

BCD_counter0 : PROCESS (clk) BEGIN
	IF rising_edge(clk) THEN
	 IF CNT_RESET='1' THEN 	
	   cnt0 <= (OTHERS => '0');
		ELSIF CNT_ENABLE = '1' AND CE_100HZ='1' THEN
			IF cnt0 = X"9" THEN
				cnt0 <= (OTHERS => '0');
			ELSE
				cnt0 <= cnt0 + 1;
			END IF;
		END IF;
	END IF;
END PROCESS BCD_counter0;

BCD_counter1 : PROCESS (clk) BEGIN
	IF rising_edge(clk) THEN
	 IF CNT_RESET='1' THEN 	
	   cnt1 <= (OTHERS => '0');
		ELSIF CNT_ENABLE = '1' AND CE_100HZ='1' and CNT0=X"9" THEN
			IF cnt1 = X"9" THEN
				cnt1 <= (OTHERS => '0');
			ELSE
				cnt1 <= cnt1 + 1;
			END IF;
		END IF;
	END IF;
END PROCESS BCD_counter1;

BCD_counter2 : PROCESS (clk) BEGIN
	IF rising_edge(clk) THEN
	 IF CNT_RESET='1' THEN 	
	   cnt2 <= (OTHERS => '0');
		ELSIF CNT_ENABLE = '1' AND CE_100HZ='1' and CNT0=X"9" and CNT1=X"9" THEN
			IF cnt2 = X"9" THEN
				cnt2 <= (OTHERS => '0');
			ELSE
				cnt2 <= cnt2 + 1;
			END IF;
		END IF;
	END IF;
END PROCESS BCD_counter2;

BCD_counter3 : PROCESS (clk) BEGIN
	IF rising_edge(clk) THEN
	  IF CNT_RESET='1' THEN 	
	   cnt3 <= (OTHERS => '0');
		ELSIF CNT_ENABLE = '1' AND CE_100HZ='1' and CNT0=X"9" and CNT1=X"9" and CNT2=X"9" THEN
			IF cnt3 = X"5" THEN
				cnt3 <= (OTHERS => '0');
			ELSE
				cnt3 <= cnt3 + 1;
			END IF;
		END IF;
	END IF;
END PROCESS BCD_counter3;


end Behavioral;
