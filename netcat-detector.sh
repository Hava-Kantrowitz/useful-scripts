#!/bin/bash
# Made and owned by Federico Cassano
# Requires to be ran after logging running processes
# in common.sh
  cat runningProcesses.log
read -p "What is the name of the suspected netcat?[none]: " nc
if [ $nc == "none"];
then
  echo "k xd"
else
  whereis $nc > Path
  ALIAS=`alias | grep nc | cut -d' ' -f2 | cut -d'=' -f1`
  PID=`pgrep $nc`
  for path in `cat Path`
  do
      echo $path
      if [ $? -eq 0 ]
      then
          sed -i 's/^/#/' $path
          kill $PID
      else
          echo "This is not a netcat process."
      fi
  done
fi

ls /etc/init | grep $nc.conf >> /dev/null
if [ $? -eq 0 ]
then
    cat /etc/init/$nc.conf | grep -E -i 'nc|netcat|$ALIAS' >> /dev/null
    if [ $? -eq 0 ]
    then
        sed -i 's/^/#/' /etc/init/$nc.conf
        kill $PID
    else
        echo "This is not a netcat process."
    fi
fi

ls /etc/init.d | grep $nc >>/dev/null
if [ $? -eq 0 ]
then
    cat /etc/init.d/$nc | grep -E -i 'nc|netcat|$ALIAS' >> /dev/null
    if [ $? -eq 0 ]
    then
        sed -i 's/^/#/' /etc/init.d/$nc
        kill $PID
    else
        echo "This is not a netcat process."
    fi
fi

ls /etc/cron.d | grep $nc >>/dev/null
if [ $? -eq 0 ]
then
    cat /etc/cron.d/$nc | grep -E -i 'nc|netcat|$ALIAS' >> /dev/null
    if [ $? -eq 0 ]
    then
        sed -i 's/^/#/' /etc/init.d/$nc
        kill $PID
    else
        echo "This is not a netcat process."
    fi
fi

ls /etc/cron.hourly | grep $nc >>/dev/null
if [ $? -eq 0 ]
then
    cat /etc/cron.hourly/$nc | grep -E -i 'nc|netcat|$ALIAS' >> /dev/null
    if [ $? -eq 0 ]
    then
        sed -i 's/^/#/' /etc/init.d/$nc
        kill $PID
    else
        echo "This is not a netcat process."
    fi
fi

for x in $(ls /var/spool/cron/crontabs)
do
  cat $x | grep '$nc|nc|netcat|$ALIAS'
  if [ $? -eq 0 ]
  then
    sed -i 's/^/#/' /var/spool/cron/crontabs/$x
    kill $PID
  else
    echo "netcat has not been found in $x crontabs."
  fi
done

cat /etc/crontab | grep -i 'nc|netcat|$ALIAS'
if [ $? -eq 0 ]
then
  echo "NETCAT FOUND IN CRONTABS! GO AND REMOVE!!!!!!!!!!"
fi
