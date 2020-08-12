device=G000K107616204ER
state=`adb -s $device shell dumpsys power | grep "Display Power: state"`
OFF=`echo -ne "Display Power: state=OFF\x0d"`





if [ "$state" = "$OFF" ]; then
    echo "Power on"
    adb -s $device shell input keyevent 26
    echo "Unlock"
    sleep 0.1
    adb -s $device shell input keyevent 82
else
    echo "Power off"
    adb -s $device shell input keyevent 26
fi
