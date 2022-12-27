library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- DUDAS y COSAS POR HACER:
-- Asignar tiempos: El valor de los tiempos se da en binario, siendo el número de flancos de reloj que representa ese tiempo.
-- Lo del WIDTH del counter
-- Aclarar lista de sensibilidad

entity FSM is
    port(
        CLK     : in std_logic;
        RESET_N : in std_logic; --todo a rojo, estado SR
        SENSOR  : in std_logic;
        P1      : in std_logic;
        P2      : in std_logic;
        SAL     : out std_logic_vector (9 downto 0)
    );
end entity FSM;

architecture BEHAVIORAL of FSM is

    constant COUNTER_WIDTH : positive := 10;  -- Capacidad hasta 102,4 s (reloj 10Hz)

    -- DECLARACION DE COMPONENTES
    component COUNTER
        generic(
            WIDTH   : positive
        );
        port(
            CLK     : in  std_logic; -- Entra el clock que sale del counter
            RESET_N : in  std_logic;
            MAX     : in  unsigned(WIDTH - 1 downto 0);
            COUT    : out unsigned(WIDTH - 1 downto 0)
        );
    end component;

    -- DECLARACIÓN DE ESTADOS (Y SUS SEÑALES)
    type Estados is (S0, S0I, S1, S2A, S2B, S3, S3I, S4, S5, S5I, S6, S6I, SR);
    signal actual : Estados;
    signal prox   : Estados;

    -- DECLARACIÓN DE SEÑALES
    signal tiempo1 : unsigned(COUNTER_WIDTH - 1 downto 0);
    signal tiempo2 : unsigned(COUNTER_WIDTH - 1 downto 0);
    signal max1    : unsigned(COUNTER_WIDTH - 1 downto 0);
    signal max2    : unsigned(COUNTER_WIDTH - 1 downto 0);
    signal sen     : std_logic;

begin
    --INSTANCIACION DE COMPONENTES
    counter1: COUNTER
        generic map(
            WIDTH   => COUNTER_WIDTH
        )
        port map(
            CLK     => CLK,
            RESET_N => RESET_N,
            MAX     => max1,
            COUT    => tiempo1
        );

    counter2: COUNTER
        generic map(
            WIDTH   => COUNTER_WIDTH
        )
        port map(
            CLK     => CLK,
            RESET_N => RESET_N,
            MAX     => max2,
            COUT    => tiempo2
        );

    --PROCESOS
    reg_estado: process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET_N = '0' then
                actual <= SR; -- Hemos establecido un estado de reset SR
            else
                actual <= prox;
            end if;
        end if;
    end process reg_estado;

    -- Para coches: Rojo: 001, Ámbar: 010, Verde: 100
    -- Para peatones: Rojo: 01, Verde: 10, Apagado (para el parpadeo): 00
    -- Rural/Carretera/Peatón_Rural/Peatón_Carretera
    -- Semáforo1/Semáforo2/SemáforoPeatones1/SemáforoPeatones2
    -- Significado de los estados:
    -- Estado S0: rojo/verde/rojo/rojo PERMITE PULSADORES
    -- Estado S0i: rojo/verde/rojo/rojo NO PERMITE PULSADORES
    -- Estado S1: rojo/Ámbar/rojo/rojo
    -- Estado S2: rojo/rojo/rojo/rojo (Corresponde al proceso de S1->S2a->S3)
    -- Estado S2b : rojo/rojo/rojo/rojo (Corresponde al proceso de S4->S2b->S0)
    -- Estado S3: verde/rojo/rojo/rojo PERMITE PULSADORES
    -- Estado S3i: verde/rojo/rojo/rojo NO PERMITE PULSADORES
    -- Estado S4: Ámbar/rojo/rojo/rojo
    -- Estado S5: verde/rojo/rojo/verde
    -- Estado s5i: verde/rojo/rojo/parpadeo verde
    -- Estado S6: rojo/verde/verde/rojo
    -- Estado S6i: rojo/verde/parpadeo verde/rojo
    -- Estado SR: estado de reset (todo rojo)
    decodificador: process(SENSOR, P1, P2, tiempo1, tiempo2, actual)
    begin
        prox <= actual;           -- Permanecer en el estado actual si no hay cambios 
        max1 <= (others => '0');  -- Asegura counter 1 reiniciado
        max2 <= (others => '0');  -- Asegura counter 2 reiniciado
        SAL  <= (others => '0');  -- LEDs apagados por defecto

        case actual is

            when S0 =>
                -- Estado siguiente
                if tiempo1 = 99 then
                    prox <=  S0i;
                elsif sensor = '1' or p2 = '1' then
                    prox <= S1;
                elsif p1 = '1' then -- TIEMPO ROJO EXTRA
                    prox <= S6;
                end if;
                -- Salidas
                SAL  <= "0011000101";
                max1 <= to_unsigned(100, max1'length);

            when S1 =>
                -- Estado siguiente
                if tiempo2 = 199 then -- Tiempo ambar 2
                    prox <= S2A;
                end if;
                -- Salidas
                SAL  <= "0010100101";
                max2 <= to_unsigned(200, max2'length);

            when S2A =>
                -- Antes la condición implicaba también a p2a y p2b. No deberían ser actual
                -- pero lo apunto por si falla.
                -- Estado siguiente
                if tiempo1 = 49 then  -- TIEMPO TODO ROJO
                    prox <= S3;
                end if;
                -- Salidas
                SAL  <= "0010010101";
                max1 <= to_unsigned(50, max1'length);

            when S3 =>
                -- Estado siguiente
                if tiempo2 = 49 then -- TIEMPO VERDE SEMAFORO 1
                    prox <= S4;
                elsif p2 = '1' then -- TIEMPO ROJO EXTRA
                    prox <= S5;
                end if;
                -- Salidas
                SAL  <= "1000010101";
                max2 <= to_unsigned(50, max2'length);

            when S4 =>
                -- Estado siguiente
                if tiempo1 = 99 then -- TIEMPO ÁMBAR
                    prox <= S2B;
                end if;
                -- Salidas
                SAL  <= "0100010101";
                max1 <= to_unsigned(100, max1'length);

            when S2B =>
                -- Estado siguiente
                if tiempo2 = 99 then -- TIEMPO TODO ROJO --Antes la condiciÃƒÂ³n implicaba tambiÃƒÂ©n a p2a y p2b. No deberÃƒÂ­an ser necesarios pero lo apunto por si falla.
                    prox <= S0;
                end if;
                -- Salidas
                SAL  <= "0010010101";
                max2 <= to_unsigned(100, max2'length);

            when S5 =>
                -- Estado siguiente
                if tiempo1 = 399 then -- TIEMPO VERDE ANTES DE INTERMITENTE
                    prox <= S5I;
                end if;
                -- Salidas
                SAL  <= "1000010110";
                max1 <= to_unsigned(400, max1'length);

            when S5I =>
                -- Estado siguiente
                if tiempo2 = 49 then -- TIEMPO PARPADEO
                    prox <= S3I;
                end if;
                -- Salidas
                sal  <= "1000010110"; -- SP1 rojo, SP2 verde encendido
                max2 <= to_unsigned(50, max2'length);

            when S6 =>
                -- Estado siguiente
                if tiempo2 = 399 then -- TIEMPO EN VERDE HASTA INTERMITENTE
                    prox <= S6I;
                end if;
                -- Salidas
                SAL  <= "0011001001";
                max2 <= to_unsigned(400, max2'length);

            when S6I =>
                -- Estado siguiente
                if tiempo1 = 49 then -- TIEMPO PARPADEO
                    prox <= S0I;
                end if;
                -- Salidas
                sal  <= "0011001001"; -- SP1 verde encendido, SP2 actual
                max1 <= to_unsigned(50, max1'length);

            when S0I =>
                -- Estado siguiente
                if sensor = '1' or p2 = '1' then
                    prox <= S1;
                end if;
                -- Salidas
                sal   <= "0011000101";
                max2 <= to_unsigned(50, max2'length);

            when S3I =>
                -- Estado siguiente
                if tiempo1 = 999 then -- TIEMPO VERDE SEMAFORO 1
                    prox <= S4;
                end if;
                -- Salidas
                sal  <= "1000010101";
                max1 <= to_unsigned(1000, max1'length);

            when others =>
                prox <= S0;

        end case;
    end process decodificador;

end architecture BEHAVIORAL;
