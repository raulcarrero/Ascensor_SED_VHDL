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
    generic(width : positive := 4);
    Port(
        RESET:             in  std_logic;                    --Reset activo a nivel BAJO
        CLK:               in  std_logic;                    --Señal de reloj común para todos los componentes
        SENSOR:            in  std_logic_vector(3 downto 0); --Sensores de posición situados en cada piso
        BOTON_Piso:        in  std_logic_vector(3 downto 0); --Botones para llamar al ascensor
        led:               out std_logic_vector(6 DOWNTO 0); --Display 7 segmentos indicador del piso actual
        MOTOR:             out std_logic_vector(1 downto 0); --Subida = 01 Led VERDE; Bajada = 10 Led AZUL; Parada = 00
        PUERTA:            out std_logic;                    --Abierta = 1; Cerrada y bloqueada = 0
        PUERTA_n:          out std_logic;                    --Variable puerta negada, usada para encender un led diferente cuando está cerrada
        AN:                out std_logic_vector(7 downto 0)  --Ánodos de los display de 7 segmentos
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
        generic(width : positive := 4);
        port (
            CLK      : in  std_logic;                               --Reloj común
            ASYNC_IN : in  std_logic_vector(width-1 downto 0);      --Entrada asíncrona 4 bits
            SYNC_OUT : out std_logic_vector(width-1 downto 0));     --Salida síncrona 4 bits
    end component;
    
  --Detector de flanco    
    component EDGEDTCTR is 
        generic(width: positive := 4);
        port (
            CLK     : in  std_logic;                            --Reloj común
            SYNC_IN : in  std_logic_vector(width-1 downto 0);   --Entrada síncrona de 4 bits y duración indeterminada
            EDGE    : out std_logic_vector(width-1 downto 0));  --Salida síncrona de 4 bits y duración un ciclo de reloj
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
    signal code_i: std_logic_vector(1 DOWNTO 0);             --Señal que va desde reg_piso hasta dec (decodificador)
    signal result0, result1, result2, result3: std_logic;    --Señales que van de cada antirrebote al sincronizador
    signal sync_out_i: std_logic_vector(width-1 downto 0);   --Señal que va del sincronizador al detector de flanco
    signal edge_i: std_logic_vector(width-1 downto 0);       --Señal que va del detector de flanco a la máquina de estados

begin

    AN <= "00000001";       --Apagar todos los displays de 7 segmentos salvo uno
    PUERTA_n <= not PUERTA; --PUERTA encenderá un color, y PUERTA_n encenderá otro diferente
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

    --UTILIZAMOS 4 MÓDULOS ANTIRREBOTE, UNO PARA CADA BOTÓN    
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
    
    inst_SYNCHRNZR: SYNCHRNZR port map(
        CLK         => CLK,
        ASYNC_IN(0) => result0,
        ASYNC_IN(1) => result1,
        ASYNC_IN(2) => result2,
        ASYNC_IN(3) => result3,
        SYNC_OUT    => sync_out_i
    );

    inst_EDGEDTCTR: EDGEDTCTR port map(
        CLK     =>  CLK,
        SYNC_IN =>  sync_out_i,
        EDGE    =>  edge_i
    );

    inst_FSM_Asc: FSM_Asc port map(
         RESET             => RESET,
         CLK               => CLK,
         BOTON_Piso        => edge_i,
         SENSOR            => SENSOR,
         MOTOR             => MOTOR,
         PUERTA            => PUERTA
    );
end Structural;
