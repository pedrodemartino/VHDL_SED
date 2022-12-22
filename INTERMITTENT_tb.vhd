library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity INTERMITTENT_tb is
end INTERMITTENT_tb;

architecture A1 of INTERMITTENT_tb is
    component INTERMITTENT
        port(
          clk : in std_logic;
          tiempo : in std_logic_vector (7 downto 0);
	      sal    : in std_logic_vector (9 downto 0);
	      INTERM : out std_logic_vector (9 downto 0)
        );
     end component;
     
     signal clk : std_logic;
     signal tiempo : std_logic_vector (7 downto 0);
	 signal sal    : std_logic_vector (9 downto 0);
	 signal INTERM : std_logic_vector (9 downto 0);
         
     constant k: time := 10 ns;
    
     
begin

    uut:  INTERMITTENT port map(
          clk => CLK,
          tiempo => tiempo,
	      sal => SAL,
	      INTERM => INTERM   
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
end A1;
