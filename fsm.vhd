LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

entity Cruce is
	port(
      clk    : in std_logic;
      reset  : in std_logic; --todo a rojo, estado S2
      sensor : in std_logic;
      p1     : in std_logic;
      p2     : in std_logic;
      --p1a:    in std_logic;
      --p1b:    in std_logic;
      --p2a:	in std_logic;
      --p2b:	in std_logic;
      sal    : out std_logic_vector (9 downto 0)
      );
end entity Cruce;

architecture Estados of Cruce is
type estado is (S0,S1,S2,S3,S4,S5,S5i,S6,S6i,S7,S7i,S8,S8i);
    signal actual : Estados;
    signal prox : Estados;
    
    begin
    Secuencial:
    	process(clk);
        begin
        if rising_edge (clk) then
          if reset = '1' then
              actual <= S2;
          else
              actual <= prox;
          end if;
        end if;
    end process Secuencial;
    
    Combinacional:
    -- Para coches: Rojo: 001, Ámbar: 010, Verde: 100
    -- Para peatones: Rojo: 01, Verde: 10
    -- Rural/Carretera/Peatón_Rural/Peatón_Carretera
    -- Semáforo1/Semáforo2/SemáforoPeatones1/SemáforoPeatones2
    --Significado de los estados:
    -- Estado S0: rojo/verde/rojo/rojo
    -- Estado S1: rojo/ámbar/rojo/rojo
    -- Estado S2: rojo/rojo/rojo/rojo (estado coincidente con reset)
    -- Estado S3: verde/rojo/rojo/rojo
    -- Estado S4: ámbar/rojo/rojo/rojo
    -- Estado S5: rojo/rojo/rojo/verde
    -- Estado S5i: rojo/rojo/rojo/parpadeo verde
    -- Estado S6: verde/rojo/rojo/verde
    -- Estado s6i: verde/rojo/rojo/parpadeo verde
	-- Estado S7: rojo/rojo/verde/rojo
	-- Estado s7i: rojo/rojo/parpadeo verde/rojo
	-- Estado S8: rojo/verde/verde/rojo
	-- Estado s8i: rojo/verde/parpadeo verde/rojo
    
    
    --OJO FALTA IMPLEMENTAR BIEN LOS TEMPORIZADORES T1 y T2: T1 el corto, T2 el largo, lo he indicado con '--'
    process(all);
    begin
    	case actual is
        	when S0 => 
            	sal <= 0011000101;
                if sensor = '1' or p2 = '1' then
                    prox <= S1;
                else prox <= S0;
                end if;
            when S1 =>
            	sal <= 0010100101;
                if TA2 then --
                	prox <= S2;
                else
                	prox <= S1;
                end if;
           when S2 =>
            	sal <= 0010010101;
                if sensor = '0' and p2 = '0' and TR1 then -- --DUDA
                	prox <= S0;
          		elsif p2 = '1' and TR2 then --
                	prox <= S5;
                elsif p1 = '1' and TR1 then --
                	prox = S7;
                elsif sensor = '1' and TR2 then --
                	prox = S3;
                else
                	prox <= S2;
                end if;
            when S3 =>
            	sal <= 1000010101;
                if p2 = '1' and TR2 then --
                	prox <= S6;
                elsif TV1 then --
                	prox <= S4;
                else
                	prox <= S3;
                end if;
            when S4 =>
            	sal <= 0100010101;
                if TA1 then --
                	prox <= S2;
                else
                	prox <= S4;
                end if;
            when S5 =>
            	sal <= 0010010110;
                if Tint then --
                	prox <= S5i;
                else
                	prox <= S5;
                end if;
            when S5i =>
                sal <= 0010010100; -- SP1 rojo, SP2 todo apagado
                wait for TVuelta/6;
                sal <= 0010011010; -- SP1 rojo, SP2 verde encendido
                wait for TVuelta/6;
                if TVuelta
                    prox <= S2;
                else
                    prox <= S5i;
            when S6 =>
            	sal <= 1000010110;
                if Tint then --
                	prox <= S6i;
                else
                	prox <= S6;
                end if;
            when S6i =>
                sal <= 1000010100; -- SP1 rojo, SP2 todo apagado
                wait for TVuelta/6;
                sal <= 1000010110; -- SP1 rojo, SP2 verde encendido
                wait for TVuelta/6;
                if TVuelta
                    prox <= S3;
                else
                    prox <= S6i;
            when S7 =>
            	sal <= 0010011001;
                if Tint then --
                	prox <= S7i;
                else
                	prox <= S7;
                end if;
            when S7i =>
                sal <= 0010010001; -- SP1 todo apagado, SP2 rojo
                wait for TVuelta/6;
                sal <= 0010011001; -- SP1 verde encendido, SP2 rojo
                wait for TVuelta/6;
                if TVuelta
                    prox <= S2;
                else
                    prox <= S7i;
             when S8 =>
            	sal <= 0011001001;
                if Tint then --
                	prox <= S8i;
                else
                	prox <= S8;
                end if;
            when S8i =>
                sal <= 0011000001; -- SP1 todo apagado, SP2 rojo
                wait for TVuelta/6;
                sal <= 0011001001; -- SP1 verde encendido, SP2 rojo
                wait for TVuelta/6;
                if TVuelta
                    prox <= S0;
                else
                    prox <= S8i;
    	end case;
    end process Combinacional;
end architecture Estados;