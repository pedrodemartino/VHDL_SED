library ieee;
use ieee.std_logic_1164.all;

entity INTERMITENTE_TB is
end INTERMITENTE_TB;

architecture TESTBENCH of INTERMITENTE_TB is

    component INTERMITENTE is
        port (
            CLK    : in  std_logic;
            TIEMPO : in  std_logic_vector(7 downto 0);
            SAL    : in  std_logic_vector(9 downto 0);
            INTERM : out std_logic_vector(9 downto 0)
        );
    end component;

    signal clk    : std_logic;
    signal tiempo : std_logic_vector(7 downto 0);
    signal sal    : std_logic_vector(9 downto 0);
    signal interm : std_logic_vector(9 downto 0);

    constant k : time := 10 ns;

begin
    uut: INTERMITENTE
        port map(
            CLK    => clk,
            TIEMPO => tiempo,
            SAL    => sal,
            INTERM => interm
        );

    clock : process
    begin
        clk <= '0';
        wait for k / 2;
        clk <= '1';
        wait for k / 2;
    end process;

    tiempo_t: process
    begin
        tiempo <= "00000000";
        wait until rising_edge(clk);
        tiempo <= "00000001";
        wait until rising_edge(clk);
        tiempo <= "00000010";
        wait until rising_edge(clk);
        tiempo <= "00000011";
        wait until rising_edge(clk);
        tiempo <= "00000100";
    end process;

    salida_t:process
    begin
        sal <= "1111111111";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        sal <= "0000011000";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
    end process;
end TESTBENCH;
