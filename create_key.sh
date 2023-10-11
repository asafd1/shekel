
keytool -genkey -v -keystore shekel-app-upload-key.jks -alias shekel-app-upload-key -keyalg RSA -keysize 2048 -validity 10000 -storepass $1 -keypass $1