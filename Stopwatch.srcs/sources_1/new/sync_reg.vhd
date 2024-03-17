----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2022 12:54:59 PM
-- Design Name: 
-- Module Name: sync_reg - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync_reg is

PORT( 
clock : IN STD_LOGIC;
sig_in : IN STD_LOGIC;
sig_out: OUT STD_LOGIC
);

end sync_reg;


architecture Behavioral of sync_reg is

SIGNAL sreg : std_logic;

begin

PROCESS (clock) BEGIN
IF rising_edge(clock) THEN
sreg <= sig_in;
END IF;
END PROCESS; 

PROCESS (clock) BEGIN
IF rising_edge(clock) THEN
sig_out <= sreg;
END IF;
END PROCESS; 


end Behavioral;
