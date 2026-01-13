#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// Dirección típica del LCD I2C (0x27 o 0x3F)
LiquidCrystal_I2C lcd(0x27, 16, 2);

// Pines
#define LED_GREEN 3
#define LED_YELLOW 4
#define LED_RED 5
#define BUZZER 6

void clearOutputs() {
  digitalWrite(LED_GREEN, LOW);
  digitalWrite(LED_YELLOW, LOW);
  digitalWrite(LED_RED, LOW);
  noTone(BUZZER);
}

void setup() {
  Serial.begin(9600);

  pinMode(LED_GREEN, OUTPUT);
  pinMode(LED_YELLOW, OUTPUT);
  pinMode(LED_RED, OUTPUT);
  pinMode(BUZZER, OUTPUT);

  lcd.init();
  lcd.backlight();
  lcd.clear();

  lcd.setCursor(0,0);
  lcd.print("SOC ALERT PANEL");
  lcd.setCursor(0,1);
  lcd.print("Esperando...");
}

void loop() {
  if (Serial.available()) {
    String alert = Serial.readStringUntil('\n');
    alert.trim();

    clearOutputs();
    lcd.clear();

    // Mostrar mensaje
    int msgIndex = alert.indexOf("MSG=");
    String msg = (msgIndex != -1) ? alert.substring(msgIndex + 4) : "Alerta";

    lcd.setCursor(0,0);
    lcd.print("ALERTA SOC");
    lcd.setCursor(0,1);
    lcd.print(msg.substring(0, 16));

    // Severidad
    if (alert.indexOf("SEVERITY=LOW") != -1) {
      digitalWrite(LED_GREEN, HIGH);
    }
    else if (alert.indexOf("SEVERITY=MEDIUM") != -1) {
      digitalWrite(LED_YELLOW, HIGH);
      tone(BUZZER, 1000, 200);
    }
    else if (alert.indexOf("SEVERITY=HIGH") != -1) {
      digitalWrite(LED_RED, HIGH);
      tone(BUZZER, 1500, 800);
    }
    else if (alert.indexOf("SEVERITY=CRITICAL") != -1) {
      for (int i = 0; i < 5; i++) {
        digitalWrite(LED_RED, HIGH);
        tone(BUZZER, 2000);
        delay(300);
        digitalWrite(LED_RED, LOW);
        noTone(BUZZER);
        delay(300);
      }
    }
  }
}

