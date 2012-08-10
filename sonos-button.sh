#bash script that detects changes on GPIO port

i="1"
buttonstatus=0

`echo "17" > /sys/class/gpio/export`
`echo "in" > /sys/class/gpio/gpio17/direction`

while [ $i -gt 0 ]
do
	read -r buttonstatus</sys/class/gpio/gpio17/value
	
	if [ $buttonstatus -eq 1 ]
	then
		echo 'stop'
		`/home/pi/.rvm/bin/ruby sonos-stop.rb`
	fi
		sleep 1;
	i=$[$i+1];
done
