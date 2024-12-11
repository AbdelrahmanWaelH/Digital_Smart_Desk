library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;


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
        segments <= "00011111";
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
use IEEE.NUMERIC_STD.all;

entity SmartDesk is
    port (
        clk, reset        : IN STD_LOGIC;
        proximitySensor   : IN STD_LOGIC; -- Signal from Arduino
        lightIn     	  : IN STD_LOGIC; -- ADC output from LDR
        segmentA : OUT STD_LOGIC_VECTOR(7 downto 0);
		  segmentB : OUT STD_LOGIC_VECTOR(7 downto 0);
        lightOut         : OUT STD_LOGIC; -- Lamp control
        motorOut : OUT STD_LOGIC; --AB5
		  motorDir : OUT STD_LOGIC; -- AB6
		  testState : OUT STD_LOGIC --A8
    );
end SmartDesk;

architecture deskLogic of SmartDesk is
component digitToSegments is
port( digit : IN integer;
	segments : OUT STD_LOGIC_VECTOR(7 downto 0));
end component;

	signal neededLightAtStart : std_logic;
	signal lightChecked : std_logic;

    -- Clock divider constant: Adjust for desired time unit based on clock frequency
    constant clockSpeed : integer := 10000000; 
    signal clockDividerCounter : integer := 0; 
    signal timeOnDeskCounter   : integer := 0; -- Counter for time on desk
  
  -- State encoding
    type state_type is (OPEN_state, PAUSE, CLOSE);
    signal current_state : state_type := PAUSE;
	 
	 signal drawerMotorOpen    : STD_LOGIC; -- Drawer motor control
	 signal drawerMotorClose   :  STD_LOGIC;

begin
    -- Main process for controlling desk behavior
    process (clk, reset)
    begin
        if reset = '0' then
            -- Reset all internal counters and outputs
            clockDividerCounter <= 0;
            timeOnDeskCounter <= 0;
				current_state <= PAUSE;
				lightChecked <= '0';
				neededLightAtStart <= '0';

        elsif rising_edge(clk) then
		  
		  --Check if light needed
		  if(lightIn = '1' and current_state = OPEN_state and lightChecked = '0') then
				neededLightAtStart <= '1';
				lightChecked <= '1';
			end if;
            
                
		--Handle Drawer Action
		CASE current_state is
			WHEN OPEN_state =>
				if( timeOnDeskCounter >= 2) then current_state <= PAUSE; end if;
			WHEN PAUSE => 
				if( timeOnDeskCounter >= 7 and timeOnDeskCounter < 9) then current_state <= CLOSE;
				elsif (timeOnDeskCounter = 0) then current_state <= OPEN_state;
				else current_state <= PAUSE;
				end if;
			WHEN CLOSE =>
				if(timeOnDeskCounter >= 9) then current_state <= PAUSE; end if;
		end CASE;
			

	
                -- Increment time counter using clock divider
                clockDividerCounter <= clockDividerCounter + 1;
                if clockDividerCounter = clockSpeed then
                    timeOnDeskCounter <= timeOnDeskCounter + 1;
                    clockDividerCounter <= 0;
                end if;

                -- Control lamp based on light level

        end if;
    end process;


with current_state select
    drawerMotorOpen <= '1' when OPEN_state,
                      '0' when others;

with current_state select
    drawerMotorClose <= '1' when CLOSE,
                       '0' when others;
 
motorOut <= drawerMotorOpen or drawerMotorClose;
motorDir <= drawerMotorOpen;
with current_state select
	testState <= '1' WHEN PAUSE, '0' WHEN OTHERS;
	
	digitA: digitToSegments port map (timeOnDeskCounter/10, segmentA);
	digitB: digitToSegments port map (timeOnDeskCounter mod 10, segmentB);

lightOut <= neededLightAtStart;
end deskLogic;

