#!/bin/bash
echo "🚀 Iniciando compilación de la brújula..."

# Usar una imagen que incluya Node.js y Java 17
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  -e JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 \
  openjdk:17-jdk-bullseye bash -c "
    echo '📦 Instalando Node.js...'
    apt-get update && apt-get install -y curl
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    
    echo '📦 Instalando dependencias...'
    npm install @capacitor/core @capacitor/cli @capacitor/android
    
    echo '🔧 Inicializando Capacitor...'
    npx cap init 'Brújula' 'com.compass.app' --web-dir=www
    
    echo '📱 Añadiendo plataforma Android...'
    npx cap add android
    
    echo '🔄 Sincronizando archivos...'
    npx cap sync android
    
    echo '🏗️ Compilando APK...'
    cd android
    chmod +x gradlew
    ./gradlew assembleDebug --no-daemon
    
    echo '✅ Compilación completada!'
  "

# Verificar que el APK se generó
if [ -f "android/app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "🎉 APK generado con éxito!"
    ls -lh android/app/build/outputs/apk/debug/app-debug.apk
else
    echo "❌ Error: No se pudo generar el APK"
fi
