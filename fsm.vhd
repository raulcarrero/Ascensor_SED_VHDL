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
    Pisos: positive:= 4
);
   Port ( 
         RESET:             in std_logic;
         CLK:               in std_logic;
         BOTON_Piso:        in std_logic_vector(pisos-1 downto 0);
         SENSOR:            in std_logic_vector(pisos-1 downto 0);
         MOTOR:             out std_logic_vector(1 downto 0);
         PUERTA:            out std_logic
   );
end fsm;

architecture Behavioral of fsm is

    type ESTADOS is (S0, S1, S2, S3, SU, SD);
    signal Estado_actual: ESTADOS := S0;
    signal Estado_siguiente: ESTADOS;
    signal Planta: natural; --Variable para guardar la planta requerida
begin
    registro_estados: process(RESET, CLK)
        begin
            if RESET = '0' then
                Estado_actual <= S0;
            elsif rising_edge(CLK) then
                Estado_actual <= Estado_siguiente;
            end if;
        end process;
    
    decodificador_proxEstado: process(RESET, BOTON_Piso, Estado_actual, SENSOR)
        begin
            if RESET = '0' then
                Estado_siguiente <= S0;
            else
                Estado_siguiente <= Estado_actual;
                
                case Estado_actual is
                
                    when S0 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 0 then
                                Estado_siguiente <= S0;
                            elsif Boton_piso(i) = '1' and i > 0 then
                                Estado_siguiente <= SU;    --SUBIENDO
                                Planta <= i;
                            end if;
                        end loop;
                        
                    when S1 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 1 then
                                Estado_siguiente <= S1;
                            elsif Boton_piso(i) = '1' and i > 1 then
                                Estado_siguiente <= SU; --SUBIENDO
                                Planta <= i;
                            elsif Boton_piso(i) = '1' and i < 1 then
                                Estado_siguiente <= SD; --BAJANDO
                                Planta <= i;
                            end if;              
                        end loop;
                        
                    when S2 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 2 then
                                Estado_siguiente <= S2;
                            elsif Boton_piso(i) = '1' and i > 2 then
                                Estado_siguiente <= SU; --SUBIENDO
                                Planta <= i;
                            elsif Boton_piso(i) = '1' and i < 2 then
                                Estado_siguiente <= SD;--BAJANDO
                                Planta <= i;
                            end if;              
                        end loop;
                        
                    when S3 =>
                        for i in 0 to Pisos-1 loop
                            if Boton_piso(i) = '1' and i = 3 then
                                Estado_siguiente <= S3;
                            elsif Boton_piso(i) = '1' and i < 3 then
                                Estado_siguiente <= SD;--BAJANDO
                                Planta <= i;
                            end if;              
                        end loop;
                        
                    when SU =>
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
                 
                    when SD =>       
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
