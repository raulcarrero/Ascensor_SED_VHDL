----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2022 18:10:06
-- Design Name: 
-- Module Name: SYNCHRNZR - Behavioral
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


entity SYNCHRNZR is
    generic(width : positive := 4);    --Número de bits que soporta
    port (
        CLK      : in  std_logic;                           --Reloj
        ASYNC_IN : in  std_logic_vector(width-1 downto 0);  --Entrada asíncrona de 4 bits
        SYNC_OUT : out std_logic_vector(width-1 downto 0)   --Salida síncrona de 4 bits
    );
end SYNCHRNZR;

architecture Behavioral of SYNCHRNZR is
--DECLARACIÓN DE TIPOS Y SEÑALES INTERNAS
    type matriz is array (width-1 downto 0) of std_logic_vector(1 downto 0);
    signal sreg : matriz;

begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            for i in 0 to width-1 loop
                sync_out(i) <= sreg(i)(1);
                sreg(i) <= sreg(i)(0) & async_in(i);
            end loop;
        end if;
    end process;
end Behavioral;
