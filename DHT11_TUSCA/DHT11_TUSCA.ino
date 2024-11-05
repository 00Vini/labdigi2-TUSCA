#include <DHT.h>

#define DHTPIN 4          
#define DHTTYPE DHT11     
#define ENABLE_PIN 24

#define TX_PIN 17        

DHT dht(DHTPIN, DHTTYPE);

HardwareSerial UARTtoFPGA(2); 

void setup() {
  dht.begin();

  UARTtoFPGA.begin(9600, SERIAL_8N1, -1, TX_PIN); 
  pinMode(ENABLE_PIN, INPUT);  // Configura ENABLE_PIN como entrada
}

void loop() {
  delay(2000); 

  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  if (isnan(humidity) || isnan(temperature)) {
    UARTtoFPGA.println("X");
    return;
  }

  if (digitalRead(ENABLE_PIN) == HIGH) {  // Verifica se ENABLE_PIN está ativado
    UARTtoFPGA.print(int(humidity));
    UARTtoFPGA.print("%");
    UARTtoFPGA.print(int(temperature));
  }
}
