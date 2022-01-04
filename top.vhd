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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
    Port(
        RESET:             in  std_logic;                    --Reset activo a nivel BAJO
        CLK:               in  std_logic;                    --Señal de reloj común para todos los componentes
        SENSOR:            in  std_logic_vector(3 downto 0); --Sensores de posición situados en cada piso
        BOTON_Piso:        in  std_logic_vector(3 downto 0); --Botones para llamar al ascensor
        led:               out std_logic_vector(6 DOWNTO 0); --Display 7 segmentos indicador del piso actual
        MOTOR:             out std_logic_vector(1 downto 0); --Subida = 01; Bajada = 10; Parada = 00
        PUERTA:            out std_logic                     --Abierta = 1; Cerrada y bloqueada = 0
    );
end top;

architecture Structural of top is

--DECLARACIÓN DE COMPONENTES
  --Módulo antirrebote
    component debounce IS 
        GENERIC(
            counter_size  :  INTEGER := 19); --counter size (19 bits gives 10.5ms with 50MHz clock)
        PORT(
            clk     : IN  STD_LOGIC;  --input clock
            button  : IN  STD_LOGIC;  --input signal to be debounced
            result  : OUT STD_LOGIC); --debounced signal
    END component;
    
  --Módulo de sincronización
    component SYNCHRNZR is 
        port (
            CLK      : in  std_logic;  --Reloj común
            ASYNC_IN : in  std_logic;  --Entrada asíncrona
            SYNC_OUT : out std_logic); --Salida síncrona
    end component;
    
  --Detector de flanco    
    component EDGEDTCTR is 
        port (
            CLK     : in  std_logic;  --Reloj común
            SYNC_IN : in  std_logic;  --Entrada síncrona de duración indeterminada
            EDGE    : out std_logic); --Salida síncrona que solo dura un ciclo de reloj a nivel alto
    end component;

  --Máquina de estados del Ascensor
    component FSM_Asc is  
        generic(
            Pisos: positive:= 4);
        Port( 
            RESET:             in std_logic;                     --Reset a nivel bajo
            CLK:               in std_logic;                     --Reloj común
            BOTON_Piso:        in std_logic_vector(3 downto 0);  --Botones para llamar al ascensor
            SENSOR:            in std_logic_vector(3 downto 0);  --Sensores de posición situados en cada piso
            MOTOR:             out std_logic_vector(1 downto 0); --Subida = 01; Bajada = 10; Parada = 00
            PUERTA:            out std_logic);                   --Abierta = 1; Cerrada y bloqueada = 0
    end component;

  --Registro de piso
    component reg_piso is 
        generic(
            Pisos: natural:= 4);
        Port (
            RESET:       in std_logic;                      --Reset activo a nivel bajo
            CLK:         in std_logic;                      --Reloj común
            SENSOR:      in std_logic_vector(3 downto 0);   --Sensores de posición situados en cada piso
            ULTIMO_PISO: out std_logic_vector(1 downto 0)); --Salida que indica el último piso por el que pasó el ascensor
    end component;

  --Decodificador de binario a 7 segmentos
    component dec IS 
        PORT (
            code : IN std_logic_vector(1 DOWNTO 0);     --Valor decimal codificado en binario
            led  : OUT std_logic_vector(6 DOWNTO 0));   --Leds a encender en el display 7 segmentos para representar el valor de entrada
    END component;

--DECLARACIÓN DE SEÑALES INTERNAS
    signal code_i: std_logic_vector(1 DOWNTO 0);                    --Señal que va desde reg_piso hasta dec (decodificador)
    signal result0, result1, result2, result3: std_logic;           --Señales que van de cada antirrebote a cada sincronizador
    signal sync_out0, sync_out1, sync_out2, sync_out3: std_logic;   --Señales que van de cada sincronizador a cada detector de flanco
    signal edge0, edge1, edge2, edge3: std_logic;                   --Señales que van de cada detector de flanco a la máquina de estados

begin
--INSTANCIACIÓN DE COMPONENTES
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

--UTILIZAMOS 4 COMPONENTES DE CADA TIPO (Antirrebote, Sincronizador, Detector de flanco), UNO PARA CADA BOTÓN    
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
end Structural;
