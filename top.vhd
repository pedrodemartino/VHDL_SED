library ieee;
use ieee.std_logic_1164.all;

--DUDAS:
-- El reset va a todos los elementos o solo a la fsm?
-- Lo de las entradas en forma de vector: ¿cómo lo traducimos a elementos físicos? Pulsadores, luces, botones...

entity TOP is
    generic (
        FREQ_IN : positive := 100_000_000
    );
    port(
        CLK100MHZ  : in  std_logic; -- Reloj de la Nexys4 DDR
        CPU_RESETN : in  std_logic; -- Reset global (si se pulsa, todos los semáforos pasan a estar en rojo) ???
--        P1A        : in  std_logic;
--        P1B        : in  std_logic;
--        P2A        : in  std_logic;
--        P2B        : in  std_logic;
--        P1 : in std_logic; -- Pulsador del paso de peatones 1
--        P2 : in std_logic; -- Pulsador del paso de peatones 2
--        SENSOR     : in  std_logic; -- Sensor de presencia de coche (carretera 1)
--        -- Seguramente haya que poner todas las entradas como UN SOLO VECTOR (para no emplear 5 elementos de cada tipo)
--        ENTRADAS : in std_logic_vector (4 downto 0);
--        -- ENTRADAS[0] = P1A, ENTRADAS[1] = P1B, ENTRADAS[2] = P2A, ENTRADAS[3] = P2B, ENTRADAS[4] = SENSOR
--        SP1 : out std_logic_vector (1 downto 0); -- Semaforo peatones 1 (rojo, verde)
--        SP2 : out std_logic_vector (1 downto 0); -- Semáforo peatones 2 (rojo, verde)
--        S1 : out std_logic_vector (2 downto 0); -- Semáforo carretera 1 (rojo, ámbar, verde)
--        S2 : out std_logic_vector (2 downto 0) -- Semáforo carretera 2 (rojo, ámbar, verde)
--        -- De igual manera, quizá sea conveniente establecer las salidas UN SOLO VECTOR (así lo hemos establecido en la mFSM
--        -- SALIDAS[0] = P1 ROJO, SALIDAS[1] = P1 ÁMBAR, SALIDAS[2] = P1 VERDE
--        -- SALIDAS[3] = P2 ROJO, SALIDAS[4] = P2 ÁMBAR, SALIDAS[5] = P2 VERDE
--        -- SALIDAS[6] = SP1 ROJO, SALIDAS[7] = SP1 VERDE
--        -- SALIDAS[8] = SP2 ROJO, SALIDAS[9] = SP2 VERDE
        BTNC       : in  std_logic;  -- Sensor coche
        BTNL       : in  std_logic;  -- Botón peatón S1
        BTNR       : in  std_logic;  -- Botón peatón S2
        LED        : out std_logic_vector(15 downto 0);  -- Semáforos peatones
        LED16_B    : out std_logic;  -- SC1: semáforo coches 1
        LED16_G    : out std_logic;
        LED16_R    : out std_logic;
        LED17_B    : out std_logic;  -- SC2: semáforo coches 2
        LED17_G    : out std_logic;
        LED17_R    : out std_logic
    );
end TOP;

architecture STRUCTURAL of TOP is

    -- DECLARACIÓN DE LOS COMPONENTES
    component PRESCALER is
        generic (
            FREQ_IN  : positive;
            FREQ_OUT : positive
        );
        port (
            CLKIN    : in  std_logic;
            CLKOUT   : out std_logic
        );
    end component;

    component SYNCHRNZR -- Sincronizador (solo emplearemos uno, al que tendrán que ir las 5 entradas en un vector)
        port(
            CLK      : in  std_logic;
            ASYNC_IN : in  std_logic;
            SYNC_OUT : out std_logic
        );
    end component;

    component EDGEDTCTR -- Edge Counter (igual que con el Sincronizador)
        port (
            CLK     : in  std_logic;
            SYNC_IN : in  std_logic;
            EDGE    : out std_logic
        );
    end component;

    component FSM
        port (
            CLK     : in std_logic;
            RESET_N : in std_logic;
            SENSOR  : in std_logic;
            P1      : in std_logic;
            P2      : in std_logic;
            SAL     : out std_logic_vector(9 downto 0)
        );
    end component;

    -- DECLARACIÓN DE LAS SEÑALES
    signal sys_clk      : std_logic;  -- Reloj del sistema

    signal async_inputs : std_logic_vector(2 downto 0);
    signal input_events : std_logic_vector(2 downto 0);
    signal salidas      : std_logic_vector(9 downto 0);

    alias p1_event      : std_logic is input_events(2);
    alias p2_event      : std_logic is input_events(1);
    alias sensor_event  : std_logic is input_events(0);
    
begin
    -- Apagar los LED no utilizados
    LED(15 downto 6) <= (others => '0');
    LED( 3 downto 2) <= (others => '0');
    LED16_B <= '0';
    LED17_B <= '0';

    -- Conectar LED semáforos
    (LED(5), LED(4), LED(1), LED(0)) <= salidas(9 downto 6);  -- Peatones 1 y 2
    
    LED16_G <= salidas(2) or salidas(1);  -- Coches 1
    LED16_R <= salidas(0) or salidas(1);

    LED17_G <= salidas(5) or salidas(4);  -- Coches 2
    LED17_R <= salidas(3) or salidas(4);

    prescaler0: PRESCALER
        generic map (
            FREQ_IN  => FREQ_IN,  -- Reloj placa
            FREQ_OUT => 10        -- Reloj interno 10Hz
        )
        port map (
            CLKIN  => CLK100MHZ,
            CLKOUT => sys_clk
        );

    -- Agrupamiento entradas para facilitar acondicionamiento
    async_inputs <= (BTNL, BTNR, BTNC);

    -- Acondicionamiento de entradas
    input_conditioners: for i in async_inputs'range generate
        signal syncd_input : std_logic;
    begin
        synchro_i: SYNCHRNZR
            port map(
                CLK      => sys_clk,
                ASYNC_IN => async_inputs(i),
                SYNC_OUT => syncd_input
            );
        edgedtctr_i: EDGEDTCTR
            port map(
                CLK     => sys_clk,
                SYNC_IN => syncd_input,
                EDGE    => input_events(i)
            );
    end generate;

    -- Máquina de Estados (Cruce)
    fsm0: FSM
        port map(
            CLK     => sys_clk,
            RESET_N => CPU_RESETN,
            P1      => p1_event,
            P2      => p2_event,
            SENSOR  => sensor_event,
            SAL     => SALIDAS
        );
end STRUCTURAL;
