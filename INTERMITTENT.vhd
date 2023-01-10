library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity INTERMITTENT is
port (
    clk : in std_logic;
	sal    : in std_logic_vector (9 downto 0);
	INTERM : out std_logic_vector (9 downto 0)
);
end INTERMITTENT;

architecture e1 of INTERMITTENT is
	--signal salaux: std_logic_vector (9 downto 0);
begin
    
process(clk,sal)
    variable salaux: std_logic_vector (9 downto 0):="1000010100";
    variable salaux2: std_logic_vector (9 downto 0):="0011001001";
    variable salaux3: std_logic_vector (9 downto 0):="0000000000";
	begin
		if rising_edge(CLK) then
			if(sal = "1111111111") then
			         if salaux = "1000010110" then
                        salaux := "1000010100"; -- SP1 rojo, SP2 todo apagado
                    else
                        salaux := "1000010110"; -- SP1 rojo, SP2 verde encendido
                    end if;
                    INTERM <= salaux;
             elsif(sal = "1111111110") then
                    if salaux2 = "0011001001" then
                        salaux2 := "0011000001"; -- SP1 rojo, SP2 todo apagado
                        
                    else
                        salaux2 := "0011001001"; -- SP1 rojo, SP2 verde encendido
                    end if;
                    INTERM <= salaux2;
			 else
	           salaux3 := sal;
	           INTERM <= salaux3;
	         end if;  	  
		end if;		
	end process;
end e1;
