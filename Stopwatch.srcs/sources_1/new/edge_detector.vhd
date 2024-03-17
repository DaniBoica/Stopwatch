

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY edge_detector IS
	PORT (
		clk : IN STD_LOGIC;
		sig_in : IN STD_LOGIC;
		edge_pos : OUT STD_LOGIC;
		edge_neg : OUT STD_LOGIC;
		edge_any : OUT STD_LOGIC
	);
END edge_detector;

ARCHITECTURE Behavioral OF edge_detector IS
	SIGNAL sig_delayed : STD_LOGIC;
BEGIN

	PROCESS (clk) BEGIN
		IF rising_edge(clk) THEN
			sig_delayed <= sig_in;
			
			IF sig_in = '1' AND sig_delayed = '0' THEN
				edge_pos <= '1';
			ELSE
			   edge_pos <= '0';
			END IF;

			IF sig_in = '0' AND sig_delayed = '1' THEN
				edge_neg <= '1';
			ELSE
			   edge_neg <= '0';
			END IF;
			
            IF ( sig_in XOR sig_delayed)= '1' THEN
				edge_any <= '1';
			ELSE
			   edge_any <= '0';
			END IF;

					
		END IF;
	END PROCESS;

END Behavioral;