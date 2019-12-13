/*  Notes:
 *  Thanks to Bob M. for his scanner table design and the code
 *  I used to learn the functions of the included libraries.
 *  The electronic design remaines the same (for now) 
 *  except for correcting the pinout of VCC/VDD from 
 *  the 1602 display to power.
 *  
 *  Edit setMaxSpeed and setSpeed to change the rotation
 *  speed of the stepper motor. Future revisions will add
 *  this to the setting options in the menu.
 *  
 *  This program requires:
 *  AccelStepper: https://www.airspayce.com/mikem/arduino/AccelStepper/
 *  LiquidCrystal: https://www.arduino.cc/en/Reference/LiquidCrystal
 *  
 *  Rotating Table Versions
 *  v1.0  19/12/13  Initial stepper driver code for the rotating table
 */

#include <AccelStepper.h>
#include <LiquidCrystal.h>

#define MOTORTYPE   4 // Full4Wire (4) is 2048, Half4Wire (8) is 4096 
#define mPin1  2 // To ULN2003 driver Pin 1
#define mPin2  3 // To ULN2003 driver Pin 2
#define mPin3  4 // To ULN2003 driver Pin 3
#define mPin4  5 // To ULN2003 driver Pin 4
#define greenLED 7     // Green LED 
#define redLED 8     // Red LED
#define upbutton 10   // Up Button
#define downbutton 11 // Down Button
#define enterbutton 12  // Enter Button

int currStep = 0;
int pos = 0;    // Position of the Stepper
int epress = 0;    // Has Enter been pressed? Flip this variable.
int rotations = 1; // Number of rotations
int distance = 0; // Total Distance to run (rotations x stpprrot)
int stpprrot = 512 * MOTORTYPE; // Computes total steps for a full rotation

LiquidCrystal lcd(14, 15, 16, 17, 18, 19);
AccelStepper stepper(MOTORTYPE, mPin1, mPin3, mPin2, mPin4);

void setup() 
{   
    pinMode(upbutton, INPUT_PULLUP);
    pinMode(downbutton, INPUT_PULLUP);
    pinMode(enterbutton, INPUT_PULLUP);
    pinMode(greenLED, OUTPUT);
    pinMode(redLED, OUTPUT);
    stepper.setMaxSpeed(50);        // What we're accellerating to
    stepper.setAcceleration(200);    // Rate of accelleration
    stepper.setSpeed(50);           // Initial speed of stepper on start
    lcd.begin(16, 2);               
    lcd.setCursor(2,0);
    lcd.print("Table Rotate");
    lcd.setCursor(1,1);
    lcd.print("by PCBurn.com");
    delay(2000);
    lcd.clear();
    lcd.clear();
    lcd.print ("Rotations:");
    lcd.noCursor();
    resetVars();
}

void resetVars()
{
  rotations = 1;
  epress = 0;
  pos = 0;
  currStep = 0;
  stepper.disableOutputs();
  stepper.setCurrentPosition(0);
  lcd.clear();
  lcd.home();
  lcd.print ("Rotations:");
  lcd.setCursor(1,1);
  lcd.print(rotations);
}

void loop() 
{ 
  if (digitalRead(enterbutton) == 0) {
    epress = 1;
  } else {
    epress = 0;
  }
  
  switch (epress)
  {
    case 0:
    if(digitalRead(upbutton) == LOW && rotations <= 99 && epress == 0) {
      rotations++;
      while (digitalRead(upbutton) == LOW);
      lcd.setCursor(0,1);
      lcd.print("                ");
      lcd.setCursor(1,1);
      lcd.print(rotations);
    }
    
    if(digitalRead(downbutton) == LOW && rotations >= 1 && epress == 0) {
      rotations--;
      while (digitalRead(downbutton) == LOW);
      lcd.setCursor(0,1);
      lcd.print("                ");
      lcd.setCursor(1,1);
      lcd.print(rotations);
    }
    break;
    
    case 1:
    {
      distance = stpprrot * rotations;
      
      if (stepper.currentPosition() <= distance && epress == 1) {
        stepper.runToNewPosition(pos);
        stepper.runSpeed();
        lcd.clear();
        lcd.setCursor(0,1);
        lcd.print("Rotating x");
        lcd.setCursor(13,1);
        lcd.print(rotations);
        pos = pos + distance;
        currStep++;
      } 
      if (stepper.currentPosition() >= distance) {
        lcd.clear();
        lcd.setCursor(4,1);
        lcd.print("Finished");
        delay(1000);
        resetVars();
      }
    }
    break;
    
    default:
    lcd.clear();
    lcd.print ("xxxxxERRORxxxxx");
    lcd.noCursor();
  }

}
