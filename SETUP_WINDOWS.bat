@echo off
echo Preparando EnRango...
flutter create . --platforms=android,web,windows
flutter pub get
echo.
echo Proyecto preparado. Abre esta carpeta en Android Studio.
pause
