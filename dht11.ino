#include <DHT.h>

#define DHTPIN 27          
#define DHTTYPE DHT11      
#define ENABLE_PIN 32      
#define TX_PIN 17          

DHT dht(DHTPIN, DHTTYPE);
HardwareSerial UARTtoFPGA(2); 

void setup() {
  dht.begin();
  Serial.begin(9600);
  UARTtoFPGA.begin(9600, SERIAL_8O1, -1, TX_PIN);
  
  pinMode(ENABLE_PIN, INPUT);  // Set ENABLE_PIN as input to detect the 25 µs HIGH signal
}

void loop() {
  // Check if ENABLE_PIN is HIGH (button pressed)
  if (digitalRead(ENABLE_PIN) == HIGH) {
    unsigned long startTime = micros();

    // Wait for at least 25 microseconds while pin is still HIGH
    while (digitalRead(ENABLE_PIN) == HIGH) {
      if (micros() - startTime >= 25) {
        // Enough time has passed, proceed to send data
        float humidity = dht.readHumidity();
        float temperature = dht.readTemperature();

        if (isnan(humidity) || isnan(temperature)) {
          UARTtoFPGA.write(0xFF);  // Send a special marker byte for error
          return;
        }

        // Separate integer and fractional parts
        int humidityInt = int(humidity);
        int humidityFrac = int((humidity - humidityInt) * 100);  // Fractional part as an integer
        int temperatureInt = int(temperature);
        int temperatureFrac = int((temperature - temperatureInt) * 100);  // Fractional part as an integer
        Serial.println(humidity);
        Serial.println(temperature);
        Serial.print("Sending humidity (int): ");
        Serial.println(humidityInt);
        Serial.print("Sending humidity (frac): ");
        Serial.println(humidityFrac);
        Serial.print("Sending temperature (int): ");
        Serial.println(temperatureInt);
        Serial.print("Sending temperature (frac): ");
        Serial.println(temperatureFrac);

        // Send fractional part first, then integer part
        UARTtoFPGA.write((byte)temperatureFrac);  // Send temperature fractional part as byte
        UARTtoFPGA.write((byte)temperatureInt);   // Send temperature integer part as byte
        UARTtoFPGA.write((byte)humidityFrac);     // Send humidity fractional part as byte
        UARTtoFPGA.write((byte)humidityInt);      // Send humidity integer part as byte

        break;  // Exit loop after sending data
      }
    }
  }

  delay(10);  // Add a small delay to debounce or avoid multiple triggers
}
