library ieee;
use ieee.std_logic_1164.all;

entity PRESCALER is
    generic (
        FREQ_IN  : positive;
        FREQ_OUT : positive
    );
    port (
        CLKIN    : in  std_logic; --Relog de entrada
        CLKOUT   : out std_logic  --Relog de salida
    );
end PRESCALER;

architecture BEHAVIORAL of PRESCALER is
    signal clkstate : std_logic := '0'; --estado del relog de salida, 0 o 1
begin
    process (CLKIN)
        constant MODULO : positive := FREQ_IN / FREQ_OUT;
        subtype count_t is integer range 0 to MODULO / 2 - 1;
        variable count : count_t;
    begin
        if rising_edge(CLKIN) then
            if COUNT = 0 then 
                clkstate <= not clkstate;  -- Invierte el valor del relog de salida
                count := count_t'high;     -- Reinicia el valor del contador
            else
                count := count - 1;        -- Cuenta los flancos de subida del relog de entrada
            end if;
        end if;
    end process;
    CLKOUT <= clkstate; --Asigna el estado al relog de salida en función de el estado que debería tene
end BEHAVIORAL;
