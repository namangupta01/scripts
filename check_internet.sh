while :
do 
  if ping -q -c 1 -W 1 8.8.8.8 >/dev/null
    then echo "IPv4 is up $(date)" >> internet.log
  else   
    echo "IPv4 is down $(date)" >> internet.log
  fi 
  sleep 1
done
