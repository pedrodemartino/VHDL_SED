library ieee;
use ieee.std_logic_1164.all;

entity PRESCALER_TB is
end PRESCALER_TB;

architecture TESTBENCH of PRESCALER_TB is

    component PRESCALER
        generic (
            FREQ_IN  : positive;
            FREQ_OUT : positive
        );
        port (
            CLKIN    : in  std_logic;
            CLKOUT   : out std_logic
        );
    end component;

    signal clkin  : std_logic;  -- Relog de entrada
    Signal clkout : std_logic;  -- Relog de salida

    constant FREQ_IN    : positive := 100_000_000;
    constant FREQ_OUT   : positive :=  10_000_000;
    constant CLK_PERIOD : time := 1 sec / FREQ_IN;

begin
    uut: PRESCALER
        generic map (
            FREQ_IN  => FREQ_IN,
            FREQ_OUT => FREQ_OUT
        )
        port map(
            CLKIN  => clkin,
            CLKOUT => clkout
        );

    clkgen: process
    begin
        clkin <= '0';
        wait for 0.5 * CLK_PERIOD;
        clkin <= '1';
        wait for 0.5 * CLK_PERIOD;
    end process;

    stimgen: process
    begin
        wait for 4 sec / FREQ_OUT;
        assert false
            report "[PASS]: simulation finished."
            severity failure;
    end process;
end TESTBENCH;
