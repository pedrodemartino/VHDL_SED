library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity COUNTER_TB is
generic(
		WIDTH : positive :=5 -- de esta manera podemos contar hasta 2 a la 5
	);
end COUNTER_TB;

architecture Behavior of COUNTER_TB is
component COUNTER
    port (
        MAX: std_logic_vector (WIDTH-1 DOWNTO 0); --Indica hasta cuando hay que contar
		RESET_N  : in std_logic; --Reset negado
		CLK : in std_logic; --Señal de reloj
		COUT : out std_logic_vector (WIDTH-1 DOWNTO 0)
        );
end component;

        signal MAX: std_logic_vector (WIDTH-1 DOWNTO 0);
		signal RESET_N  : std_logic;
		signal CLK : std_logic;
		signal COUT : std_logic_vector (WIDTH-1 DOWNTO 0);
		
		constant k: time := 200 ms;
begin
uut: COUNTER port map(
    MAX => MAX,
	RESET_N => RESET_N,
	CLK => CLK,
	COUT => COUT
);

    CLOCK: process    
    begin
        clk <= '0';
        wait for k / 2;
        clk <= '1';
        wait for k / 2;
    end process;
    
    
    max <= "01010";
    
    P1: process
    begin
        wait for 12*k;
        reset_n <= '0';
    end process;
    
end Behavior;
