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

### 🔵 Login correcto

* **Event ID:** 4624
* **Log:** Security
* **Severidad:** INFO
* **Uso:** Actividad legítima detectada

### 🔴 Login fallido

* **Event ID:** 4625
* **Log:** Security
* **Severidad:** HIGH
* **Uso:** Detección de accesos no autorizados

### 🔴 SSH login fallido

* **Event ID:** 4
* **Log:** Microsoft-Windows-OpenSSH/Operational
* **Severidad:** HIGH
* **Uso:** Detección de accesos remotos fallidos

### 🟢 Servicio del sistema iniciado

* **Event ID:** 7036
* **Log:** System
* **Severidad:** LOW
* **Uso:** Evento informativo de sistema

### 🚨 Fuerza bruta detectada (correlación)

* **Origen:** Múltiples eventos 4625
* **Ventana temporal:** ≥ 5 intentos en 30 segundos
* **Severidad:** CRITICAL
* **Uso:** Detección de ataque activo

---

## 🚨 Sistema de severidades

| Severidad | Color LED            | Zumbador    | Descripción                    |
| --------- | -------------------- | ----------- | ------------------------------ |
| INFO      | 🔵 Azul              | ❌ No        | Actividad normal               |
| LOW       | 🟢 Verde             | ❌ No        | Evento informativo del sistema |
| HIGH      | 🔴 Rojo              | ✅ Corto     | Evento sospechoso              |
| CRITICAL  | 🔴 Rojo intermitente | 🔔 Continuo | Amenaza activa detectada       |

---

-----|-----------|----------|------------|
| INFO | 🔵 Azul | ❌ No | Evento informativo |
| HIGH | 🔴 Rojo | ✅ Sí | Evento sospechoso |
| CRITICAL | 🔴 Rojo intermitente | 🔔 Continuo | Amenaza grave (correlación futura) |

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

* Lectura continua de logs de Windows
* Detección por Event ID
* Control de eventos duplicados
* Correlación temporal de eventos
* Clasificación por severidad
* Envío de alertas por puerto serie USB

Ejemplo de mensaje enviado:

```
SEVERITY=CRITICAL;MSG=Fuerza bruta detectada
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
│   └── sketchjan13a.ino
│
├── powershell/
│   └── mini_soc_alertas.ps1
│
└── README.md
```

---



