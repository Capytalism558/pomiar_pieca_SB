int sensorPin1 = A0;
int sensorPin2 = A1;
int sensorPin3 = A2;
int sensorPin4 = A3;
int sensorPin5 = A4;
int sensorPin6 = A5;
int sensorPin7 = A6;
int sensorPin8 = A7;

int sensors[] = {sensorPin1, sensorPin2, sensorPin3, sensorPin4, sensorPin5, sensorPin6, sensorPin7, sensorPin8};

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  for (int i = 0; i < 7; i++){
    Serial.print(analogRead(sensors[i]));
    Serial.print(',');
  }
  Serial.println(analogRead(sensors[7]));
  delay (500);
}


