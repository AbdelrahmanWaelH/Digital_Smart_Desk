library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;

entity SmartDesk is
    port (
        clk, reset        : IN STD_LOGIC;
        proximitySensor   : IN STD_LOGIC; -- Signal from Arduino
        lightIn     	  : IN STD_LOGIC; -- ADC output from LDR
        timeOnDesk        : BUFFER integer; -- Time spent on the desk in seconds
        lampLight         : OUT STD_LOGIC; -- Lamp control
        drawerMotorOpen    : OUT STD_LOGIC; -- Drawer motor control
	drawerMotorClose   : OUT STD_LOGIC
    );
end SmartDesk;

architecture deskLogic of SmartDesk is

    -- Clock divider constant: Adjust for desired time unit based on clock frequency
    constant clockSpeed : integer := 5; 
    signal clockDividerCounter : integer := 0; 
    signal timeOnDeskCounter   : integer := 0; -- Counter for time on desk
    signal passedFirstCycle    : STD_LOGIC := '0'; -- Tracks if drawer has been opened
	
 -- State encoding
    type state_type is (OPEN_state, PAUSE, CLOSE);
    signal current_state : state_type := PAUSE;

begin
    -- Main process for controlling desk behavior
    process (clk, reset)
    begin
        if reset = '1' then
            -- Reset all internal counters and outputs
            clockDividerCounter <= 0;
            timeOnDeskCounter <= 0;
            lampLight <= '0';
        elsif rising_edge(clk) then
            if proximitySensor = '1' then
                
		--Handle Drawer Action
		CASE current_state is
			WHEN OPEN_state =>
				if( timeOnDesk >= 2) then current_state <= PAUSE; end if;
			WHEN PAUSE => 
				if( timeOnDesk >= 7 and timeOnDesk < 9) then current_state <= CLOSE;
				elsif (timeOnDesk = 0) then current_state <= OPEN_state;
				else current_state <= PAUSE;
				end if;
			WHEN CLOSE =>
				if(timeOnDesk >= 9) then current_state <= PAUSE; end if;
		end CASE;
			

	
                -- Increment time counter using clock divider
                clockDividerCounter <= clockDividerCounter + 1;
                if clockDividerCounter = clockSpeed then
                    timeOnDeskCounter <= timeOnDeskCounter + 1;
                    clockDividerCounter <= 0;
                end if;

                -- Control lamp based on light level
               
            else
                -- Reset outputs when no presence is detected
                passedFirstCycle <= '0';
                lampLight <= '0'; -- Turn off lamp
                clockDividerCounter <= 0; -- Reset clock divider
            end if;
        end if;
    end process;

    -- Output time on desk
    timeOnDesk <= timeOnDeskCounter;
with current_state select
    drawerMotorOpen <= '1' when OPEN_state,
                      '0' when others;

with current_state select
    drawerMotorClose <= '1' when CLOSE,
                       '0' when others;
 


end deskLogic;

