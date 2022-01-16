----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.01.2022 23:31:16
-- Design Name: 
-- Module Name: reg_piso_tb - tb
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

entity reg_piso_tb is
    generic(
            Pisos: positive:= 4);
end reg_piso_tb;

architecture tb of reg_piso_tb is
component reg_piso
        port (reset       : in std_logic;
              clk         : in std_logic;
              sensor      : in std_logic_vector (pisos-1 downto 0);
              ultimo_piso : out std_logic_vector (1 downto 0));
    end component;
--inputs
    signal reset       : std_logic;
    signal clk         : std_logic:='0';
    signal sensor      : std_logic_vector (pisos-1 downto 0);
--outputs
    signal ultimo_piso : std_logic_vector (1 downto 0);

    constant Periodo : time := 10 ns; 
    signal FinSim : std_logic := '0';

begin

    dut : reg_piso
    port map (reset       => reset,
              clk         => clk,
              sensor      => sensor,
              ultimo_piso => ultimo_piso);

    -- Se�al de reloj
    clk<= not clk after Periodo/2 when FinSim /= '1' else '0';
    

    test : process
    begin
        --Inicializaci�n
        sensor <= (others => '0');
        reset<='1';
        
        wait for 13ns;
        sensor<="0001";
         wait for 13ns;
        sensor<="0010";
         wait for 13ns;
        sensor<="0100";
         wait for 13ns;
        sensor<="1000";
         wait for 13ns;
        sensor<="0100";
         wait for 13ns;
        sensor<="0010";
        wait for 13ns;
        sensor<="0001";
        
        wait for 10 * Periodo;

        -- Paro del reloj
        FinSim <= '1';
         assert FALSE
            report "success:simulation finished."
            severity failure;
        wait;
    end process;
end tb;
