----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2021 21:33:37
-- Design Name: 
-- Module Name: fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
    generic(
        Pisos: positive:= 4     --Número de pisos que tiene el edificio
    );
    Port ( 
        RESET:             in std_logic;                           --Reset activo a nivel BAJO
        CLK:               in std_logic;                           --Señal de reloj común para todos los componentes
        BOTON_Piso:        in std_logic_vector(pisos-1 downto 0);  --Botones para llamar al ascensor
        SENSOR:            in std_logic_vector(pisos-1 downto 0);  --Sensores de posición situados en cada piso
        MOTOR:             out std_logic_vector(1 downto 0);       --Subida = 01; Bajada = 10; Parada = 00
        PUERTA:            out std_logic                           --Abierta = 1; Cerrada y bloqueada = 0
    );
end fsm;

architecture Behavioral of fsm is
--DECLARACIÓN DE TIPOS Y SEÑALES INTERNAS
    type ESTADOS is (S0, S1, S2, S3, SU, SD);   --Definición de los estados posibles de la máquina de estados
                                                --S0, S1, S2 y S3: ascensor parado en planta 0, 1, 2 y 3 respectivamente
                                                --SU: ascensor subiendo (State Up)
                                                --SD: ascensor bajando (State Down)
    signal Estado_actual: ESTADOS := S0;        --Estado actual, inicializado en S0
    signal Estado_siguiente: ESTADOS;           --Siguiente estado
    signal Planta: natural;                     --Variable para guardar la planta requerida

begin
--REGISTRO DE ESTADOS: proceso que refresca el estado en cada ciclo de reloj o resetea el estado
    registro_estados: process(RESET, CLK)
        begin
            if RESET = '0' then
                Estado_actual <= S0;
            elsif rising_edge(CLK) then
                Estado_actual <= Estado_siguiente;
            end if;
        end process;

--DECODIFICADOR DEL PRÓXIMO ESTADO: decide cuál será el siguiente estado en función de las entradas y del estado actual    
    decodificador_proxEstado: process(RESET, BOTON_Piso, Estado_actual, SENSOR, Planta)
        begin
            if RESET = '0' then
                Estado_siguiente <= S0;
            else
                Estado_siguiente <= Estado_actual;
                
                case Estado_actual is
                
                    when S0 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 0 then
                                Estado_siguiente <= S0; --No hace nada
                            elsif Boton_piso(i) = '1' and i > 0 then
                                Estado_siguiente <= SU; --SUBIENDO
                                Planta <= i;            --Almacena la planta pedida
                            end if;
                        end loop;
                        
                    when S1 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 1 then
                                Estado_siguiente <= S1; --No hace nada
                            elsif Boton_piso(i) = '1' and i > 1 then
                                Estado_siguiente <= SU; --SUBIENDO
                                Planta <= i;            --Almacena la planta pedida
                            elsif Boton_piso(i) = '1' and i < 1 then
                                Estado_siguiente <= SD; --BAJANDO
                                Planta <= i;            --Almacena la planta pedida
                            end if;              
                        end loop;
                        
                    when S2 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 2 then
                                Estado_siguiente <= S2; --No hace nada
                            elsif Boton_piso(i) = '1' and i > 2 then
                                Estado_siguiente <= SU; --SUBIENDO
                                Planta <= i;            --Almacena la planta pedida
                            elsif Boton_piso(i) = '1' and i < 2 then
                                Estado_siguiente <= SD; --BAJANDO
                                Planta <= i;            --Almacena la planta pedida
                            end if;              
                        end loop;
                        
                    when S3 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 3 then
                                Estado_siguiente <= S3; --No hace nada
                            elsif Boton_piso(i) = '1' and i < 3 then
                                Estado_siguiente <= SD; --BAJANDO
                                Planta <= i;            --Almacena la planta pedida
                            end if;              
                        end loop;
                        
                    when SU => --Solo cambia de estado cuando coinciden el sensor activado y la planta pedida
                        case sensor is
                            when "0001" => 
                                if Planta = 0 then
                                Estado_siguiente <= S0;
                                end if;
                            when "0010" => 
                                if Planta = 1 then
                                 Estado_siguiente <= S1;
                                end if; 
                            when "0100" => 
                                if Planta = 2 then
                                 Estado_siguiente <= S2;
                                end if; 
                            when "1000" => 
                                if Planta = 3 then
                                 Estado_siguiente <= S3;
                                end if;
                            when others =>
                                Estado_siguiente <= Estado_siguiente;
                        end case; 
                 
                    when SD =>  --Solo cambia de estado cuando coinciden el sensor activado y la planta pedida
                        case sensor is
                            when "0001" => 
                                if Planta = 0 then
                                Estado_siguiente <= S0;
                                end if;
                            when "0010" => 
                                if Planta = 1 then
                                 Estado_siguiente <= S1;
                                end if; 
                            when "0100" => 
                                if Planta = 2 then
                                 Estado_siguiente <= S2;
                                end if; 
                            when "1000" => 
                                if Planta = 3 then
                                 Estado_siguiente <= S3;
                                end if;
                            when others =>
                                Estado_siguiente <= Estado_siguiente;
                        end case;  
                             
                end case;
            end if;
        end process;
    
--DECODIFICADOR DE LAS SALIDAS: decide que valor tendrán las salidas en función del estado actual
    decodificador_salida: process(Estado_actual)
        begin
            case Estado_actual is
                when S0 =>
                    MOTOR <= "00";
                    PUERTA <= '1';
                when S1 =>
                    MOTOR <= "00";
                    PUERTA <= '1';
                when S2 =>
                    MOTOR <= "00";
                    PUERTA <= '1';
                when S3 =>
                    MOTOR <= "00";
                    PUERTA <= '1';
                when SU =>
                    MOTOR <= "01";
                    PUERTA <= '0';
                when SD =>
                    MOTOR <= "10";
                    PUERTA <= '0';
            end case;
        end process;
end Behavioral;
