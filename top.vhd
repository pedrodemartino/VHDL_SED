LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

--DUDAS:
-- El reset va a todos los elementos o solo a la fsm?
-- Lo de las entradas en forma de vector: ¿cómo lo traducimos a elementos físicos? Pulsadores, luces, botones...

entity top is
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
end top;

architecture structural of top is

-- DECLARACIÓN DE LOS COMPONENTES

    component SYNCHRNZR -- Sincronizador (solo emplearemos uno, al que tendrán que ir las 5 entradas en un vector)
        port(
         CLK : in std_logic;
         ASYNC_IN : in std_logic;
         SYNC_OUT : out std_logic
        );
    end component;

    component EDGEDTCTR -- Edge Counter (igual que con el Sincronizador)
        port (
         CLK : in std_logic;
         SYNC_IN : in std_logic;
         EDGE : out std_logic
        );
    end component;

    component PREESCALER
        port(
         CLK100MHZ: 	in STD_LOGIC; --Relog de entrada
	     CLKOUT:		out STD_LOGIC --Relog de salida
        );
    end component;

    component fsm
         port (
          clk : in std_logic;
          reset : in std_logic; --todo a rojo, estado S2
          clkout : in std_logic;
          sensor : in std_logic;
          p1a : in std_logic;
          p1b : in std_logic;
          p2a : in std_logic;
          p2b : in std_logic;
          sal : out std_logic_vector (9 downto 0)
         );
    end component;

    component INTERMITTENT
        port(
         clk : in std_logic;
         sal : in std_logic_vector (9 downto 0);
         INTERM : out std_logic_vector (9 downto 0)
        );
    end component;
-- DECLARACIÓN DE LAS SEÑALES

    --signal clk : std_logic;
    
    signal sync_p1a : std_logic;
    signal sync_p1b : std_logic;
    signal sync_p2a : std_logic;
    signal sync_p2b : std_logic;
    signal sync_sensor : std_logic;
    
    signal edge_p1a : std_logic;
    signal edge_p1b : std_logic;
    signal edge_p2a : std_logic;
    signal edge_p2b : std_logic;
    signal edge_sensor : std_logic;
    
    signal SALIDA_FSM : std_logic_vector(9 downto 0);
    
    signal clkout : std_logic;
    


begin

-- INSTANCIACIÓN DE COMPONENTES 

    --Sincronizador P1A
    Inst_SYNCHRNZR_p1a : SYNCHRNZR port map(
    CLK => CLOCK,
    ASYNC_IN => P1A, -- Entra directamente desde el exterior el vector de entradas
    SYNC_OUT => sync_p1a
    );

    --Edge Counter P1A
    Inst_EDGEDTCTR_p1a : EDGEDTCTR port map(
    CLK => CLOCK,
    SYNC_IN => sync_p1a, -- Entra el vector de salida del sincronizador
    EDGE => edge_p1a
    );
    
    --Sincronizador P1B
    Inst_SYNCHRNZR_p1b : SYNCHRNZR port map(
    CLK => CLOCK,
    ASYNC_IN => P1B, -- Entra directamente desde el exterior el vector de entradas
    SYNC_OUT => sync_p1b
    );

    --Edge Counter P1B
    Inst_EDGEDTCTR_p1b : EDGEDTCTR port map(
    CLK => CLOCK,
    SYNC_IN => sync_p1b, -- Entra el vector de salida del sincronizador
    EDGE => edge_p1b
    );
    
    --Sincronizador P2A
    Inst_SYNCHRNZR_p2a : SYNCHRNZR port map(
    CLK => CLOCK,
    ASYNC_IN => P2A, -- Entra directamente desde el exterior el vector de entradas
    SYNC_OUT => sync_p2a
    );

    --Edge Counter P2A
    Inst_EDGEDTCTR_p2a : EDGEDTCTR port map(
    CLK => CLOCK,
    SYNC_IN => sync_p2a, -- Entra el vector de salida del sincronizador
    EDGE => edge_p2a
    );
    
    --Sincronizador P2B
    Inst_SYNCHRNZR_p2b : SYNCHRNZR port map(
    CLK => CLOCK,
    ASYNC_IN => P2B, -- Entra directamente desde el exterior el vector de entradas
    SYNC_OUT => sync_p2b
    );

    --Edge Counter P2B
    Inst_EDGEDTCTR_p2b : EDGEDTCTR port map(
    CLK => CLOCK,
    SYNC_IN => sync_p2b, -- Entra el vector de salida del sincronizador
    EDGE => edge_p2b
    );
    
    --Sincronizador SENSOR
    Inst_SYNCHRNZR_sensor : SYNCHRNZR port map(
    CLK => CLOCK,
    ASYNC_IN => SENSOR, -- Entra directamente desde el exterior el vector de entradas
    SYNC_OUT => sync_sensor
    );

    --Edge Counter SENSOR
    Inst_EDGEDTCTR_sensor : EDGEDTCTR port map(
    CLK => CLOCK,
    SYNC_IN => sync_sensor, -- Entra el vector de salida del sincronizador
    EDGE => edge_sensor
    );
    
    inst_PREESCALER : PREESCALER port map(
    clk100mhZ => clock,
    clkout => clkout
    );
    
    --Maquina de Estados (Cruce)
    Inst_fsm : fsm port map(
    clk => CLOCK,
    reset => RESET,
    sensor => edge_sensor,
    CLKOUT => clkout,
    p1a => edge_p1a,
    p1b => edge_p1b,
    p2a => edge_p2a,
    p2b => edge_p2b,    
    sal => SALIDA_FSM-- Sale directamente al exterior el vector de salidas
    );
    Inst_Intermittent: INTERMITTENT port map(
    clk => clkout,
	sal => SALIDA_FSM,
	INTERM => SALIDA_INTER
    );
    
    ---
    process(clock)
    begin
    if rising_edge(clock) then
        clkou <= clkout;
    end if;
    end process;
    
