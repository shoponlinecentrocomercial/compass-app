#!/bin/bash
echo "🚀 Iniciando compilación de la brújula..."

# Ejecutar Docker con el entorno de Capacitor
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  node:18-bullseye bash -c "
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
    ./gradlew assembleDebug
    
    echo '✅ Compilación completada!'
  "

# Verificar que el APK se generó
if [ -f "android/app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo "🎉 APK generado con éxito en: android/app/build/outputs/apk/debug/app-debug.apk"
    ls -lh android/app/build/outputs/apk/debug/app-debug.apk
else
    echo "❌ Error: No se pudo generar el APK"
fi
