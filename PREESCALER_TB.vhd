
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity PREESCALER_TB is
--  Port ( );
end PREESCALER_TB;

architecture Behavior of PREESCALER_TB is

component PREESCALER
        port (
        CLK100MHZ: 	in STD_LOGIC; --Relog de entrada
	    CLKOUT:		out STD_LOGIC --Relog de salida
        );
        end component;
        
    signal CLK100MHZ: STD_LOGIC; --Relog de entrada
	signal CLKOUT: STD_LOGIC; --Relog de salida
	
	 constant k: time := 10 ns;
	 
begin
    uut: PREESCALER port map(
        CLK100MHZ => CLK100MHZ,
        CLKOUT => CLKOUT
    );
    
    CLOCK: process
    begin
        CLK100MHZ <= '0';
        wait for k / 2;
        CLK100MHZ <= '1';
        wait for k / 2;
    end process;
    
   FIN: process
    begin
    for i in 1 to 5 loop
         wait until CLKOUT = '0';
    end loop;
     report "[SUCCESS]: simulation finished"
    severity failure;
    
    end process;
   
    
end Behavior;
