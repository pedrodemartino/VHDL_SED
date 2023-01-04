
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity top_tb is
end top_tb;

architecture a1 of top_tb is
    component top
        port(
        P1A : in std_logic;
        P1B : in std_logic;
        P2A : in std_logic;
        P2B : in std_logic;
        SENSOR : in std_logic; -- Sensor de presencia de coche (carretera 1)
        CLOCK : in std_logic;
        RESET : in std_logic; -- Reset total(si se pulsa, todos los semáforos pasan a estar en rojo) ???
        -- De igual manera, quizá sea conveniente establecer las salidas UN SOLO VECTOR (así lo hemos establecido en la mFSM
        SALIDA_INTER : out std_logic_vector (9 downto 0);
        clkou : out std_logic
        );
    end component;

    signal P1A : std_logic;
    signal P1B : std_logic;
    signal P2A : std_logic;
    signal P2B : std_logic;
    signal SENSOR : std_logic; -- Sensor de presencia de coche (carretera 1)
    signal CLOCK : std_logic;
    signal RESET : std_logic; -- Reset total(si se pulsa, todos los semáforos pasan a estar en rojo) ???        
    signal SALIDA_INTER : std_logic_vector (9 downto 0);
    
    signal clkou : std_logic;
    
    
    constant k: time := 10 ns;
    constant k1: time := 1 ms;
    
begin

    uut: top port map(
        p1a => p1a,
        p1b => p1b,
        p2a => p2a,
        p2b => p2b,
        sensor => sensor,
        clock => clock,
        reset => reset,
        SALIDA_INTER => SALIDA_INTER,
        clkou => clkou
    );

    clk : process
    begin
        clock <= '0';
        wait for k / 2;
        clock <= '1';
        wait for k / 2;
    end process;
    
    reset <= '0';
    p2a <= '0';
    p1a <= '0';
    p1b <= '0'; 
    p2b <= '0';
    
    a: process
    begin
         sensor <= '0';
         wait for 100 * k1;
         sensor <= '1';
         wait for 10 * k1;
         sensor <= '0';
         wait for 100000 * k1;
    end process;
        
end a1;
