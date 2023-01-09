
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity PREESCALER is
port (
	CLK100MHZ: 	in STD_LOGIC; --Relog de entrada
	CLKOUT:		out STD_LOGIC --Relog de salida
);
end PREESCALER;

architecture e1 of PREESCALER is
    constant MAXCOUNT : INTEGER := 25; --Divisor de frecuencia originalmente 25000000
    -- ahora mismo esta hecho para que tenga dos flancos de subida por segundo
	signal COUNT: INTEGER range 0 to MAXCOUNT; --Cuenta
	signal CLKSTATE: STD_LOGIC := '0'; --estado del relog de salida, 0 o 1
begin
CLK_GEN: process(CLK100MHZ, CLKSTATE, COUNT)
	begin
		if CLK100MHZ'event and CLK100MHZ='1' then
			if COUNT < MAXCOUNT then 
				COUNT <= COUNT+1; --Cuenta los fancos de subida del relog de entrada
			else
				CLKSTATE <= not CLKSTATE; --Invierte el valor del relog de salida
				count <= 0; --Resetea el valor del contador
			end if;
		end if;
	end process;

ASIGNACION: process (CLKSTATE)
	begin
		CLKOUT <= CLKSTATE; --Asigna el estado al relog de salida en función de el estado que debería tener
	end process;

end e1;
