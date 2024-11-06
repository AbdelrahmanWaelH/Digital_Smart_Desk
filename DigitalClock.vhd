library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;

entity digitToSegments is
port( digit : IN integer;
	segments : OUT STD_LOGIC_VECTOR(7 downto 0));
end digitToSegments;

architecture arch of digitToSegments is
begin
	process(digit) 
begin
    if digit = 0 then
        segments <= "00000011";
    elsif digit = 1 then
        segments <= "10011111";
    elsif digit = 2 then
        segments <= "00100101";
    elsif digit = 3 then
        segments <= "00001101";
    elsif digit = 4 then
        segments <= "10011001";
    elsif digit = 5 then
        segments <= "01001001";
    elsif digit = 6 then
        segments <= "01000001";
    elsif digit = 7 then
        segments <= "00011110";
    elsif digit = 8 then
        segments <= "00000001";
    elsif digit = 9 then
        segments <= "00011001";
    else
        segments <= "11111111"; -- Default case for "others"
    end if;
end process;

end arch;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;

entity SmartDesk is
port( 	clk, reset : IN STD_LOGIC;
	proximitySensor : IN STD_LOGIC;
	lightSensor : IN std_logic_vector(7 downto 0);
	--timeOnDesk : OUT integer;
	minuteDisplayA, minuteDisplayB, secondDisplayA, secondDisplayB : OUT STD_LOGIC_VECTOR(7 downto 0); --8 bit vector for the 7-segment displays
	lampLight, drawerMotor : OUT STD_LOGIC);
end SmartDesk;

architecture deskLogic of SmartDesk is
constant lightThreshold : ieee.NUMERIC_STD.UNSIGNED (7 downto 0) := "00010000";
--constant clockSpeed : ieee.NUMERIC_STD.UNSIGNED(35 downto 0) := "101110100100001110110111010000000000"; --50GHz clock, value used in clock division
constant clockSpeed : ieee.NUMERIC_STD.UNSIGNED(35 downto 0) := "000000000000000000000000001000000000";
signal clockDividerCounter : ieee.NUMERIC_STD.UNSIGNED(35 downto 0) := ieee.NUMERIC_STD.TO_UNSIGNED(0, 36); 
signal timeOnDeskCounter : integer := 0;
signal minutesPassed : integer := 0;
signal secondsPassed : integer := 0;

signal minutesA, minutesB, secondsA, secondsB : integer := 0;

signal passedFirstCycle : std_logic := '0';

component digitToSegments is
port( digit : IN integer;
	segments : OUT STD_LOGIC_VECTOR(7 downto 0));
end component;

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
			minutesA <= 0;
			minutesB <= 0;
			secondsA <= 0;
			secondsB <= 0;
		end if;
		minutesPassed <= timeOnDeskCounter / 60;
		secondsPassed <= timeOnDeskCounter mod 60;

		minutesA <= minutesPassed/10;
		minutesB <= minutesPassed mod 10;
		secondsA <= secondsPassed/10;	
		secondsB <= secondsPassed mod 10;

		
	end process;
	minSegA: digitToSegments port map (minutesA, minuteDisplayA);
	minSegB: digitToSegments port map (minutesB, minuteDisplayB);
	secSegA: digitToSegments port map (secondsA, secondDisplayA);
	secSegB: digitToSegments port map (secondsB, secondDisplayB);

	

end deskLogic;
			
	
