#!/bin/bash
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  -e GRADLE_OPTS="-Xmx2048m" \
  androidsdk/android-31:latest bash -c "
    echo '📦 Instalando Node.js...'
    apt-get update && apt-get install -y nodejs npm
    
    echo '📦 Instalando Capacitor...'
    npm install @capacitor/core @capacitor/cli @capacitor/android
    
    echo '🔧 Configurando...'
    npx cap init 'Brújula' 'com.compass.app' --web-dir=www
    npx cap add android
    npx cap sync android
    
    echo '🏗️ Compilando...'
    cd android
    ./gradlew assembleDebug --no-daemon
  "

find . -name "*.apk" -type f
