// output:
#define OUTPUT_PIN 1
#define OUTPUT_RESOLUTION 16

// serial port and i/o:
char inChar[10];
int i;
String message;

// fft:
#include "arduinoFFT.h"
#define SAMPLES 16384              // must be power of 2
#define SAMPLING_FREQUENCY 16384     // Hz
#define PLOT_SIZE 512
#define START_IND 100
arduinoFFT FFT = arduinoFFT();
unsigned long sampling_period_us;
unsigned long useconds_sampling;
unsigned long end_ind = SAMPLES / 2;
unsigned long refresh_period_us;
unsigned long useconds_refresh; 
double vReal[SAMPLES];
double vImag[SAMPLES];
uint8_t analogInput = A0;
unsigned long t0;
float sampFreq = float(SAMPLING_FREQUENCY);
float noSamples = float(SAMPLES);
  
void setup() {
  
  // setup output frequency:
  pinMode(OUTPUT_PIN, OUTPUT);
  analogWriteResolution(OUTPUT_RESOLUTION);
  analogWriteFrequency(OUTPUT_PIN, 1370); // 1750
  analogWrite(OUTPUT_PIN, pow(2, OUTPUT_RESOLUTION) / 2);

  // setup serial port:
  Serial.begin(115200);
  delay(1000);
  //  Serial.println("Serial port connected!");

  // setup FFT:
  sampling_period_us = round(1000000*(1.0/SAMPLING_FREQUENCY));
  pinMode(analogInput, INPUT);


  
}

void loop() {
  // read serial port:
  while (Serial.available() > 0) {
    inChar[i] = Serial.read();
    i++;
  }
  delay(10);
  // convert message to string and clear input array:
  message = String(inChar);
  for(int n = 0; n<11; n++) {
    inChar[n] = " ";
  }
  // print to serial port:
  //  Serial.println(message);

  // interpret message:
  if (message.startsWith("f.")) setFreq(message.substring(2, 6).toInt(), OUTPUT_PIN, OUTPUT_RESOLUTION);
  if (message.startsWith("s.")) sweep(message, OUTPUT_PIN, OUTPUT_RESOLUTION);
  if (message.startsWith("fft")) {
    t0 = millis();
      for(int i=0; i<SAMPLES; i++)
      {
        useconds_sampling = micros();
      
        vReal[i] = analogRead(analogInput);
        vImag[i] = 0;
      
        while(micros() < (useconds_sampling + sampling_period_us)){
          //wait...
        }
      }
      for(int i=0; i<(end_ind); i++) {
        // Serial.println(vReal[i]);
      }
      FFT.Windowing(vReal, SAMPLES, FFT_WIN_TYP_RECTANGLE, FFT_FORWARD);
      FFT.Compute(vReal, vImag, SAMPLES, FFT_FORWARD);
      FFT.ComplexToMagnitude(vReal, vImag, SAMPLES);
      
     /*PRINT RESULTS*/
      for(int i=START_IND; i<(end_ind); i++){
        Serial.print(i * (sampFreq / noSamples));
        Serial.print(", ");
        Serial.println(vReal[i]);
      }
      Serial.println("!!!!");
//      Serial.println(millis() - t0);
  }
  useconds_refresh = micros();
  i = 0;
}

void setFreq(int freq, int pin, int resolution) {
  analogWriteFrequency(pin, freq);
  analogWrite(pin, pow(2, resolution) / 2);
  Serial.print("Freq Set to "); Serial.print(freq); Serial.println(" Hz");
}

void sweep(String frequncies, int pin, int resolution) {
  String freqStrStart = frequncies.substring(2, 6);
  String freqStrEnd = frequncies.substring(6, 10);
  int endFreq = freqStrEnd.toInt();
  int startFreq = freqStrStart.toInt();
//   Serial.println(startFreq);
//   Serial.println(endFreq);
//   Serial.println(pin);
  for (int n = 0; n <= (endFreq - startFreq); n++) {
    analogWriteFrequency(pin, (startFreq + n));
    analogWrite(pin, pow(2, resolution) / 2);
    delay(2000);
  }
}
