// importacao de bibliotecas
import processing.serial.*;      // comunicacao serial
import java.awt.event.KeyEvent;  // 
import java.io.IOException;

Serial myPort; // define objeto da porta serial

//  ======= CONFIGURACAO SERIAL ==================

    String   porta= "COM4";  // <== acertar valor ***
    int   baudrate= 115200;  // 115200;
    char    parity= 'O';     // par
    int   databits= 7;       // 7 bits de dados
    float stopbits= 1.0;     // 2 stop bits

//  ==============================================

// variaveis
char sensorReading =' ';
String distance      ="000";
int    iDistance     = 0;
PFont  font1, font2, font3;

// tecla pressionada
int whichKey = -1;  // tecla digitada

// rotina setup() do processing
void setup() {
    size (960, 600);
    smooth();

    // habilita comunicacao serial
    myPort = new Serial(this, porta, baudrate, parity, databits, stopbits); 
    // leitura de 1 byte da serial
    myPort.buffer(1);
    // criar fontes para o sketch no menu Tools>Create Font
    // arquivos na pasta "data"
    font1 = loadFont("OCRAExtended-24.vlw");
    font2 = loadFont("LiquidCrystal-72.vlw");
    font3 = loadFont("SegoeScript-32.vlw");
    // seleciona font1
    textFont(font1);

    println("setup: porta " + porta + " " + databits + parity + int(stopbits) + " @ " + baudrate + " bauds");
}

// rotina draw() do processing
void draw() {

    drawText();

}

// leitura de dados da porta serial
void serialEvent (Serial myPort) { 

    try {
        sensorReading = myPort.readChar();

        println("serialEvent: porta= " + porta + " distance= " + distance + " iDistance= " + iDistance);

    }
    catch(RuntimeException e) {
        e.printStackTrace();
    }

}

// desenha textos na tela
void drawText() {
  
  pushMatrix();

  background(255);
  fill(0);
  textFont (font3);  
  text("PCS3645 - Laboratório Digital II ", 190, 50);
  text("Teste de circuito UART", 200, 150);
  textFont (font1); 
  text("caractere: ", 270,300);
  
  // valor da distancia
  fill(#FF0000);
  textFont(font2);
  textAlign(RIGHT);
  text(sensorReading, 560,303);
  textAlign(LEFT);

  fill(0);
  textFont(font1);
  textSize(26);
  text("[Porta serial: "+ porta + " " + databits + parity + int(stopbits) + " @ " + baudrate + " bauds]", 15, 500);

  popMatrix(); 

  //println("drawtext: distance= " + distance + " iDistance= " + iDistance);

}


// processa teclas pressionadas e envia pela porta serial keystroke
void keyPressed() {
    whichKey = key;
    myPort.write(key);
    println("Tecla enviada: '" + key + "' para a porta serial: " + porta);
}
