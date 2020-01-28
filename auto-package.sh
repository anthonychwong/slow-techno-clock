# /bin/sh

rm -r ./package-test/*

cd ./slow_techno_clock

rm -r ./android
rm -r ./ios
rm -r ./web

flutter clean

cd -

zip -r slow-techno-clock flutter_clock_helper slow_techno_clock -x "*.DS_Store"

mv slow-techno-clock.zip ./package-test
