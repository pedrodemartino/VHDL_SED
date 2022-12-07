library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

entity COUNTER is
generic(
		WIDTH : positive :=5 -- de esta manera podemos contar hasta 2 a la 5
	);
	port(
		MAX: std_logic_vector (WIDTH-1 DOWNTO 0); --Indica hasta cuando hay que contar
		RESET_N  : in std_logic; --Reset negado
		CLK : in std_logic; --Señal de reloj
		COUT : out std_logic_vector (WIDTH-1 DOWNTO 0)
	);
end COUNTER;

architecture E1 of COUNTER is
    signal CI : std_logic_vector (cout'range) := "00000"; --Valor inicial para 5 digitos 
begin
    CONTADOR:process(clk, reset_n)
        begin
            if RESET_N = '0' then
                    CI <= (OTHERS => '0');
            elsif rising_edge(CLK) then
                    if	(CI < MAX) then
                        CI <= CI + 1; --el contador aumenta si valor con cada flanco de reloj
                    elsif (CI = MAX) then
                        CI <= (others => '0'); --si el contador tiene un valor igual al máximo entonces se resetea
                    end if;
            else
                CI <= CI; --No se si esta parte es necesaria
            end if;
end process;
    COUT <= CI;		
end E1;
