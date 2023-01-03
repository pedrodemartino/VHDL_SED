library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity INTERMITTENT is
port (
    clk : in std_logic;
    tiempo : in std_logic_vector (7 downto 0);
	sal    : in std_logic_vector (9 downto 0);
	INTERM : out std_logic_vector (9 downto 0)
);
end INTERMITTENT;

architecture e1 of INTERMITTENT is
	--signal salaux: std_logic_vector (9 downto 0);
begin
    
process(clk,tiempo,sal)
    variable salaux: std_logic_vector (9 downto 0):="1000010100";
	begin
		if rising_edge(CLK) then
			if(sal = "1111111111") then
			         if salaux = "1000010110" then
                        salaux := "1000010100"; -- SP1 rojo, SP2 todo apagado
                    else
                        salaux := "1000010110"; -- SP1 rojo, SP2 verde encendido
                    end if;
			 else
	           salaux := sal;	
	         end if;
	       INTERM <= salaux;      	  
		end if;		
	end process;
end e1;
