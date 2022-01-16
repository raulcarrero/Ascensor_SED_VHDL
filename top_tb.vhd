----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Crete Date: 16.01.2022 00:21:55
-- Design Name: 
-- Module Name: top_tb - tb
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
--use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
end top_tb;
--Consejo: Antes de simular este testbench, 
--configurar un tiempo de simulación ALTO (12 segundos por ejemplo)
architecture tb of top_tb is

    component top
        port (RESET       : in std_logic;
              EMERGENCIA  : in std_logic;
              CLK         : in std_logic;
              SENSOR      : in std_logic_vector (3 downto 0);
              BOTON_Piso  : in std_logic_vector (3 downto 0);
              led         : out std_logic_vector (6 downto 0);
              MOTOR       : out std_logic_vector (1 downto 0);
              PUERTA      : out std_logic;
              PUERTA_n    : out std_logic;
              AN          : out std_logic_vector (7 downto 0);
              led_SENSOR  : out std_logic_vector (3 downto 0));
    end component;
--inputs
    signal RESET       : std_logic;
    signal EMERGENCIA  : std_logic;
    signal CLK         : std_logic:='0';
    signal SENSOR      : std_logic_vector (3 downto 0);
    signal BOTON_Piso  : std_logic_vector (3 downto 0);
--outputs
    signal led         : std_logic_vector (6 downto 0);
    signal MOTOR       : std_logic_vector (1 downto 0);
    signal PUERTA      : std_logic;
    signal PUERTA_n    : std_logic;
    signal AN          : std_logic_vector (7 downto 0);
    signal led_SENSOR  : std_logic_vector (3 downto 0);

     constant Periodo : time := 5 ps; 
    signal FinSim : std_logic := '0';

begin

    dut : top
    port map (RESET       => RESET,
              EMERGENCIA  => EMERGENCIA,
              CLK         => CLK,
              SENSOR      => SENSOR,
              BOTON_Piso  => BOTON_Piso,
              led         => led,
              MOTOR       => MOTOR,
              PUERTA      => PUERTA,
              PUERTA_n    => PUERTA_n,
              AN          => AN,
              led_SENSOR  => led_SENSOR);

     -- Señal de reloj
    CLK <= not CLK after Periodo/2 when FinSim /= '1' else '0';

    
    test : process
    begin
        -- Inicialización
        EMERGENCIA <= '0';
        SENSOR <= (others => '0');
        BOTON_Piso <= (others => '0');
        RESET<='1';
        
        
--test de reset
        wait for 3.325 us;
        RESET<='0';
        wait for 3.325 us;
        RESET <= '1';
        
--test de subida
        wait for 1 us;
        BOTON_Piso <= "1000";
        wait for 2.5 us;
        BOTON_Piso <= "0000";
        wait for 2.5 us;
        SENSOR <= "0010";
        wait for 2.5 us;
        SENSOR <= "0000";
        wait for 2.5 us;
        SENSOR <= "0100";
        wait for 2.5 us;
        SENSOR <= "0000";
        wait for 2.5 us;
        SENSOR <= "1000";
        
--test de bajada
        wait for 2.5 us;
        BOTON_Piso <= "0010";
        wait for 2.5 us;
        BOTON_Piso <= "0000";
        wait for 2.5 us;
        SENSOR <= "0000";
        wait for 2.5 us;
        SENSOR <= "0100";
        wait for 2.5 us;
        SENSOR <= "0000";
        wait for 2.5 us;
        SENSOR <= "0010";
        
  --test de emergencia
        wait for 2.5 us;
        BOTON_Piso <= "1000";
        wait for 2.5 us;
        BOTON_Piso <= "0000";
        wait for 2.5 us;
        SENSOR <= "0000";
         wait for 0.825 us;
        EMERGENCIA<='1';
        wait for 3.325 us;
        EMERGENCIA <= '0';
        
        wait for 2 us;

        -- Paro del reloj
        FinSim <= '1';
        
        assert FALSE
            report "success:simulation finished."
            severity failure;
            wait;
    end process;
end tb;
