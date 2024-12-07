const int distanceThreshold = 20;
bool inRange = false;
long duration;
int distance;

//Light stuff
const float referenceVoltage = 5.0; 
const float lightThreshold = 4.85;

//Pins
const int analogPin = A7; 
const int lightPin = A6;
const int trigPin = 7;
const int echoPin = 8; 
const int sensorOutputPin = 9;





void setup() {
  // put your setup code here, to run once:
  pinMode(trigPin,OUTPUT);
  pinMode(echoPin,INPUT);
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(trigPin,LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin,HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin,LOW);
  duration = pulseIn(echoPin,HIGH);
  distance = duration * (0.034/2);
  

  //calculating LDR volage aka light
  int analogValue = analogRead(analogPin);
  float voltage = (analogValue / 1023.0) * referenceVoltage;


  //SERVO



  delay(1000);

  if(distance <= distanceThreshold)
  {
    digitalWrite(sensorOutputPin, HIGH);
    inRange = true;
    
  }else{
    digitalWrite(sensorOutputPin, LOW);
    inRange = false;
  }

  if(voltage >= lightThreshold){
    analogWrite(lightPin, 128);
  }
  else{
    analogWrite(lightPin, 0);
  }

  Serial.print("\n");

  Serial.print(voltage);

}
