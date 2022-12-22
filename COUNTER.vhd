library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

entity COUNTER is
generic(
		WIDTH : positive :=8 -- de esta manera podemos contar hasta 2 a la 5
	);
	port(
		MAX: std_logic_vector (WIDTH-1 DOWNTO 0):= "00000000"; --Indica hasta cuando hay que contar
		RESET  : in std_logic; --Reset negado
		CLKOUT : in std_logic; --Senal de reloj
		COUT : out std_logic_vector (WIDTH-1 DOWNTO 0)
	);
end COUNTER;

architecture E1 of COUNTER is
    signal CI : std_logic_vector (cout'range) := "00000000"; --Valor inicial para 5 digitos 
begin
    CONTADOR:process(CLKOUT, reset)
        begin
            if RESET = '1' then
                    CI <= (OTHERS => '0');
            elsif rising_edge(CLKOUT) then
                    if	(CI < MAX) then
                        CI <= CI + 1; --el contador aumenta si valor con cada flanco de reloj
                    elsif (CI >= MAX) then
                        CI <= (others => '0'); --si el contador tiene un valor igual al mÃ¡ximo entonces se resetea
                    end if;
            else
                CI <= CI; --No se si esta parte es necesaria
            end if;
end process;
    COUT <= CI;		
end E1;

