# 🛡️ Mini SOC con Panel Físico de Alertas (Arduino)

Proyecto personal orientado a **Blue Team / Defensive Security** que simula el funcionamiento básico de un **Security Operations Center (SOC)**.

El sistema detecta eventos de seguridad reales en **Windows 11**, los analiza mediante un **script en PowerShell** y envía alertas en tiempo real a un **panel físico basado en Arduino**, que muestra la severidad mediante **pantalla LCD, LEDs y zumbador**.

Este proyecto está pensado como **laboratorio educativo**, demostración técnica y material para **portfolio profesional**.

---

## 🎯 Objetivos del proyecto

* Comprender cómo se registran y analizan los **logs de seguridad en Windows**.
* Simular el **flujo de detección y alertado de un SOC real**.
* Clasificar eventos por **severidad** (INFO, HIGH, CRITICAL).
* Integrar software de detección con **hardware físico**.
* Desarrollar mentalidad **Blue Team** y de **monitorización defensiva**.

---

## 🧱 Arquitectura general

```
[Actividad / Ataque]
        ↓
[Windows 11]
  - Event Viewer
  - Security Logs
  - OpenSSH Logs
        ↓
[PowerShell Detection Script]
        ↓ (USB Serial)
[Arduino UNO]
        ↓
[Panel SOC Físico]
  - LCD
  - LEDs
  - Buzzer
```

---

## 🔄 Ciclo de detección (Detection Cycle)

1. Se produce una actividad en el sistema (login, fallo, acceso, etc.)
2. Windows registra el evento en sus logs
3. El script PowerShell analiza los eventos periódicamente
4. Se clasifica la severidad del evento
5. Se envía una alerta por puerto serie USB
6. El Arduino muestra la alerta de forma visual y sonora

---

## 🖥️ Eventos detectados

### 🔴 Login fallido

* **Event ID:** 4625
* **Log:** Security
* **Severidad:** HIGH
* **Uso:** Detección de fuerza bruta o accesos no autorizados

### 🔵 Login correcto

* **Event ID:** 4624
* **Log:** Security
* **Severidad:** INFO
* **Uso:** Evento informativo / actividad legítima

### 🔴 SSH login fallido

* **Event ID:** 4
* **Log:** Microsoft-Windows-OpenSSH/Operational
* **Severidad:** HIGH
* **Uso:** Detección de accesos remotos fallidos

---

## 🚨 Sistema de severidades

| Severidad | Color LED            | Zumbador    | Descripción                        |
| --------- | -------------------- | ----------- | ---------------------------------- |
| INFO      | 🔵 Azul              | ❌ No        | Evento informativo                 |
| HIGH      | 🔴 Rojo              | ✅ Sí        | Evento sospechoso                  |
| CRITICAL  | 🔴 Rojo intermitente | 🔔 Continuo | Amenaza grave (correlación futura) |

---

## 🔌 Panel físico (Arduino)

### Componentes utilizados

* Arduino UNO
* Pantalla LCD (I2C o paralela)
* LED azul (INFO)
* LED rojo (HIGH / CRITICAL)
* Resistencias 220Ω
* Zumbador (buzzer)
* Cables Dupont

### Función del panel

El Arduino **no analiza eventos**, solo:

* Recibe mensajes desde Windows
* Interpreta la severidad
* Muestra la alerta

Esto simula un **panel de alertas SOC real**.

---

## 💻 Script PowerShell

Funciones principales:

* Lectura de logs de Windows
* Filtrado por Event ID
* Control de duplicados
* Envío de alertas por puerto COM

Ejemplo de mensaje enviado:

```
SEVERITY=HIGH;MSG=Login fallido
```

---

## 🧪 Simulación de ataques y pruebas

El proyecto se prueba mediante:

* Login fallido local en Windows
* Accesos SSH incorrectos
* Simulación controlada desde Kali Linux

⚠️ Todas las pruebas se realizan en **entornos controlados y educativos**.

---

## 🛠️ Tecnologías utilizadas

* Windows 11
* PowerShell
* Arduino IDE
* Arduino UNO
* USB Serial Communication
* Kali Linux (simulación)

---

## 📂 Estructura del proyecto

```
Mini-SOC-Arduino/
│
├── arduino/
│   └── soc_panel.ino
│
├── powershell/
│   └── alerta_login.ps1
│
├── docs/
│   ├── architecture.png
│   └── panel_photo.jpg
│
└── README.md
```

---

## 🚀 Posibles mejoras futuras

* Correlación de eventos (X intentos en Y segundos)
* Severidad CRITICAL automática
* Envío de alertas por red
* Dashboard web complementario
* Registro histórico de alertas

---

## 🎓 Enfoque profesional

Este proyecto demuestra conocimientos en:

* Análisis de eventos
* Monitorización defensiva
* Arquitectura SOC
* Integración hardware-software

Está orientado a **aprendizaje, portfolio y entrevistas técnicas**.

---

## ⚖️ Aviso legal

Proyecto con fines **educativos y de aprendizaje**.
No destinado a entornos productivos ni actividades no autorizadas.
