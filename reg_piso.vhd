----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.12.2021 18:56:29
-- Design Name: 
-- Module Name: reg_piso - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_piso is
    generic(
        Pisos: natural:= 4  --Numero de pisos que tiene el edificio
    );
    Port (
        RESET:       in std_logic;                      --Reset a nivel bajo
        CLK:         in std_logic;                      --Reloj común
        SENSOR:      in std_logic_vector(3 downto 0);   --Sensores de posición situados en cada piso
        ULTIMO_PISO: out std_logic_vector(1 downto 0)   --Último piso por el que pasó el ascensor
    );
end reg_piso;

architecture Behavioral of reg_piso is
--DECLARACIÓN DE SEÑALES INTERNAS
    signal ULTIMO_PISO_S: integer(1 downto 0); --Señal interna que almacena el último piso antes de copiarlo a la salida

begin
    process(RESET,CLK)
    begin
        if RESET = '0' then
            ULTIMO_PISO_S <= 0;
        elsif rising_edge(CLK) then
            for i in 0 to Pisos - 1 loop
                 if SENSOR(i) = '1' then 
                    ULTIMO_PISO_S <= i;
                 else
                    ULTIMO_PISO_S <= ULTIMO_PISO_S;
                 end if;
           end loop;
        end if;
    end process;
    
    ULTIMO_PISO <= std_logic_vector(ULTIMO_PISO_S);

end Behavioral;
