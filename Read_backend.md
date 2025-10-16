# RoboBridge API Documentation# RoboBridge API Documentation



**Version:** 1.0.0  **Base URL:** `http://ROBOT_IP:5050`

**Base URL:** `http://ROBOT_IP:5050`  

**Protocol:** HTTP/1.1 + WebSocket  **Authentication:** Barcha requests da `X-API-Key` header yoki `api_key` query parameter talab qilinadi

**Authentication:** API Key (X-API-Key header yoki api_key query parameter)- Header: `X-API-Key: robo-bridge-default-key-change-me`

- Query: `?api_key=robo-bridge-default-key-change-me`

---

---

## 📋 Umumiy ma'lumot

## 🏥 Health & Status Endpoints

RoboBridge - bu Flutter asosida yozilgan headless Android servisi bo'lib, USB orqali ulangan robotni real-time WebSocket ulanish orqali boshqarish imkonini beradi.

### 1. Health Check

### Asosiy xususiyatlar:**Endpoint:** `GET /health`

- ✅ **WebSocket real-time boshqaruv** - past latency bilan robot harakati

- ✅ **USB Serial aloqa** - 115200 baud rate**Description:** Server va barcha komponentlar statusini tekshiradi

- ✅ **Heartbeat mexanizmi** - avtomatik to'xtatish aloqa uzilsa

- ✅ **Auto-stop xavfsizligi** - WebSocket disconnect bo'lganda to'xtatish**Request:**

- ✅ **CORS qo'llab-quvvatlash** - browser'dan to'g'ridan-to'g'ri boshqarish```bash

- ✅ **API Key autentifikatsiya** - xavfsiz kirishcurl "http://192.168.100.208:5050/health?api_key=robo-bridge-default-key-change-me"

```

---

**Response (200 OK):**

## 🔐 Autentifikatsiya```json

{

Barcha so'rovlar (WebSocket bundan mustasno) uchun API key talab qilinadi.  "status": "ok",

  "usb_connected": true,

### Usul 1: HTTP Header  "camera_available": false,

```http  "server_running": true,

X-API-Key: robobridge_secret_key_2024  "timestamp": "2025-10-16T15:30:45.123Z"

```}

```

### Usul 2: Query Parameter

```http---

GET http://192.168.1.100:5050/health?api_key=robobridge_secret_key_2024

```## 🚀 Robot Control Endpoints



**Default API Key:** `robobridge_secret_key_2024`### 2. Move Command

**Endpoint:** `POST /move`

---

**Description:** Robotni yo'nalishda harakat ettiradi

## 📡 API Endpoints

**Request Body:**

### 1. Health Check```json

{

Server holatini tekshirish.  "dir": 1,

  "speed": 150

**Endpoint:** `GET /health`}

```

**Response:**

```json**Parameters:**

{- `dir` (integer, required): Yo'nalish kodi

  "status": "ok",  - `1` = Forward (Oldinga)

  "usb_connected": true,  - `2` = Backward (Orqaga)

  "server_running": true,  - `3` = Left (Chapiga)

  "timestamp": "2025-10-16T10:30:45.123Z"  - `4` = Right (O'ngga)

}- `speed` (integer, required): Tezlik (0-255)

```  - `0` = Ichkashallash (stop)

  - `255` = Max tezlik

**cURL misoli:**

```bash**cURL Example:**

curl -H "X-API-Key: robobridge_secret_key_2024" \```bash

  http://192.168.1.100:5050/healthcurl -X POST "http://192.168.100.208:5050/move?api_key=robo-bridge-default-key-change-me" \

```  -H "Content-Type: application/json" \

  -d '{"dir":1,"speed":150}'

**JavaScript misoli:**```

```javascript

fetch('http://192.168.1.100:5050/health', {**Response (200 OK):**

  headers: {```json

    'X-API-Key': 'robobridge_secret_key_2024'{

  }  "status": "success",

})  "message": "Move command sent",

.then(res => res.json())  "direction": 1,

.then(data => console.log(data));  "speed": 150

```}

```

---

**Error Responses:**

### 2. WebSocket Real-Time Control- `400 Bad Request`: Missing yoki invalid parameters

- `503 Service Unavailable`: USB not connected

Robot boshqaruvi uchun real-time WebSocket ulanish.

---

**Endpoint:** `ws://ROBOT_IP:5050/control/ws`

### 3. Stop Command

**Xususiyatlar:****Endpoint:** `POST /stop`

- Autentifikatsiya talab qilinmaydi (WebSocket upgrade uchun)

- Heartbeat mexanizmi - 2 soniyada aloqa yo'qolsa avtomatik to'xtatish**Description:** Robotni to'xtatadi

- Auto-stop - disconnect bo'lganda robot to'xtaydi

**Request Body:**

---```json

{

#### 2.1. Robot harakati (Move)  "mode": 0

}

**Client yuboradi:**```

```json

{**Parameters:**

  "action": "move",- `mode` (integer, optional): To'xtash rejimi

  "dir": 1,  - `0` = Immediate (Zudlik to'xtash) [default]

  "speed": 200  - `1` = Gradual (Asta-sekin to'xtash)

}

```**cURL Example:**

```bash

**Parametrlar:**curl -X POST "http://192.168.100.208:5050/stop?api_key=robo-bridge-default-key-change-me" \

- `action`: "move" (majburiy)  -H "Content-Type: application/json" \

- `dir`: Yo'nalish (majburiy)  -d '{"mode":0}'

  - `1` = Oldinga (Forward)```

  - `2` = Orqaga (Backward)

  - `3` = Chapga (Left)**Response (200 OK):**

  - `4` = O'ngga (Right)```json

- `speed`: Tezlik 0-255 oralig'ida (majburiy){

  "status": "success",

**Server javobi (muvaffaqiyatli):**  "message": "Stop command sent",

```json  "mode": 0

{}

  "status": "ok",```

  "action": "move",

  "direction": 1,---

  "speed": 200

}### 4. Signal Command

```**Endpoint:** `POST /signal`



**Server javobi (xato):****Description:** Signallar (zvuk, yorug'lik) ishga tushiradi

```json

{**Request Body:**

  "error": "USB not connected"```json

}{

```  "type": 1,

  "value": 200

---}

```

#### 2.2. Robot to'xtatish (Stop)

**Parameters:**

**Client yuboradi:**- `type` (integer, required): Signal turi

```json  - `1` = Beep (Zvuk signali)

{  - `2` = Light (Yorug'lik)

  "action": "stop",- `value` (integer, required): Signal qiymati (0-255)

  "mode": 0

}**cURL Example:**

``````bash

curl -X POST "http://192.168.100.208:5050/signal?api_key=robo-bridge-default-key-change-me" \

**Parametrlar:**  -H "Content-Type: application/json" \

- `action`: "stop" (majburiy)  -d '{"type":1,"value":200}'

- `mode`: To'xtatish rejimi (ixtiyoriy, default: 0)```

  - `0` = Zudlik bilan to'xtatish

  - `1` = Sekin to'xtatish**Response (200 OK):**

```json

**Server javobi:**{

```json  "status": "success",

{  "message": "Signal command sent",

  "status": "ok",  "type": 1,

  "action": "stop"  "value": 200

}}

``````



------



#### 2.3. Signal yuborish (Signal)## 📹 Camera Endpoints



**Client yuboradi:**### 5. Camera Info

```json**Endpoint:** `GET /camera/info`

{

  "action": "signal",**Description:** Kamera haqida ma'lumot qaytaradi

  "type": 1,

  "duration": 1000**cURL Example:**

}```bash

```curl "http://192.168.100.208:5050/camera/info?api_key=robo-bridge-default-key-change-me"

```

**Parametrlar:**

- `action`: "signal" (majburiy)**Response (200 OK):**

- `type`: Signal turi (majburiy)```json

  - `1` = Horn (signal){

  - `2` = Light (chiroq)  "status": "ok",

- `duration`: Davomiyligi millisekundlarda (ixtiyoriy, default: 1000)  "camera": {

    "available": false,

**Server javobi:**    "lens_facing": "unknown",

```json    "has_flash": false

{  }

  "status": "ok",}

  "action": "signal",```

  "type": 1

}---

```

### 6. Capture Image

---**Endpoint:** `GET /camera/capture`



#### 2.4. Heartbeat (Aloqani saqlash)**Description:** Kameradan rasmni tangallaydi va JPEG formatida qaytaradi



**Client yuboradi:****cURL Example:**

```json```bash

{curl "http://192.168.100.208:5050/camera/capture?api_key=robo-bridge-default-key-change-me" \

  "action": "heartbeat"  -o capture.jpg

}```

```

**Response:**

**Maqsad:** Server 2 soniya ichida heartbeat olmasa, robotni avtomatik to'xtatadi.- Header: `Content-Type: image/jpeg`

- Body: JPEG image binary data

**Server javobi:**

```json**Status Codes:**

{- `200 OK`: Rasm muvaffaqiyatli tangallandi

  "status": "ok",- `503 Service Unavailable`: Kamera initialized emas

  "action": "heartbeat"

}---

```

### 7. Switch Camera

---**Endpoint:** `POST /camera/switch`



## 💻 To'liq kod misollari**Description:** Oldingi/orqadagi kamera o'rtasida almashish



### JavaScript/Browser WebSocket Client**cURL Example:**

```bash

```javascriptcurl -X POST "http://192.168.100.208:5050/camera/switch?api_key=robo-bridge-default-key-change-me"

class RobotController {```

  constructor(robotIP, robotPort = 5050) {

    this.ws = null;**Response (200 OK):**

    this.robotIP = robotIP;```json

    this.robotPort = robotPort;{

    this.heartbeatInterval = null;  "status": "success",

  }  "message": "Camera switched",

  "camera": {

  connect() {    "available": true,

    this.ws = new WebSocket(`ws://${this.robotIP}:${this.robotPort}/control/ws`);    "lens_facing": "back",

        "has_flash": true

    this.ws.onopen = () => {  }

      console.log('✅ Robot ulandi!');}

      this.startHeartbeat();```

    };

    **Error Responses:**

    this.ws.onmessage = (event) => {- `400 Bad Request`: Faqat bitta kamera mavjud

      const data = JSON.parse(event.data);- `503 Service Unavailable`: Kamera initialized emas

      console.log('📩 Server javobi:', data);

      ---

      if (data.error) {

        console.error('❌ Xato:', data.error);### 8. Camera Flash

      }**Endpoint:** `POST /camera/flash`

    };

    **Description:** Kamera flash ni o'chish/o'rniga qo'yish

    this.ws.onerror = (error) => {

      console.error('❌ WebSocket xato:', error);**Request Body:**

    };```json

    {

    this.ws.onclose = () => {  "mode": "on"

      console.log('🔌 Aloqa uzildi');}

      this.stopHeartbeat();```

    };

  }**Parameters:**

- `mode` (string): Flash rejimi

  // Heartbeat - har 1.5 soniyada yuborish (2 soniyadan oldin)  - `"on"` = Flash ishga tushir

  startHeartbeat() {  - `"off"` = Flash o'chir

    this.heartbeatInterval = setInterval(() => {  - `"auto"` = Avtomatik rejim

      this.send({ action: 'heartbeat' });

    }, 1500);**cURL Example:**

  }```bash

curl -X POST "http://192.168.100.208:5050/camera/flash?api_key=robo-bridge-default-key-change-me" \

  stopHeartbeat() {  -H "Content-Type: application/json" \

    if (this.heartbeatInterval) {  -d '{"mode":"on"}'

      clearInterval(this.heartbeatInterval);```

      this.heartbeatInterval = null;

    }---

  }

### 9. Camera Stream (MJPEG)

  send(data) {**Endpoint:** `GET /camera/stream`

    if (this.ws && this.ws.readyState === WebSocket.OPEN) {

      this.ws.send(JSON.stringify(data));**Description:** Kameradan MJPEG video streamini qaytaradi

    } else {

      console.error('❌ WebSocket ulanmagan!');**Response:**

    }- Header: `Content-Type: multipart/x-mixed-replace; boundary=frame`

  }- Body: Continuous MJPEG stream



  // Oldinga harakat**cURL Example (preview mode):**

  moveForward(speed = 200) {```bash

    this.send({ action: 'move', dir: 1, speed: speed });curl "http://192.168.100.208:5050/camera/stream?api_key=robo-bridge-default-key-change-me" \

  }  -H "Accept: image/jpeg" | ffmpeg -i pipe:0 -vf fps=2 output_%04d.jpg

```

  // Orqaga harakat

  moveBackward(speed = 200) {---

    this.send({ action: 'move', dir: 2, speed: speed });

  }### 10. Camera Preview (Single Frame)

**Endpoint:** `GET /camera/preview`

  // Chapga burish

  turnLeft(speed = 150) {**Description:** Kameradan bitta JPEG frame qaytaradi

    this.send({ action: 'move', dir: 3, speed: speed });

  }**Response:**

- Header: `Content-Type: image/jpeg`

  // O'ngga burish- Body: Single JPEG image

  turnRight(speed = 150) {

    this.send({ action: 'move', dir: 4, speed: speed });---

  }

## 🔌 WebSocket Endpoints

  // To'xtatish

  stop() {### 11. Real-time Control WebSocket

    this.send({ action: 'stop', mode: 0 });**Endpoint:** `ws://ROBOT_IP:5050/control/ws`

  }

**Description:** Real-time button press/release va robot control uchun WebSocket

  // Signal

  horn(duration = 1000) {**Connection:**

    this.send({ action: 'signal', type: 1, duration: duration });```javascript

  }const apiKey = 'robo-bridge-default-key-change-me';

const ws = new WebSocket(`ws://192.168.100.208:5050/control/ws?api_key=${apiKey}`);

  // Chiroq

  light(duration = 1000) {ws.onopen = () => console.log('Connected');

    this.send({ action: 'signal', type: 2, duration: duration });ws.onmessage = (event) => {

  }  const response = JSON.parse(event.data);

  console.log(response);

  disconnect() {};

    this.stopHeartbeat();ws.onerror = (error) => console.error('Error:', error);

    if (this.ws) {ws.onclose = () => console.log('Disconnected');

      this.ws.close();```

    }

  }**Message Format (Browser -> Robot):**

}

#### Move Command

// Ishlatish:```json

const robot = new RobotController('192.168.1.100');{

robot.connect();  "action": "move",

  "dir": 1,

// Tugmalar bilan boshqarish  "speed": 150

document.getElementById('forward').addEventListener('mousedown', () => robot.moveForward(200));}

document.getElementById('forward').addEventListener('mouseup', () => robot.stop());```



document.getElementById('backward').addEventListener('mousedown', () => robot.moveBackward(200));#### Stop Command

document.getElementById('backward').addEventListener('mouseup', () => robot.stop());```json

{

document.getElementById('left').addEventListener('mousedown', () => robot.turnLeft(150));  "action": "stop",

document.getElementById('left').addEventListener('mouseup', () => robot.stop());  "mode": 0

}

document.getElementById('right').addEventListener('mousedown', () => robot.turnRight(150));```

document.getElementById('right').addEventListener('mouseup', () => robot.stop());

#### Signal Command

document.getElementById('horn').addEventListener('click', () => robot.horn(500));```json

```{

  "action": "signal",

---  "type": 1,

  "value": 200

### Python WebSocket Client}

```

```python

import asyncio#### Heartbeat

import websockets```json

import json{

  "action": "heartbeat"

class RobotController:}

    def __init__(self, robot_ip, robot_port=5050):```

        self.robot_ip = robot_ip

        self.robot_port = robot_port**Response Format (Robot -> Browser):**

        self.ws = None

        self.heartbeat_task = NoneSuccess:

```json

    async def connect(self):{

        uri = f"ws://{self.robot_ip}:{self.robot_port}/control/ws"  "status": "ok",

        self.ws = await websockets.connect(uri)  "action": "move",

        print("✅ Robot ulandi!")  "direction": 1,

          "speed": 150

        # Heartbeat boshlash}

        self.heartbeat_task = asyncio.create_task(self.heartbeat())```

        

        # Javoblarni tinglashError:

        asyncio.create_task(self.listen())```json

{

    async def heartbeat(self):  "error": "USB not connected",

        """Har 1.5 soniyada heartbeat yuborish"""  "action": "move"

        while True:}

            await asyncio.sleep(1.5)```

            await self.send({"action": "heartbeat"})

---

    async def listen(self):

        """Server javoblarini tinglash"""### 12. Camera Stream WebSocket

        async for message in self.ws:**Endpoint:** `ws://ROBOT_IP:5050/camera/ws`

            data = json.loads(message)

            print(f"📩 Server javobi: {data}")**Description:** Real-time kamera streaming uchun WebSocket

            if "error" in data:

                print(f"❌ Xato: {data['error']}")**Message Format:**

- Binary frames: JPEG image data

    async def send(self, data):- Text messages: Control commands (same as control/ws)

        """Ma'lumot yuborish"""

        if self.ws:---

            await self.ws.send(json.dumps(data))

## 🎬 MediaMTX Streaming Endpoints

    async def move_forward(self, speed=200):

        await self.send({"action": "move", "dir": 1, "speed": speed})### 13. Streaming Status

**Endpoint:** `GET /streaming/status`

    async def move_backward(self, speed=200):

        await self.send({"action": "move", "dir": 2, "speed": speed})**Description:** MediaMTX streaming serveri statusini qaytaradi



    async def turn_left(self, speed=150):**Response:**

        await self.send({"action": "move", "dir": 3, "speed": speed})```json

{

    async def turn_right(self, speed=150):  "status": "running",

        await self.send({"action": "move", "dir": 4, "speed": speed})  "rtsp_url": "rtsp://192.168.100.208:8554/stream",

  "hls_url": "http://192.168.100.208:8888/stream.m3u8",

    async def stop(self):  "mjpeg_url": "http://192.168.100.208:8888/stream.mjpeg"

        await self.send({"action": "stop", "mode": 0})}

```

    async def horn(self, duration=1000):

        await self.send({"action": "signal", "type": 1, "duration": duration})---



    async def disconnect(self):### 14. Start Streaming

        if self.heartbeat_task:**Endpoint:** `POST /streaming/start`

            self.heartbeat_task.cancel()

        if self.ws:**Description:** MediaMTX streaming serverini ishga tushiradi

            await self.ws.close()

**Response:**

# Ishlatish:```json

async def main():{

    robot = RobotController("192.168.1.100")  "status": "success",

    await robot.connect()  "message": "Streaming started",

      "rtsp_url": "rtsp://192.168.100.208:8554/stream",

    # Oldinga 2 soniya  "hls_url": "http://192.168.100.208:8888/stream.m3u8"

    await robot.move_forward(200)}

    await asyncio.sleep(2)```

    await robot.stop()

    ---

    # Signal

    await robot.horn(500)### 15. Stop Streaming

    **Endpoint:** `POST /streaming/stop`

    await asyncio.sleep(1)

    await robot.disconnect()**Description:** MediaMTX streaming serverini to'xtatadi



asyncio.run(main())**Response:**

``````json

{

---  "status": "success",

  "message": "Streaming stopped"

### Node.js WebSocket Client}

```

```javascript

const WebSocket = require('ws');---



class RobotController {## 🔐 Error Responses

  constructor(robotIP, robotPort = 5050) {

    this.robotIP = robotIP;### 401 Unauthorized

    this.robotPort = robotPort;```json

    this.ws = null;{

    this.heartbeatInterval = null;  "error": "Unauthorized",

  }  "message": "Invalid or missing X-API-Key header or api_key parameter"

}

  connect() {```

    return new Promise((resolve, reject) => {

      this.ws = new WebSocket(`ws://${this.robotIP}:${this.robotPort}/control/ws`);### 400 Bad Request

      ```json

      this.ws.on('open', () => {{

        console.log('✅ Robot ulandi!');  "error": "Bad Request",

        this.startHeartbeat();  "message": "Missing dir or speed parameter"

        resolve();}

      });```

      

      this.ws.on('message', (data) => {### 503 Service Unavailable

        const response = JSON.parse(data);```json

        console.log('📩 Server javobi:', response);{

          "error": "Service Unavailable",

        if (response.error) {  "message": "USB not connected"

          console.error('❌ Xato:', response.error);}

        }```

      });

      ### 500 Internal Server Error

      this.ws.on('error', (error) => {```json

        console.error('❌ WebSocket xato:', error);{

        reject(error);  "error": "Internal Server Error",

      });  "message": "Exception message here"

      }

      this.ws.on('close', () => {```

        console.log('🔌 Aloqa uzildi');

        this.stopHeartbeat();---

      });

    });## 📊 Configuration Values

  }

### Direction Constants

  startHeartbeat() {```

    this.heartbeatInterval = setInterval(() => {dirForward  = 1

      this.send({ action: 'heartbeat' });dirBackward = 2

    }, 1500);dirLeft     = 3

  }dirRight    = 4

```

  stopHeartbeat() {

    if (this.heartbeatInterval) {### Stop Modes

      clearInterval(this.heartbeatInterval);```

      this.heartbeatInterval = null;stopImmediate = 0

    }stopGradual   = 1

  }```



  send(data) {### Signal Types

    if (this.ws && this.ws.readyState === WebSocket.OPEN) {```

      this.ws.send(JSON.stringify(data));signalBeep  = 1

    } else {signalLight = 2

      console.error('❌ WebSocket ulanmagan!');```

    }

  }### Default Settings

```

  moveForward(speed = 200) {API Key:     robo-bridge-default-key-change-me

    this.send({ action: 'move', dir: 1, speed });HTTP Port:   5050

  }USB Baud:    115200

Max Freq:    20 Hz

  moveBackward(speed = 200) {```

    this.send({ action: 'move', dir: 2, speed });

  }---



  turnLeft(speed = 150) {## 🧪 Quick Test Script

    this.send({ action: 'move', dir: 3, speed });

  }```bash

#!/bin/bash

  turnRight(speed = 150) {ROBOT_IP="192.168.100.208"

    this.send({ action: 'move', dir: 4, speed });API_KEY="robo-bridge-default-key-change-me"

  }BASE_URL="http://$ROBOT_IP:5050"



  stop() {# Health check

    this.send({ action: 'stop', mode: 0 });echo "=== Health Check ==="

  }curl "$BASE_URL/health?api_key=$API_KEY" | jq .



  horn(duration = 1000) {# Move forward

    this.send({ action: 'signal', type: 1, duration });echo -e "\n=== Move Forward ==="

  }curl -X POST "$BASE_URL/move?api_key=$API_KEY" \

  -H "Content-Type: application/json" \

  disconnect() {  -d '{"dir":1,"speed":200}' | jq .

    this.stopHeartbeat();

    if (this.ws) {# Stop

      this.ws.close();echo -e "\n=== Stop ==="

    }curl -X POST "$BASE_URL/stop?api_key=$API_KEY" \

  }  -H "Content-Type: application/json" \

}  -d '{"mode":0}' | jq .



// Ishlatish:# Signal beep

async function demo() {echo -e "\n=== Signal Beep ==="

  const robot = new RobotController('192.168.1.100');curl -X POST "$BASE_URL/signal?api_key=$API_KEY" \

  await robot.connect();  -H "Content-Type: application/json" \

    -d '{"type":1,"value":200}' | jq .

  // Oldinga 2 soniya

  robot.moveForward(200);# Camera info

  await new Promise(r => setTimeout(r, 2000));echo -e "\n=== Camera Info ==="

  robot.stop();curl "$BASE_URL/camera/info?api_key=$API_KEY" | jq .

  

  // Signal# Streaming status

  robot.horn(500);echo -e "\n=== Streaming Status ==="

  curl "$BASE_URL/streaming/status?api_key=$API_KEY" | jq .

  await new Promise(r => setTimeout(r, 1000));```

  robot.disconnect();

}---



demo();## 📝 Notes

```

1. **WebSocket Heartbeat:** Ag'debarb bo'lgan movement uchun heartbeat har 2 soniyada talab qilinadi. Aks holda robot avtomatik to'xtaydi.

---

2. **CORS:** Barcha API endpoints CORS headers bilan javob beradi (browser tarafından ishlash uchun).

## 🎮 Keyboard boshqaruvi misoli

3. **Port 5050:** Hamma HTTP va WebSocket endpoints shu portda ishlaydı.

```html

<!DOCTYPE html>4. **IPWebcam Integration:** Tashqi IPWebcam app PORT:8080 da video stream qaytaradi.

<html lang="uz">

<head>5. **Performance:** Robot control uchun WebSocket tavsiya qilinadi (low latency, real-time).

  <meta charset="UTF-8">

  <meta name="viewport" content="width=device-width, initial-scale=1.0">---

  <title>Robot Keyboard Boshqaruv</title>

  <style>**Last Updated:** October 16, 2025  

    body {**Version:** 1.0 - Port 5050 Only

      font-family: Arial, sans-serif;

      max-width: 600px;**Port Configuration:**

      margin: 50px auto;- **HTTP/WebSocket:** :5050 (all endpoints)

      padding: 20px;- **IPWebcam:** :8080 (external app only)

      background: #f0f0f0;

    }

    .status {---

      padding: 15px;

      margin-bottom: 20px;
      border-radius: 8px;
      font-weight: bold;
    }
    .connected { background: #d4edda; color: #155724; }
    .disconnected { background: #f8d7da; color: #721c24; }
    .controls {
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    .info {
      margin-top: 20px;
      padding: 15px;
      background: #d1ecf1;
      border-radius: 8px;
      color: #0c5460;
    }
    code {
      background: #f8f9fa;
      padding: 2px 6px;
      border-radius: 3px;
      font-family: monospace;
    }
  </style>
</head>
<body>
  <div id="status" class="status disconnected">
    ❌ Ulanmagan
  </div>

  <div class="controls">
    <h2>⌨️ Keyboard Boshqaruv</h2>
    <div class="info">
      <strong>Tugmalar:</strong><br>
      <code>W</code> yoki <code>↑</code> - Oldinga<br>
      <code>S</code> yoki <code>↓</code> - Orqaga<br>
      <code>A</code> yoki <code>←</code> - Chapga<br>
      <code>D</code> yoki <code>→</code> - O'ngga<br>
      <code>Space</code> - To'xtatish<br>
      <code>H</code> - Signal (Horn)<br>
      <code>L</code> - Chiroq (Light)
    </div>
  </div>

  <script>
    const ROBOT_IP = '192.168.1.100'; // O'zingizning robot IP
    const ROBOT_PORT = 5050;
    
    let ws = null;
    let heartbeatInterval = null;
    let keysPressed = new Set();

    // Ulanish
    function connect() {
      ws = new WebSocket(`ws://${ROBOT_IP}:${ROBOT_PORT}/control/ws`);
      
      ws.onopen = () => {
        document.getElementById('status').className = 'status connected';
        document.getElementById('status').textContent = '✅ Ulandi';
        startHeartbeat();
      };
      
      ws.onmessage = (event) => {
        const data = JSON.parse(event.data);
        console.log('Server:', data);
      };
      
      ws.onerror = (error) => {
        console.error('Xato:', error);
      };
      
      ws.onclose = () => {
        document.getElementById('status').className = 'status disconnected';
        document.getElementById('status').textContent = '❌ Ulanmagan';
        stopHeartbeat();
      };
    }

    function startHeartbeat() {
      heartbeatInterval = setInterval(() => {
        send({ action: 'heartbeat' });
      }, 1500);
    }

    function stopHeartbeat() {
      if (heartbeatInterval) {
        clearInterval(heartbeatInterval);
      }
    }

    function send(data) {
      if (ws && ws.readyState === WebSocket.OPEN) {
        ws.send(JSON.stringify(data));
      }
    }

    // Keyboard events
    document.addEventListener('keydown', (e) => {
      // Takroriy bosilishni oldini olish
      if (keysPressed.has(e.key)) return;
      keysPressed.add(e.key);

      const key = e.key.toLowerCase();
      
      switch(key) {
        case 'w':
        case 'arrowup':
          send({ action: 'move', dir: 1, speed: 200 });
          break;
        case 's':
        case 'arrowdown':
          send({ action: 'move', dir: 2, speed: 200 });
          break;
        case 'a':
        case 'arrowleft':
          send({ action: 'move', dir: 3, speed: 150 });
          break;
        case 'd':
        case 'arrowright':
          send({ action: 'move', dir: 4, speed: 150 });
          break;
        case ' ':
          send({ action: 'stop', mode: 0 });
          break;
        case 'h':
          send({ action: 'signal', type: 1, duration: 500 });
          break;
        case 'l':
          send({ action: 'signal', type: 2, duration: 1000 });
          break;
      }
    });

    document.addEventListener('keyup', (e) => {
      keysPressed.delete(e.key);
      
      const key = e.key.toLowerCase();
      
      // Harakat tugmalari bo'shaganda to'xtatish
      if (['w', 's', 'a', 'd', 'arrowup', 'arrowdown', 'arrowleft', 'arrowright'].includes(key)) {
        send({ action: 'stop', mode: 0 });
      }
    });

    // Sahifa yuklanganda ulanish
    connect();
  </script>
</body>
</html>
```

---

## ⚙️ Texnik xususiyatlar

### Server sozlamalari:
- **Port:** 5050
- **Protocol:** HTTP/1.1, WebSocket
- **CORS:** Enabled (barcha origin'lar ruxsat etilgan)
- **API Key:** `robobridge_secret_key_2024`

### USB Serial sozlamalari:
- **Baud Rate:** 115200
- **Data Bits:** 8
- **Stop Bits:** 1
- **Parity:** None
- **Flow Control:** None

### WebSocket xususiyatlari:
- **Heartbeat interval:** 2 soniya
- **Auto-stop:** Aloqa uzilganda yoki heartbeat kelmasa
- **Reconnect:** Client tomonda amalga oshirilishi kerak

### Yo'nalishlar:
- `1` - Oldinga (Forward)
- `2` - Orqaga (Backward)
- `3` - Chapga (Left)
- `4` - O'ngga (Right)

### Tezlik diapazoni:
- **Minimal:** 0
- **Maksimal:** 255
- **Tavsiya etilgan:** 150-200 (optimal boshqaruv uchun)

### Signal turlari:
- `1` - Horn (ovozli signal)
- `2` - Light (chiroq)

---

## 🔧 Muammolarni hal qilish

### WebSocket ulanmaydi
1. Robot IP manzilini tekshiring
2. Port 5050 ochiq ekanligini tasdiqlang
3. Network firewall sozlamalarini tekshiring
4. `ws://` protokolidan foydalanayotganingizni tekshiring (HTTPS sahifadan `wss://` kerak bo'ladi)

### Robot harakatlanmaydi
1. USB ulanishni tekshiring: `GET /health` → `usb_connected: true`
2. Tezlik qiymatini tekshiring (0-255 oralig'ida)
3. Yo'nalish qiymatini tekshiring (1-4)
4. Heartbeat yuborilayotganini tekshiring

### Avtomatik to'xtaydi
- Bu xavfsizlik mexanizmi. Heartbeat har 1.5 soniyada yuboring
- Server 2 soniyada heartbeat olmasa, avtomatik to'xtatadi

### CORS xatosi
- Server CORS qo'llab-quvvatlaydi, lekin browser'dan HTTPS sahifadan `ws://` ga ulanish imkonsiz
- HTTP sahifadan yoki localhost'dan test qiling

---

## 📦 Flutter loyihasini ishga tushirish

```bash
# Dependencies o'rnatish
flutter pub get

# Android qurilmada ishga tushirish
flutter run

# Release build qilish
flutter build apk --release

# Service log'larni ko'rish
adb logcat | grep RoboBridge
```

---

## 📞 Qo'llab-quvvatlash

Muammolar yoki savollar uchun:
- GitHub Issues: [robo_bridge/issues](https://github.com/yourusername/robo_bridge/issues)
- Email: support@robobridge.dev

---

**© 2025 RoboBridge - USB Robot Control System**







# 🤖 RoboBridge - USB Robot Control System

**Real-time WebSocket boshqaruv tizimi USB orqali ulangan robotlar uchun**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📖 Umumiy ma'lumot

RoboBridge - bu Flutter asosida yozilgan headless Android servisi bo'lib, USB Serial orqali ulangan robotlarni real-time WebSocket protokoli orqali boshqarish imkonini beradi.

### ✨ Asosiy xususiyatlar

- 🎮 **WebSocket Real-Time Boshqaruv** - past latency bilan robot harakati
- 🔌 **USB Serial Interface** - 115200 baud rate, 8N1 konfiguratsiya
- 💓 **Heartbeat Mexanizmi** - avtomatik xavfsizlik to'xtatish
- 🛡️ **Auto-Stop Protection** - aloqa uzilganda avtomatik to'xtatish
- 🔐 **API Key Autentifikatsiya** - xavfsiz kirish nazorati
- 🌐 **CORS Qo'llab-quvvatlash** - browser'dan to'g'ridan-to'g'ri boshqarish
- 📱 **Android Background Service** - doimiy ishlash
- 📊 **Health Check Endpoint** - tizim monitoringi

---

## 🚀 Tezkor boshlash

### 1. Talablar

- **Flutter SDK:** 3.9.2 yoki yuqori
- **Dart:** 3.0+
- **Android:** API level 21+ (Android 5.0+)
- **Hardware:** USB OTG qo'llab-quvvatlovchi Android qurilma

### 2. O'rnatish

```bash
# Repositoriyani klonlash
git clone https://github.com/yourusername/robo_bridge.git
cd robo_bridge

# Dependencies o'rnatish
flutter pub get

# Android qurilmada ishga tushirish
flutter run
```

### 3. Sozlash

`lib/config.dart` faylida asosiy sozlamalarni o'zgartiring:

```dart
class Config {
  // API Server
  static const int httpPort = 5050;
  static const String apiKey = 'robobridge_secret_key_2024';
  
  // USB Serial
  static const int usbBaudRate = 115200;
  
  // Robot yo'nalishlari
  static const int dirForward = 1;   // Oldinga
  static const int dirBackward = 2;  // Orqaga
  static const int dirLeft = 3;      // Chapga
  static const int dirRight = 4;     // O'ngga
}
```

---

## 📡 API Hujjatlari

**Base URL:** `http://ROBOT_IP:5050`

### Health Check

```bash
curl -H "X-API-Key: robobridge_secret_key_2024" \
  http://192.168.1.100:5050/health
```

**Response:**
```json
{
  "status": "ok",
  "usb_connected": true,
  "server_running": true,
  "timestamp": "2025-10-16T10:30:45.123Z"
}
```

### WebSocket Boshqaruv

**Endpoint:** `ws://ROBOT_IP:5050/control/ws`

#### Robot harakati
```javascript
ws.send(JSON.stringify({
  "action": "move",
  "dir": 1,        // 1=oldinga, 2=orqaga, 3=chapga, 4=o'ngga
  "speed": 200     // 0-255
}));
```

#### To'xtatish
```javascript
ws.send(JSON.stringify({
  "action": "stop",
  "mode": 0        // 0=zudlik, 1=sekin
}));
```

#### Signal
```javascript
ws.send(JSON.stringify({
  "action": "signal",
  "type": 1,       // 1=horn, 2=light
  "duration": 1000 // millisekund
}));
```

#### Heartbeat (har 1.5 soniyada)
```javascript
ws.send(JSON.stringify({
  "action": "heartbeat"
}));
```

**📚 To'liq dokumentatsiya:** [API_DOCUMENTATION.md](API_DOCUMENTATION.md)

---

## 💻 Client misollari

### JavaScript (Browser)

```javascript
const ws = new WebSocket('ws://192.168.1.100:5050/control/ws');

ws.onopen = () => {
  console.log('✅ Ulandi!');
  
  // Oldinga harakat
  ws.send(JSON.stringify({
    action: 'move',
    dir: 1,
    speed: 200
  }));
};

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Server:', data);
};
```

### Python

```python
import asyncio
import websockets
import json

async def control_robot():
    uri = "ws://192.168.1.100:5050/control/ws"
    async with websockets.connect(uri) as ws:
        # Oldinga harakat
        await ws.send(json.dumps({
            "action": "move",
            "dir": 1,
            "speed": 200
        }))
        
        response = await ws.recv()
        print(f"Server: {response}")

asyncio.run(control_robot())
```

### Node.js

```javascript
const WebSocket = require('ws');

const ws = new WebSocket('ws://192.168.1.100:5050/control/ws');

ws.on('open', () => {
  console.log('✅ Ulandi!');
  
  ws.send(JSON.stringify({
    action: 'move',
    dir: 1,
    speed: 200
  }));
});

ws.on('message', (data) => {
  console.log('Server:', JSON.parse(data));
});
```

---

## 🏗️ Arxitektura

```
┌─────────────────────────────────────────────────┐
│                  Client Apps                     │
│  (Browser, Python, Node.js, Mobile, etc.)       │
└──────────────────┬──────────────────────────────┘
                   │ WebSocket (ws://IP:5050/control/ws)
                   │
┌──────────────────▼──────────────────────────────┐
│           RoboBridge API Server                  │
│  ┌────────────────────────────────────────┐    │
│  │  HTTP Server (Port 5050)               │    │
│  │  - Health Check Endpoint               │    │
│  │  - WebSocket Handler                   │    │
│  │  - CORS Middleware                     │    │
│  │  - Auth Middleware (API Key)           │    │
│  └────────────────┬───────────────────────┘    │
│                   │                              │
│  ┌────────────────▼───────────────────────┐    │
│  │  USB Manager                           │    │
│  │  - Serial Communication (115200 baud)  │    │
│  │  - Command Queue                       │    │
│  │  - Auto-reconnect                      │    │
│  └────────────────┬───────────────────────┘    │
└───────────────────┼──────────────────────────────┘
                    │ USB Serial
┌───────────────────▼──────────────────────────────┐
│              Robot Hardware                       │
│  (Arduino, ESP32, Motor Controller, etc.)        │
└───────────────────────────────────────────────────┘
```

---

## 🛠️ Texnik stack

- **Framework:** Flutter 3.9.2
- **Language:** Dart 3.0+
- **HTTP Server:** [shelf](https://pub.dev/packages/shelf)
- **WebSocket:** [shelf_web_socket](https://pub.dev/packages/shelf_web_socket)
- **USB Serial:** [usb_serial](https://pub.dev/packages/usb_serial)
- **CORS:** [shelf_cors_headers](https://pub.dev/packages/shelf_cors_headers)

---

## 📁 Loyiha tuzilmasi

```
robo_bridge/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── config.dart               # Konfiguratsiya
│   ├── logger.dart               # Logging tizimi
│   ├── robo_bridge_service.dart  # Asosiy servis
│   ├── api_server.dart           # HTTP + WebSocket server
│   ├── usb_manager.dart          # USB Serial boshqaruv
│   └── config_manager.dart       # Sozlamalar boshqaruvi
├── web/
│   └── robot_control.html        # Test web interface
├── android/                      # Android native konfiguratsiya
├── pubspec.yaml                  # Dependencies
├── README.md                     # Ushbu fayl
└── API_DOCUMENTATION.md          # To'liq API hujjatlari
```

---

## 🔧 Konfiguratsiya

### USB Serial sozlamalari

```dart
// lib/config.dart
static const int usbBaudRate = 115200;
static const int usbDataBits = 8;
static const int usbStopBits = 1;
static const int usbParity = 0; // None
```

### Server sozlamalari

```dart
static const int httpPort = 5050;
static const String apiKey = 'robobridge_secret_key_2024';
```

### Robot parametrlari

```dart
static const int dirForward = 1;
static const int dirBackward = 2;
static const int dirLeft = 3;
static const int dirRight = 4;

static const int stopImmediate = 0;
static const int stopGradual = 1;
```

---

## 🧪 Test qilish

### 1. Health Check testi

```bash
curl -H "X-API-Key: robobridge_secret_key_2024" \
  http://localhost:5050/health
```

### 2. WebSocket testi (wscat)

```bash
# wscat o'rnatish
npm install -g wscat

# Ulanish
wscat -c ws://192.168.1.100:5050/control/ws

# Oldinga harakat
> {"action":"move","dir":1,"speed":200}

# To'xtatish
> {"action":"stop"}
```

### 3. Browser testi

`web/robot_control.html` faylini oching va robot IP manzilini kiriting.

---

## 📊 Monitoring va Logging

Barcha log'lar Android logcat orqali ko'rinadi:

```bash
# Barcha log'lar
adb logcat | grep RoboBridge

# Faqat xatolar
adb logcat *:E | grep RoboBridge

# HTTP so'rovlar
adb logcat | grep "HTTP"

# USB aloqa
adb logcat | grep "USB"

# WebSocket
adb logcat | grep "WS_CONTROL"
```

---

## 🔒 Xavfsizlik

### API Key

Barcha HTTP so'rovlar (WebSocket bundan mustasno) API key talab qiladi:

```bash
# Header orqali
curl -H "X-API-Key: robobridge_secret_key_2024" \
  http://192.168.1.100:5050/health

# Query parameter orqali
curl http://192.168.1.100:5050/health?api_key=robobridge_secret_key_2024
```

### Auto-Stop xavfsizligi

- WebSocket disconnect bo'lganda robot avtomatik to'xtaydi
- 2 soniyada heartbeat kelmasa avtomatik to'xtatish
- USB aloqa uzilsa harakatlar bajarilmaydi

---

## 🐛 Muammolarni hal qilish

### USB qurilma topilmaydi

1. USB OTG kabel ulanganini tekshiring
2. Android USB permissions berilganini tasdiqlang
3. `adb logcat | grep USB` orqali log'larni tekshiring

### WebSocket ulanmaydi

1. Robot IP manzili to'g'ri ekanligini tekshiring
2. Port 5050 ochiq ekanligini tasdiqlang
3. `ws://` protokolidan foydalaning (HTTPS sahifadan `wss://` kerak)
4. Firewall sozlamalarini tekshiring

### Robot harakatlanmaydi

1. `/health` endpoint orqali USB ulanishni tekshiring
2. Tezlik va yo'nalish qiymatlari to'g'ri ekanligini tasdiqlang
3. Heartbeat yuborilayotganini tekshiring
4. USB Serial log'larni ko'ring: `adb logcat | grep USB`

---

## 📄 Litsenziya

MIT License - batafsil ma'lumot uchun [LICENSE](LICENSE) faylini ko'ring.

---

## 🤝 Hissa qo'shish

Pull request'lar xush kelibsiz! Katta o'zgarishlar uchun avval issue oching.

1. Fork qiling
2. Feature branch yarating (`git checkout -b feature/AmazingFeature`)
3. Commit qiling (`git commit -m 'Add some AmazingFeature'`)
4. Push qiling (`git push origin feature/AmazingFeature`)
5. Pull Request oching

---

## 📞 Aloqa

- **GitHub Issues:** [robo_bridge/issues](https://github.com/yourusername/robo_bridge/issues)
- **Email:** support@robobridge.dev
- **Telegram:** @robobridge_support

---

## 🙏 Minnatdorchilik

- Flutter jamoasi - ajoyib framework uchun
- Dart pub.dev community - foydali paketlar uchun
- Barcha contributors va testers

---

**© 2025 RoboBridge - Made with ❤️ using Flutter**
