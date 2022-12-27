library ieee;
use ieee.std_logic_1164.all;

entity INTERMITENTE is
    port (
        CLK    : in  std_logic;
        TIEMPO : in  std_logic_vector(7 downto 0);
        SAL    : in  std_logic_vector(9 downto 0);
        INTERM : out std_logic_vector(9 downto 0)
    );
end INTERMITENTE;

architecture BEHAVIORAL of INTERMITENTE is
    --  signal salaux: std_logic_vector (9 downto 0);
begin
    process(clk,tiempo,sal)
        variable salaux : std_logic_vector(9 downto 0) := (others => '0');
    begin
        if rising_edge(CLK) then
            if SAL = "1111111111" then
                if tiempo(0) = '0' then
                    salaux := "1000010100"; -- SP1 rojo, SP2 todo apagado
                else
                    salaux := "1000010110"; -- SP1 rojo, SP2 verde encendido
                end if;
            else
                salaux := sal;
            end if;
            INTERM <= salaux;
        end if;
    end process;
end BEHAVIORAL;
