cd $ANDROID_HOME/emulator
./emulator -list-avds
first_avd=$(./emulator -list-avds | tail -n 1)
./emulator -avd $first_avd
cd -