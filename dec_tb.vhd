----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Crete Date: 15.01.2022 23:58:16
-- Design Name: 
-- Module Name: dec_tb - tb
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

entity dec_tb is
end dec_tb;

architecture tb of dec_tb is
  component dec
        port (code : in std_logic_vector (1 downto 0);
              led  : out std_logic_vector (6 downto 0));
    end component;

    signal code : std_logic_vector (1 downto 0);
    signal led  : std_logic_vector (6 downto 0);

    

begin

    dut : dec
    port map (code => code,
              led  => led);


    test : process
    begin
        --Inicialización
        code <= (others => '0');
        --Estímulos
        wait for 10ns;
        code<="00";
        wait for 10ns;
        code<="01";
        wait for 10ns;
        code<="10";
        wait for 10ns;
        code<="11";
        wait for 10ns;
        code<="10";
        wait for 10ns;
        code<="01";
        wait for 10ns;
        code<="00";

        wait;
        assert FALSE
            report "success:simulation finished."
            severity failure;
    end process;
end tb;
