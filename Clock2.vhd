library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.Numeric_std.all;

entity DigitalClock is port(
clk, reset : in std_logic;
hours : buffer integer range 0 to 23;
minutes, seconds: buffer integer range 0 to 59);
end DigitalClock;

architecture clockArch of DigitalClock is begin
process(clk) begin
if rising_edge(clk) then 
	if reset = '0' then
	seconds <= 0;
	minutes <= 0;
	hours <= 0;
	else
	if seconds = 59 then 
	seconds <= 0;
	if minutes = 59 then
	minutes <= 0;
	if hours = 23 then
	hours <= 0;
	else hours <= hours + 1;
	end if;
	else
	minutes <= minutes +1;
	end if;
	else 
	seconds <= seconds +1;
	end if;
	end if;
	end if;
end process;
end clockArch;