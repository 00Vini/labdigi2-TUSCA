#include <DHT.h>

#define DHTPIN 4          
#define DHTTYPE DHT11     


#define TX_PIN 17        

DHT dht(DHTPIN, DHTTYPE);


HardwareSerial UARTtoFPGA(2); 

void setup() {

  dht.begin();

  UARTtoFPGA.begin(9600, SERIAL_8N1, -1, TX_PIN); 
}

void loop() {
  delay(2000); 


  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();


  if (isnan(humidity) || isnan(temperature)) {
    UARTtoFPGA.println("X");
    return;
  }

  UARTtoFPGA.print(int(humidity));
  UARTtoFPGA.print("%");
  UARTtoFPGA.print(int(temperature));

}
