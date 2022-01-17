----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 17:51:19
-- Design Name: 
-- Module Name: EDGEDTCTR - Behavioral
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

entity EDGEDTCTR is
    generic(width: positive := 4);  --Número de bits que soporta
    port (
        CLK     : in  std_logic;                            --Reloj
        SYNC_IN : in  std_logic_vector(width-1 downto 0);   --Entrada síncrona de duración indeterminada
        EDGE    : out std_logic_vector(width-1 downto 0)    --Salida síncrona de duración 1 ciclo de reloj
    );
end EDGEDTCTR;

architecture Behavioral of EDGEDTCTR is
    
--DECLARACIÓN DE TIPOS Y SEÑALES INTERNAS
    type matriz is array (width-1 downto 0) of std_logic_vector(2 downto 0);
    signal sreg : matriz;

begin
    process (CLK)
        begin
            if rising_edge(CLK) then
                for i in 0 to width-1 loop
                    sreg(i) <= sreg(i)(1 downto 0) & SYNC_IN(i);
                end loop;
            end if;
            for i in 0 to width-1 loop
                EDGE(i) <= sreg(i)(2) and not sreg(i)(1) and not sreg(i)(0);
            end loop;       
        end process;
end Behavioral;
