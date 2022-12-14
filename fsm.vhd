LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

-- DUDAS y COSAS POR HACER:
-- Asignar tiempos: El valor de los tiempos se da en binario, siendo el número de flancos de reloj que representa ese tiempo.
-- Lo del WIDTH del counter
-- Aclarar lísta de sensibilidad

entity fsm is
	port(
      clk    : in std_logic;
      reset  : in std_logic; --todo a rojo, estado SR
      sensor : in std_logic;
      --p1     : in std_logic;
      --p2     : in std_logic;
      p1a    : in std_logic;
      p1b    : in std_logic;
      p2a    : in std_logic;
      p2b    : in std_logic;
      sal    : out std_logic_vector (9 downto 0)
      );
end entity fsm;

architecture Estados of fsm is

-- DECLARACIÓN DE COMPONENTES

component COUNTER -- Contador con precarga (usaremos 2 porque en algún momento hay que tomar dos tiempos simultaneos)
port(
 CLK : in std_logic; -- Entra el clock que sale del counter
 RESET_N : in std_logic;
 MAX : in std_logic_vector (4 downto 0); -- Hasta cuanto queremos que nos cuente. --WHIDTH!!!!!!!
 COUT : out std_logic_VECTOR (4 downto 0) -- Avisa de cuando termina la cuenta de tiempo --WIDTH TAMBIEN!!!!!!
 );
end component;

component PREESCALER
port(
 CLK_IN : in std_logic; -- Reloj normal de entrada
 CLK_OUT : out std_logic -- Reloj con frecuencia adecuada
 );
end component;

--DECLARACIÓN DE ESTADOS (Y SUS SEÑALES)

type estado is (S0,S0i,S1,S2a,S2b,S3,S3i,S4,S5,S5i,S6,S6i,SR);
    signal actual : Estados;
    signal prox : Estados;
    
--DECLARACIÓN DE SEÑALES 

signal clk_s : std_logic;
signal tiempo1 : std_logic_vector (4 downto 0); --Esto va con WIDTH DOWNTO 0
signal tiempo2 : std_logic_vector (4 downto 0); --Esto va con WIDTH DOWNTO 0
signal max1 : std_logic_vector (4 downto 0); --Esto va con WIDTH DOWNTO 0
signal max2 : std_logic_vector (4 downto 0); --Esto va con WIDTH DOWNTO 0

begin

--INSTANCIACIÓN DE COMPONENTES

    Inst_PREESCALER : PREESCALER port map(
    CLK_IN => clk, -- Entra el reloj normal
    CLK_OUT => clk_s-- Sale el reloj con la frecuencia correspondiente
    );
    
    Inst_COUNTER_1 : COUNTER port map(
    MAX => max1, -- Entra la precarga que recibe desde fsm
    RESET_N => reset,
	CLK => clk_s,
	COUT => tiempo1 -- Devuelve el tiempo que lleva
    );
    
    Inst_COUNTER_2 : COUNTER port map(
    MAX => max2, -- Entra la precarga que recibe desde fsm
    RESET_N => reset,
	CLK => clk_s,
	COUT => tiempo2 -- Devuelve el tiempo que lleva
    );
    
 --PROCESOS

    Secuencial:
    	process(clk)
        begin
        if rising_edge (clk) then
          if reset = '1' then
              actual <= SR; -- Hemos establecido un estado de reset SR
          else
              actual <= prox;
          end if;
        end if;
    end process Secuencial;
    
    Combinacional:
    -- Para coches: Rojo: 001, Ámbar: 010, Verde: 100
    -- Para peatones: Rojo: 01, Verde: 10, Apagado (para el parpadeo): 00
    -- Rural/Carretera/Peatón_Rural/Peatón_Carretera
    -- Semáforo1/Semáforo2/SemáforoPeatones1/SemáforoPeatones2
    -- Significado de los estados:
    -- Estado S0: rojo/verde/rojo/rojo PERMITE PULSADORES
    -- Estado S0i: rojo/verde/rojo/rojo NO PERMITE PULSADORES
    -- Estado S1: rojo/ámbar/rojo/rojo
    -- Estado S2: rojo/rojo/rojo/rojo (Corresponde al proceso de S1->S2a->S3)
    -- Estado S2b : rojo/rojo/rojo/rojo (Corresponde al proceso de S4->S2b->S0)
    -- Estado S3: verde/rojo/rojo/rojo PERMITE PULSADORES
    -- Estado S3i: verde/rojo/rojo/rojo NO PERMITE PULSADORES
    -- Estado S4: ámbar/rojo/rojo/rojo
    -- Estado S5: verde/rojo/rojo/verde
    -- Estado s5i: verde/rojo/rojo/parpadeo verde
	-- Estado S6: rojo/verde/verde/rojo
	-- Estado S6i: rojo/verde/parpadeo verde/rojo
	-- Estado SR: estado de reset (todo rojo)
    
    process(all) -- DUDA: solo para VHDL 2008. Queda pendiente aclarar la lista de sensibilidad.
    begin
    	case actual is
        	when S0 => 
            	sal <= "0011000101";
            	max2 <= "11100"; -- ASIGNAR UN VALOR DE TIEMPO --Nos da igual si usar el contador 1 o 2 pues aqui no hay cuentas simultáneas
                if sensor = '1' or (p2a = '1' or p2b = '0') then
                    prox <= S1;
                elsif (p1a = '1' or p1b = '1') and max2 = tiempo2 then -- TIEMPO ROJO EXTRA
                	prox <= S6;
                else prox <= S0;
                end if;
            when S1 =>
            	sal <= "0010100101";
            	max1 <= "11100"; -- ASIGNAR UN VALOR DE TIEMPO
                if max1 = tiempo1 then -- Tiempo ámbar 2
                	prox <= S2a;
                else
                	prox <= S1;
                end if;
           when S2a =>
            	sal <= "0010010101";
            	max1 <= "11100"; --ASIGNAR UN VALOR
                if max1 = tiempo1 then -- TIEMPO TODO ROJO --Antes la condición implicaba también a p2a y p2b. No deberían ser necesarios pero lo apunto por si falla.
                	prox <= S3;
                else
                	prox <= S2a;
                end if;
            when S3 =>
            	sal <= "1000010101";
            	max1 <= "11100"; --ASIGNAR UN VALOR
            	max2 <= "11100"; --ASIGNAR UN VALOR
                if (p2a = '1' or p2b = '1') and max2 = tiempo2 then -- TIEMPO ROJO EXTRA
                	prox <= S5;
                elsif max1 = tiempo1 then -- TIEMPO VERDE SEMAFORO 1
                	prox <= S4;
                else
                	prox <= S3;
                end if;
            when S4 =>
            	sal <= "0100010101";
            	max1 <= "11100"; --ASIGNAR UN VALOR
                if max1 = tiempo1 then -- TIEMPO ÁMBAR
                	prox <= S2b;
                else
                	prox <= S4;
                end if;
            when S2b =>
            	sal <= "0010010101";
            	max1 <= "11100"; --ASIGNAR UN VALOR
                if max1 = tiempo1 then -- TIEMPO TODO ROJO --Antes la condición implicaba también a p2a y p2b. No deberían ser necesarios pero lo apunto por si falla.
                	prox <= S0;
                else
                	prox <= S2b;
                end if;
            when S5 =>
            	sal <= "1000010110";
            	max2 <= "11100"; --ASIGNAR UN VALOR
                if max2 = tiempo2 then -- TIEMPO VERDE ANTES DE INTERMITENTE
                	prox <= S5i;
                else
                	prox <= S5;
                end if;
            when S5i =>
            max2 <= "11100"; -- ASIGNAR UN VALOR
                while tiempo2<max2 loop
                if tiempo2(0) = '0' then
                    sal <= "1000010100"; -- SP1 rojo, SP2 todo apagado
                else
                    sal <= "1000010110"; -- SP1 rojo, SP2 verde encendido
                end if;
                end loop;
                if max2 = tiempo2 then -- TIEMPO PARPADEO
                    prox <= S3i;
                else
                    prox <= S5i;
                end if;
            when S6 =>
            	sal <= "0011001001";
            	max2 <= "11100"; -- ASIGNAR UN VALOR DE TIEMPO
                if max2 = tiempo2 then -- TIEMPO EN VERDE HASTA INTERMITENTE
                	prox <= S6i;
                else
                	prox <= S6;
                end if;
            when S6i =>
                max2 <= "11100"; -- ASIGNAR UN VALOR
                while tiempo2<max2 loop
                if tiempo2(0) = '0' then
                    sal <= "0011000001"; -- SP1 todo apagado, SP2 actual
                else
                    sal <= "0011001001"; -- SP1 verde encendido, SP2 actual
                end if;
                end loop;
                if max2 = tiempo2 then -- TIEMPO PARPADEO
                    prox <= S0i;
                else
                    prox <= S6i;
                end if;
            when S0i =>
                sal <= "0011000101";
                if sensor = '1' or (p2a = '1' or p2b = '0') then
                    prox <= S1;
                else prox <= S0i;
                end if;
            when S3i =>
            	sal <= "1000010101";
                if max1 = tiempo1 then -- TIEMPO VERDE SEMAFORO 1
                	prox <= S4;
                else
                	prox <= S3i;
                end if;
            when SR =>
                sal <= "0010010101";
                if reset = '0' then
                    prox <= S0;
                else
                    prox <= SR;
                end if;  
    	end case;
    end process Combinacional;
end architecture Estados;
