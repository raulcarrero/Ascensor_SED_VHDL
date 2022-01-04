----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.12.2021 12:15:34
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port(
        RESET:             in  std_logic;
        CLK:               in  std_logic;
        SENSOR:            in  std_logic_vector(3 downto 0);
        BOTON_Piso:        in  std_logic_vector(3 downto 0);
        led:               out std_logic_vector(6 DOWNTO 0)
    );
end top;

architecture Structural of top is
component debounce IS
    GENERIC(
        counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
    PORT(
        clk     : IN  STD_LOGIC;  --input clock
        button  : IN  STD_LOGIC;  --input signal to be debounced
        result  : OUT STD_LOGIC); --debounced signal
END component;

component SYNCHRNZR is
    port (
        CLK      : in  std_logic;
        ASYNC_IN : in  std_logic;
        SYNC_OUT : out std_logic
    );
end component;
    
component EDGEDTCTR is
    port (
        CLK     : in  std_logic;
        SYNC_IN : in  std_logic;
        EDGE    : out std_logic
    );
end component;

component FSM_Asc is
    generic(
        Pisos: positive:= 4
    );
   Port ( 
--       START:             out std_logic; -- 0 BAJANDO, 1 SUBIENDO
--       DONE:              in std_logic;
         RESET:             in std_logic;
         CLK:               in std_logic;
         BOTON_Piso:        in std_logic_vector(3 downto 0);
         SENSOR:            in std_logic_vector(3 downto 0);
         MOTOR:             out std_logic_vector(1 downto 0); --Bit 1 bajada, bit 0 subida
         PUERTA:            out std_logic --1 abierta, 0 cerrada y bloqueada
   );
end component;


component reg_piso is
    generic(
        Pisos: natural:= 4
    );
    Port (
        RESET:       in std_logic;
        CLK:         in std_logic;
        SENSOR:      in std_logic_vector(3 downto 0);
        ULTIMO_PISO: out std_logic_vector(1 downto 0)
    );
end component;

component dec IS
    PORT (
        code : IN std_logic_vector(1 DOWNTO 0);
        led  : OUT std_logic_vector(6 DOWNTO 0)
    );
END component;
signal code_i: std_logic_vector(1 DOWNTO 0);
signal result0, result1, result2, result3: std_logic;
signal sync_out0, sync_out1, sync_out2, sync_out3: std_logic;
signal edge0, edge1, edge2, edge3: std_logic;
begin
    inst_reg_piso: reg_piso port map(
        RESET       =>  RESET,
        CLK         =>  CLK,
        SENSOR      =>  SENSOR,
        ULTIMO_PISO =>  code_i
    );
    inst_dec: dec port map(
        code    =>  code_i,
        led     =>  led
    );
    
    inst_debounce0: debounce port map(
        clk     =>  CLK,
        button  =>  BOTON_Piso(0),
        result  =>  result0
    );
    inst_debounce1: debounce port map(
        clk     =>  CLK,
        button  =>  BOTON_Piso(1),
        result  =>  result1
    );
    inst_debounce2: debounce port map(
        clk     =>  CLK,
        button  =>  BOTON_Piso(2),
        result  =>  result2
    );
    inst_debounce3: debounce port map(
        clk     =>  CLK,
        button  =>  BOTON_Piso(3),
        result  =>  result3
    );
    
    inst_SYNCHRNZR0: SYNCHRNZR port map(
        CLK      => CLK,
        ASYNC_IN => result0,
        SYNC_OUT => sync_out0
    );
    inst_SYNCHRNZR1: SYNCHRNZR port map(
        CLK      => CLK,
        ASYNC_IN => result1,
        SYNC_OUT => sync_out1
    );
    inst_SYNCHRNZR2: SYNCHRNZR port map(
        CLK      => CLK,
        ASYNC_IN => result2,
        SYNC_OUT => sync_out2
    );
    inst_SYNCHRNZR3: SYNCHRNZR port map(
        CLK      => CLK,
        ASYNC_IN => result3,
        SYNC_OUT => sync_out3
    );

    inst_EDGEDTCTR0: EDGEDTCTR port map(
        CLK     =>  CLK,
        SYNC_IN =>  sync_out0,
        EDGE    =>  edge0
    );
    inst_EDGEDTCTR1: EDGEDTCTR port map(
        CLK     =>  CLK,
        SYNC_IN =>  sync_out1,
        EDGE    =>  edge1
    );
    inst_EDGEDTCTR2: EDGEDTCTR port map(
        CLK     =>  CLK,
        SYNC_IN =>  sync_out2,
        EDGE    =>  edge2
    );
    inst_EDGEDTCTR3: EDGEDTCTR port map(
        CLK     =>  CLK,
        SYNC_IN =>  sync_out3,
        EDGE    =>  edge3
    );

    inst_FSM_Asc: FSM_Asc port map(
         RESET             => RESET,
         CLK               => CLK,
         BOTON_Piso(0)     => edge0,
         BOTON_Piso(1)     => edge1,
         BOTON_Piso(2)     => edge2,
         BOTON_Piso(3)     => edge3,
         SENSOR            => SENSOR,
         MOTOR             => MOTOR,
         PUERTA            => PUERTA
    );
end Behavioral;
