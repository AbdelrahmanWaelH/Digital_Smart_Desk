library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity DigitalClock is
port (clk : IN STD_LOGIC;
	seconds, minutes, hours : OUT integer);
end DigitalClock;

architecture arch of DigitalClock is
signal s, m, h : integer := 0;
begin

	process(clk) begin
		if(rising_edge(clk)) then
			s <= s+1;
			if(s = 60) then 
				m <= m+1;
				s <= 0;
			 end if;
			if(m = 60) then 
				h <= h+1;
				m <= 0;
			 end if;
		end if;
	end process;
	seconds <= s;
	minutes <= m;
	hours <= h;
end arch;

