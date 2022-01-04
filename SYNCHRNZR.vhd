----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2021 16:54:58
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
    port (
        CLK      : in  std_logic;   --Reloj común
        ASYNC_IN : in  std_logic;   --Entrada asíncrona
        SYNC_OUT : out std_logic    --Salida síncrona
    );
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is
    signal sreg : std_logic_vector(1 downto 0);
begin
        process (CLK)
        begin
                if rising_edge(CLK) then
                    sync_out <= sreg(1);
                    sreg <= sreg(0) & async_in;
                end if;
        end process;
end BEHAVIORAL;
