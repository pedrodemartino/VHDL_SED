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
          CLKOUT : in std_logic;
          p1a    : in std_logic;
          p1b    : in std_logic;
          p2a    : in std_logic;
          p2b    : in std_logic;
          sal    : out std_logic_vector (9 downto 0);         
          t1     : out std_logic_vector (7 downto 0);
          t2     : out std_logic_vector (7 downto 0);
          m2     : out std_logic_vector (7 downto 0);
          p1_out : out std_logic;
          p2_out : out std_logic;
          s_out : out std_logic
        );
     end component;
    
     signal clk : std_logic;
     signal reset  : std_logic; --todo a rojo, estado SR
     signal sensor : std_logic;
     signal CLKOUT : std_logic;
     signal p1a    : std_logic;
     signal p1b    : std_logic;
     signal p2a    : std_logic;
     signal p2b    : std_logic;
     signal sal    : std_logic_vector (9 downto 0);
     signal t1    : std_logic_vector (7 downto 0);
     signal t2    : std_logic_vector (7 downto 0);
     signal m2    : std_logic_vector (7 downto 0);
     signal p1_out    : std_logic;
     signal p2_out    : std_logic;
     signal s_out    : std_logic;
     
     constant k: time := 10 ns;
     
begin

    uut:  fsm port map(
        clk => clk,
        reset => reset,
        sensor => sensor,
        clkout => clkout,
        p1a => p1a,
        p1b => p1b,
        p2a => p2a,
        p2b => p2b,
        sal => sal,
        t1 => t1,
        t2 => t2,
        m2 =>m2,
        p1_out => p1_out,
        p2_out => p2_out,
        s_out => s_out
    );
    
    clock : process
    begin
        clk <= '0';
        wait for k / 2;
        clk <= '1';
        wait for k / 2;
    end process;
    
    clockout : process
    begin
        clkout <= '0';
        wait for 10 * k / 2;
        clkout <= '1';
        wait for 10 * k / 2;
    end process;
    
    reset <= '0';
    
    p2a <= '0';
    p1a <= '0';
    p1b <= '0'; 
    p2b <= '0';
    
    process
    begin
         sensor <= '0';
         wait for 30 * k / 2;
         sensor <= '1';
         wait for 30 * k / 2;
         sensor <= '0';
         wait for 2000 * k / 2;
    end process;
    
end Behavior;
