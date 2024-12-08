library IEEE;
use IEEE.std_logic_1164.all;

entity ClockTB is 
end ClockTB;

architecture Beh of ClockTB is 
signal clk_tb : std_logic := '0';
signal reset_tb : std_logic := '1';
signal hours_tb : integer range 0 to 23;
signal minutes_tb, seconds_tb: integer range 0 to 59;
constant CLK_PERIOD: time := 20 ps; 
begin
uut: entity work.DigitalClock port map(clk_tb,reset_tb, hours_tb,minutes_tb,seconds_tb);

clk_process: process begin
while true loop
clk_tb <= '0';
wait for CLK_PERIOD/2;
clk_tb <= '1';
wait for CLK_PERIOD/2;
end loop;
end process;

stimulus: process begin

wait for 2.4 ns;
reset_tb <= '0';
wait for 50 ps;
reset_tb <= '1';

wait;
end process;
end Beh;