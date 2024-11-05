library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;

entity SmartDesk is
port( 	clk, reset : IN STD_LOGIC;
	proximitySensor : IN STD_LOGIC;
	lightSensor : IN std_logic_vector(7 downto 0);
	timeOnDesk : OUT integer;
	lampLight, drawerMotor : OUT STD_LOGIC);
end SmartDesk;

architecture deskLogic of SmartDesk is
constant lightThreshold : ieee.NUMERIC_STD.UNSIGNED (7 downto 0) := "00010000";
--constant clockSpeed : ieee.NUMERIC_STD.UNSIGNED(35 downto 0) := "101110100100001110110111010000000000"; --50GHz clock, value used in clock division
constant clockSpeed : ieee.NUMERIC_STD.UNSIGNED(35 downto 0) := "000000000000000000000000001000000000";
signal clockDividerCounter : ieee.NUMERIC_STD.UNSIGNED(35 downto 0) := ieee.NUMERIC_STD.TO_UNSIGNED(0, 36); 
signal timeOnDeskCounter : integer := 0;
signal passedFirstCycle : STD_LOGIC := 0;
begin
	process (clk) begin

		if (rising_edge(clk) and proximitySensor = '1') then 

			if(passedFirstCycle = '0') then
				--Open Drawer
				passedFirstCycle <= '1';
			end if;
			clockDividerCounter <= clockDividerCounter + 1;	
			if(clockDividerCounter = clockSpeed) then
				timeOnDeskCounter <= timeOnDeskCounter + 1;
				clockDividerCounter <= ieee.NUMERIC_STD.TO_UNSIGNED(0, 36); 
			end if;
		end if;

		if(reset = '1') then
			clockDividerCounter <= ieee.NUMERIC_STD.TO_UNSIGNED(0, 36);
			timeOnDeskCounter <= 0;
		end if;
	end process;

	timeOnDesk <= timeOnDeskCounter;

end deskLogic;
			
	
