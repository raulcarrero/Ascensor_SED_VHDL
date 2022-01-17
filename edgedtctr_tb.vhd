----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2022 21:15:55
-- Design Name: 
-- Module Name: edgedtctr_tb - tb
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

entity edgedtctr_tb is
generic(
    width:positive:=4);
end edgedtctr_tb;

architecture tb of edgedtctr_tb is
component EDGEDTCTR
        port (CLK     : in std_logic;
              SYNC_IN : in std_logic_vector (width-1 downto 0);
              EDGE    : out std_logic_vector (width-1 downto 0));
    end component;

    signal CLK     : std_logic:='0';
    signal SYNC_IN : std_logic_vector (width-1 downto 0);
    signal EDGE    : std_logic_vector (width-1 downto 0);

    constant Periodo : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal FinSim : std_logic := '0';

begin

    dut : EDGEDTCTR
    port map (CLK     => CLK,
              SYNC_IN => SYNC_IN,
              EDGE    => EDGE);

    -- Seál de reloj
    CLK <= not CLK after Periodo/2 when FinSim /= '1' else '0';


    test : process
    begin
        -- Inicialización
        SYNC_IN <= (others => '0');

        -- Estímulos
        wait for 2 ns;
        wait for 5*periodo;
        SYNC_IN <="1000";
        wait for 5*periodo;
        SYNC_IN <="0100";
        wait for 5*periodo;
        SYNC_IN <="0010";
        wait for 5*periodo;
        SYNC_IN <="0001";
        wait for 5*periodo;
        SYNC_IN <="0010";
        wait for 5*periodo;
        SYNC_IN <="0100";
        wait for 5*periodo;
        SYNC_IN <="1000";
        
        wait for 10 * Periodo;

        -- Paro de reloj
        FinSim <= '1';
        wait;
        assert FALSE
            report "success:simulation finished."
            severity failure;
    end process;
end tb;
