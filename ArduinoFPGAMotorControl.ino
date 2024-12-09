const int motorPin = 9;  // Pin connected to the motor controller
const int directionPin = 3; // Pin connected to direction button
int lastButtonState = LOW; // Last state of the button
int currentButtonState;    // Current state of the button
unsigned long lastDebounceTime = 0; // Last debounce time
unsigned long debounceDelay = 50;    // debounce delay in milliseconds

void setup() {
  pinMode(motorPin, OUTPUT);           // Motor pin as OUTPUT
  pinMode(directionPin, INPUT_PULLUP); // Direction button pin with internal pull-up resistor
}

void loop() {
  // Read the current state of the button
  int reading = digitalRead(directionPin);

  // Check if the button state has changed and debounce
  if (reading != lastButtonState) {
    lastDebounceTime = millis(); // reset debounce timer
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // If the button state has changed (after debounce)
    if (reading != currentButtonState) {
      currentButtonState = reading;
      // Only change direction when the button is pressed (LOW state due to INPUT_PULLUP)
      if (currentButtonState == LOW) {
        // Change direction (Toggle pin state)
        // You can use direction change logic here (not just the PWM frequency)
      }
    }
  }

  // Generate PWM signal based on direction (currentButtonState)
  if (currentButtonState == LOW) { // Button pressed
    // Generate a PWM signal with a 1 ms high pulse in a 20 ms period
    digitalWrite(motorPin, HIGH);         // Set the pin HIGH (1 ms pulse)
    delayMicroseconds(1000);              // Keep it HIGH for 1000 microseconds (1 ms)
    digitalWrite(motorPin, LOW);          // Set the pin LOW
    delayMicroseconds(19000);             // Keep it LOW for 19000 microseconds (19 ms)
  } else {  // Button not pressed
    // Generate PWM signal for reverse direction (change frequency or pattern)
    digitalWrite(motorPin, HIGH);         // Set the pin HIGH (1 ms pulse)
    delayMicroseconds(2000);              // Keep it HIGH for 2000 microseconds (2 ms)
    digitalWrite(motorPin, LOW);          // Set the pin LOW
    delayMicroseconds(18000);             // Keep it LOW for 18000 microseconds (18 ms)
  }

  // Save the current button state for the next loop
  lastButtonState = reading;
}
