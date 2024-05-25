fvm dart run pigeon \
  --input ./pigeons/calendar.dart \
  --dart_out ./lib/pigeons/calendar.dart \
  --kotlin_out ./android/app/src/main/kotlin/com/liziyi0914/gamingepochs/pigeons/Calendar.kt \
  --kotlin_package com.liziyi0914.gamingepochs.pigeons.calendar

fvm dart run pigeon \
  --input ./pigeons/jpush.dart \
  --dart_out ./lib/pigeons/jpush.dart \
  --kotlin_out ./android/app/src/main/kotlin/com/liziyi0914/gamingepochs/pigeons/JPush.kt \
  --kotlin_package com.liziyi0914.gamingepochs.pigeons.jpush