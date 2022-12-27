library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COUNTER is
    generic(
        WIDTH : positive
    );
    port(
        CLK     : in  std_logic;  -- Señal de reloj
        RESET_N : in  std_logic;  -- Reset negado
        MAX     : in  unsigned(WIDTH - 1 DOWNTO 0);  -- Indica hasta cuando hay que contar
        COUT    : out unsigned(WIDTH - 1 DOWNTO 0)   -- Salida cuenta
    );
end entity COUNTER;

architecture BEHAVIORAL of COUNTER is
    signal CI : unsigned(COUT'range);
begin
    CONTADOR: process (CLK, RESET_N)
    begin
        if RESET_N = '0' then
            CI <= (others => '0');
        elsif rising_edge(CLK) then
            if CI < MAX then
                CI <= CI + 1;
            else
                CI <= (others => '0');
            end if;
        end if;
    end process;
    COUT <= CI;
end BEHAVIORAL;
