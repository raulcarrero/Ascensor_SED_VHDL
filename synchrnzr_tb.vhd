----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2022 20:47:05
-- Design Name: 
-- Module Name: synchrnzr_tb - tb
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

entity synchrnzr_tb is
generic(
        width:positive:=4);
end synchrnzr_tb;

architecture tb of synchrnzr_tb is
component SYNCHRNZR
        port (CLK      : in std_logic;
              ASYNC_IN : in std_logic_vector (width-1 downto 0);
              SYNC_OUT : out std_logic_vector (width-1 downto 0));
    end component;

    signal CLK      : std_logic:='0';
    signal ASYNC_IN : std_logic_vector (width-1 downto 0);
    signal SYNC_OUT : std_logic_vector (width-1 downto 0);

    constant Periodo : time := 10 ns; 
    signal FinSim : std_logic := '0';

begin

    dut : SYNCHRNZR
    port map (CLK      => CLK,
              ASYNC_IN => ASYNC_IN,
              SYNC_OUT => SYNC_OUT);

    -- Señal de reloj
    clk <= not clk after periodo/2 when FinSim /= '1' else '0';

    test : process
    begin
        -- Inicialización
        ASYNC_IN <= (others => '0');

        -- Estímulos
        wait for 2 ns;
        wait for 5*periodo;
        ASYNC_IN <="1000";
        wait for 5*periodo;
        ASYNC_IN <="0100";
        wait for 5*periodo;
        ASYNC_IN <="0010";
        wait for 5*periodo;
        ASYNC_IN <="0001";
        wait for 5*periodo;
        ASYNC_IN <="0010";
        wait for 5*periodo;
        ASYNC_IN <="0100";
        wait for 5*periodo;
        ASYNC_IN <="1000";
        
        
        wait for 10 * Periodo;

        -- Stop the clock and hence terminate the simulation
        FinSim <= '1';
        wait;
        assert FALSE
            report "success:simulation finished."
            severity failure;
    end process;

end tb;
