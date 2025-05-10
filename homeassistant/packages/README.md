         +----------------+
         |    Home Assistant|
         +----------------+
                  |
                  v
         +----------------+
         | sun.sun changes |
         +----------------+
             /        \
            /          \
         sunset       sunrise
           |             |
           v             v
   light.turn_on   light.turn_off
 (with fade 2s)    (with fade 2s)

                  |
                  v
         +----------------+
         | Ambient Light   |
         | Sensor (lux)    |
         +----------------+
             /        \
            /          \
        lux < 30     lux > 50
           |             |
           v             v
   light.turn_on   light.turn_off
 (only daytime)   (only daytime)
