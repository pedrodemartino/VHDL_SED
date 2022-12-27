library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity COUNTER_TB is
end COUNTER_TB;

architecture TESTBENCH of COUNTER_TB is

    component COUNTER
        generic (
            WIDTH   : positive
        );
        port (
            CLK     : in  std_logic; --Señal de reloj
            RESET_N : in  std_logic; --Reset negado
            MAX     : in  unsigned(WIDTH - 1 downto 0);
            COUT    : out unsigned(WIDTH - 1 downto 0)
        );
    end component;

    constant COUNTER_WIDTH : positive := 8;

    signal clk     : std_logic;
    signal reset_n : std_logic;
    signal max     : unsigned(COUNTER_WIDTH - 1 downto 0);
    signal cout    : unsigned(COUNTER_WIDTH - 1 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    uut: COUNTER
        generic map (
            WIDTH => COUNTER_WIDTH
        )
        port map (
            CLK     => clk,
            RESET_N => reset_n,
            MAX     => max,
            COUT    => cout
        );

    clkgen: process
    begin
        clk <= '0';
        wait for 0.5 * CLK_PERIOD;
        clk <= '1';
        wait for 0.5 * CLK_PERIOD;
    end process;

    max <= to_unsigned(10, max'length);

    stimgen: process
    begin
        reset_n <= '0' after 0.25 * CLK_PERIOD, '1' after 0.75 * CLK_PERIOD;

        wait until reset_n = '0';

        wait for 12 * CLK_PERIOD;
        assert false
            report "[PASS]: simulation finished."
            severity failure;
    end process;

end TESTBENCH;
