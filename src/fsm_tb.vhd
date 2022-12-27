library ieee;
use ieee.std_logic_1164.all;

entity FSM_TB is
end FSM_TB;

architecture TESTBENCH of FSM_TB is
    component fsm
        port(
            CLK     : in  std_logic;
            RESET_N : in  std_logic; --todo a rojo, estado SR
            SENSOR  : in  std_logic;
            P1      : in  std_logic;
            P2      : in  std_logic;
            SAL     : out std_logic_vector(9 downto 0)
        );
    end component;

    signal clk     : std_logic;
    signal reset_n : std_logic; --todo a rojo, estado SR
    signal sensor  : std_logic;
    signal p1      : std_logic;
    signal p2      : std_logic;
    signal sal     : std_logic_vector(9 downto 0);

    constant CLK_FREQ   : positive := 10;
    constant CLK_PERIOD : time := 1 sec / CLK_FREQ;

begin
    uut: fsm port map(
            CLK     => clk,
            RESET_N => reset_n,
            SENSOR  => sensor,
            P1      => p1,
            P2      => p2,
            SAL     => sal
        );

    clockgen: process
    begin
        clk <= '0';
        wait for 0.5 * CLK_PERIOD;
        clk <= '1';
        wait for 0.5 * CLK_PERIOD;
    end process;

    stimgen: process
    begin
        sensor <= '0';
        p1     <= '0';
        p2     <= '0';

        reset_n <= '0' after 0.25 * CLK_PERIOD, '1' after 0.75 * CLK_PERIOD;

        wait until reset_n = '1';
        p2 <= '1', '0' after 100 * CLK_PERIOD;

        wait for 3000 * CLK_PERIOD;
        assert false
            report "[PASS]: simulation finished."
            severity failure;
    end process;

end TESTBENCH;
