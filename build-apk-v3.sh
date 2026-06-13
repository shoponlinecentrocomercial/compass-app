#!/bin/bash
echo "🚀 Compilando con imagen especializada..."

docker run --rm \
  -v $(pwd):/app \
  -w /app \
  gerrithoskins/capacitor-gitlab-bundle bash -c "
    echo '📦 Instalando Capacitor...'
    npm install @capacitor/core @capacitor/cli @capacitor/android
    
    echo '🔧 Configurando Capacitor...'
    npx cap init 'Brújula' 'com.compass.app' --web-dir=www
    npx cap add android
    npx cap sync android
    
    echo '🏗️ Compilando APK...'
    cd android
    ./gradlew assembleDebug --no-daemon
    
    echo '✅ Listo!'
  "

if [ -f "android/app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "🎉 APK generado: android/app/build/outputs/apk/debug/app-debug.apk"
    ls -lh android/app/build/outputs/apk/debug/app-debug.apk
else
    echo "❌ Falló la compilación"
fi
