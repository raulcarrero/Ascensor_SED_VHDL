----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2021 16:58:53
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
    port (
        CLK     : in  std_logic;    --Reloj común
        SYNC_IN : in  std_logic;    --Entrada síncrona de duración indeterminada
        EDGE    : out std_logic     --Salida síncrona que solo dura un ciclo de reloj a nivel alto
    );
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is
    
--DECLARACIÓN DE SEÑALES INTERNAS
 signal sreg : std_logic_vector(2 downto 0);

begin
    process (CLK)
        begin
            if rising_edge(CLK) then
                sreg <= sreg(1 downto 0) & SYNC_IN;
            end if;
        end process;
    with sreg select
        EDGE <= '1' when "100",
                '0' when others;
end BEHAVIORAL;
