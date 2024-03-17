--------------------------------------------------------

LIBRARY IEEE;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY debouncer IS
	GENERIC (
		shift_length : POSITIVE := 7
	);

	PORT (

		bt_in : IN STD_LOGIC;
		ce : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		btn_out : OUT STD_LOGIC
	);
END debouncer;

ARCHITECTURE Behavioral OF debouncer IS

	SIGNAL sigDeb : STD_LOGIC;
	SIGNAL sig :   std_logic_vector(shift_length DOWNTO 0);
	CONSTANT sig1 : std_logic_vector(shift_length DOWNTO 0) := (OTHERS => '1');
	CONSTANT sig0 : std_logic_vector(shift_length DOWNTO 0) := (OTHERS => '0');

BEGIN
	PROCESS (clk) BEGIN
	IF rising_edge(clk) THEN
		IF ce='1' THEN sig <= sig(shift_length - 1 DOWNTO 0) & bt_in;
		END IF;
		IF sig = sig1 THEN
			btn_out <= '1';
		END IF;
		IF sig = sig0 THEN
			btn_out <= '0';
		END IF;
	END IF;
END PROCESS;
END Behavioral;