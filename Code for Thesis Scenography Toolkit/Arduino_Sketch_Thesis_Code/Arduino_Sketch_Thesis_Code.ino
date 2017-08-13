
//Declare variables
int led1 = 13;
int led2 = 11;
int button1 = 12;
int button2= 10;  

void setup() {
  //Assign pins for sending/receiving data
  pinMode(led1, OUTPUT);
  pinMode(button1, INPUT);
  pinMode(led2, OUTPUT);
  pinMode(button2, INPUT);
  Serial.begin(9600);  // Open serial port, set baud rate of 9600
  }
  
void loop(){
  //if serial is available 
  if(Serial.available() > 0) {
  char ledState = Serial.read();  //Read the data, store in ledState

  //ifledState is 1
  if(ledState == '1'){
  digitalWrite(led1, HIGH);  // turn the led1 on
  }
  
  //ifledState is 0
  if(ledState == '0'){
  digitalWrite(led1, LOW); // turn the led1 off
  }
  //ifledState is 3
  if(ledState == '3'){
  digitalWrite(led2, HIGH); // turn led2 on
  }
  
  //ifledState is 2
  if(ledState == '2'){
  digitalWrite(led2, LOW); // turn led2 off
  }
}

  // Declare variables for buttonStates 1 & 2 
  // and assign the data from the buttons to be stored in them
  int buttonState1 = digitalRead(button1);
  int buttonState2 = digitalRead(button2);
  
  // if buttonState 1 is high
  if ( buttonState1 == HIGH){
    Serial.println(101);  // print 101 to console
    delay(500);  // Set a delay of 500ms
    }
    
    // if buttonState 2 is high
    if ( buttonState2 == HIGH){

  Serial.println(102); // print 102 to console
  delay(500); // Set a delay of 500ms
  }
}
