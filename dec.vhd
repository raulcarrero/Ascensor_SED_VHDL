----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2021 15:44:29
-- Design Name: 
-- Module Name: Dec - Behavioral
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

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY dec IS
    PORT (
        code : IN std_logic_vector(1 DOWNTO 0); --Valor decimal codificado en binario
        led  : OUT std_logic_vector(6 DOWNTO 0) --Leds a encender en el display 7 segmentos para representar el valor de entrada
    );
END ENTITY dec;

ARCHITECTURE dataflow OF dec IS
    BEGIN
        WITH code SELECT
            led <= "0000001" WHEN "00",
                   "1001111" WHEN "01",
                   "0010010" WHEN "10",
                   "0000110" WHEN "11",
                   "1111110" WHEN others;
END ARCHITECTURE dataflow;
