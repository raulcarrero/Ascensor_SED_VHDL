----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.01.2022 21:16:05
-- Design Name: 
-- Module Name: fsm_tb - Behavioral
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

entity fsm_tb is
    generic(
            Pisos: positive:= 4);
end fsm_tb;

architecture tb of fsm_tb is
component FSM_Asc
        generic(
                Pisos: positive:= 4);
        port (RESET       : in std_logic;
              EMERGENCIA  : in std_logic;
              CLK         : in std_logic;
              ULTIMO_PISO : in std_logic_vector (1 downto 0);
              BOTON_Piso  : in std_logic_vector (pisos-1 downto 0);
              SENSOR      : in std_logic_vector (pisos-1 downto 0);
              MOTOR       : out std_logic_vector (1 downto 0);
              PUERTA      : out std_logic);
    end component;
    --inputs
    signal RESET       : std_logic;
    signal EMERGENCIA  : std_logic;
    signal CLK         : std_logic:='0';
    signal ULTIMO_PISO : std_logic_vector (1 downto 0);
    signal BOTON_Piso  : std_logic_vector (pisos-1 downto 0);
    signal SENSOR      : std_logic_vector (pisos-1 downto 0);
    --outputs
    signal MOTOR       : std_logic_vector (1 downto 0);
    signal PUERTA      : std_logic;

    constant Periodo : time := 10 ns; -- EDIT Put right period here
    signal FinSim : std_logic := '0';

begin

    dut : FSM_Asc
    port map (RESET       => RESET,
              EMERGENCIA  => EMERGENCIA,
              CLK         => CLK,
              ULTIMO_PISO => ULTIMO_PISO,
              BOTON_Piso  => BOTON_Piso,
              SENSOR      => SENSOR,
              MOTOR       => MOTOR,
              PUERTA      => PUERTA);

    -- Clock generation
    CLK <= not CLK after Periodo/2 when FinSim /= '1' else '0';

    tester : process
    begin
        -- EDIT Adapt initialization as needed
        EMERGENCIA <= '0';
        ULTIMO_PISO <= (others => '0');
        BOTON_Piso <= (others => '0');
        SENSOR <= "0001";
        RESET<='1';
--test de reset
        wait for 0.33*Periodo;
        RESET<='0';
        wait for 1.33*Periodo;
        RESET <= '1';
--test de subida
        wait for 3*Periodo;
        BOTON_Piso <= "1000";
        wait for Periodo;
        BOTON_Piso <= "0000";
        wait for Periodo;
        SENSOR <= "0010";
        ULTIMO_PISO <= "01";
        wait for 2*periodo;
        SENSOR <= "0100";
        ULTIMO_PISO <= "10";
        wait for 2*periodo;
        SENSOR <= "1000";
        ULTIMO_PISO <= "11";
--test de bajada
        wait for 3*Periodo;
        BOTON_Piso <= "0010";
        wait for Periodo;
        BOTON_Piso <= "0000";
        wait for Periodo;
        SENSOR <= "0100";
        ULTIMO_PISO <="10";
        wait for 2*periodo;
        SENSOR <= "0010";
        ULTIMO_PISO <= "01";
  --test de emergencia
        
        wait for 3*Periodo;
        BOTON_Piso <= "1000";
        wait for Periodo;
        BOTON_Piso <= "0000";
         wait for 0.33*Periodo;
        EMERGENCIA<='1';
        wait for 1ns;
        BOTON_Piso <= "0010";
        wait for 13ns;
        BOTON_Piso <= "0000";
        wait for 1.33*Periodo;
        EMERGENCIA <= '0';
        
        wait for 5 * Periodo;

        -- Stop the clock and hence terminate the simulation
        FinSim <= '1';
        wait;
        
        assert FALSE
            report "success:simulation finished."
            severity failure;
    end process;

end tb;


