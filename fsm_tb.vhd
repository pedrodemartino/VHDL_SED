library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity fsm_tb is
end fsm_tb;

architecture Behavior of fsm_tb is
    component fsm
        port(
          clk    : in std_logic;
          reset  : in std_logic; --todo a rojo, estado SR
          sensor : in std_logic;
          p1a    : in std_logic;
          p1b    : in std_logic;
          p2a    : in std_logic;
          p2b    : in std_logic;
          sal    : out std_logic_vector (9 downto 0)
        );
     end component;
    
     signal clk : std_logic;
     signal reset  : std_logic; --todo a rojo, estado SR
     signal sensor : std_logic;
     signal p1a    : std_logic;
     signal p1b    : std_logic;
     signal p2a    : std_logic;
     signal p2b    : std_logic;
     signal sal    : std_logic_vector (9 downto 0);
     
     constant k: time := 10 ns;
     
begin

    uut:  fsm port map(
        clk => clk,
        reset => reset,
        sensor => sensor,
        p1a => p1a,
        p1b => p1b,
        p2a => p2a,
        p2b => p2b,
        sal => sal
    );
    
    clock : process
    begin
        clk <= '0';
        wait for k / 2;
        clk <= '1';
        wait for k / 2;
    end process;
    
    reset <= '0', '1' after 11 * k;
    
    sensor <= '0';
    p1a <= '0';
    p1b <= '0';
    p2a <= '0';
    p2b <= '0';
    
end Behavior;
