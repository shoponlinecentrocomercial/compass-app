#!/bin/bash
echo "🚀 Compilando para arquitectura ARM64..."

# Usar una imagen ARM64 oficial de Eclipse Temurin (Java 17)
docker run --rm \
  -v $(pwd):/app \
  -w /app \
  -e GRADLE_OPTS="-Xmx2048m" \
  --platform linux/arm64 \
  eclipse-temurin:17-jdk bash -c "
    echo '📦 Instalando Node.js...'
    apt-get update && apt-get install -y curl
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs
    
    echo '📦 Instalando Capacitor...'
    npm install @capacitor/core @capacitor/cli @capacitor/android
    
    echo '🔧 Configurando...'
    npx cap init 'Brújula' 'com.compass.app' --web-dir=www
    npx cap add android
    npx cap sync android
    
    echo '🏗️ Compilando...'
    cd android
    chmod +x gradlew
    ./gradlew assembleDebug --no-daemon
  "

# Buscar el APK generado
APK_PATH=$(find . -name "*.apk" -type f 2>/dev/null | head -1)
if [ -n "$APK_PATH" ]; then
    echo "🎉 APK generado: $APK_PATH"
    ls -lh "$APK_PATH"
    # Copiar a un lugar accesible
    cp "$APK_PATH" /opt/compass-app/brújula.apk
    echo "📱 Copiado a: /opt/compass-app/brújula.apk"
else
    echo "❌ No se encontró el APK generado"
fi
