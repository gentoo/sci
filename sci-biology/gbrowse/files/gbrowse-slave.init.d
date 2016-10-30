#!/bin/sh
### BEGIN INIT INFO
# Provides:          gbrowse_slave
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     28
# Default-Stop:      S
# Short-Description: Start/Stop the gbrowse_slave rendering server.
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=$INSTALLSCRIPT/gbrowse_slave
NAME="gbrowse-slave"
DESC="GBrowse slave track rendering server"

test -x $DAEMON || exit 0
set -e

USER=$WWWUSER
PRELOAD=""
RUNDIR=/var/run/gbrowse
LOGDIR=/var/log/gbrowse
PORT='8101'
VERBOSITY=1
NICE=0

if [ -f /etc/default/gbrowse-slave ]; then
  . /etc/default/gbrowse-slave
fi

mkdir -p $RUNDIR
chown -R $USER $RUNDIR
mkdir -p $LOGDIR
chown -R $USER $LOGDIR

case "$1" in
  start)
	echo -n "Starting $DESC: $NAME "
	for port in $PORT; do
	    if test -e $RUNDIR/$NAME.$port.pid ; then
		echo "$NAME already running, use restart instead."
	    else
                PRELOAD_DB=""
		if [ "$PRELOAD" != "" ]; then
                    PRELOAD_DB="--preload $PRELOAD"
	        fi
		ARGS="--port $port --verbose $VERBOSITY --log $LOGDIR/gbrowse_slave --pid $RUNDIR/$NAME.$port.pid $PRELOAD_DB"
		su $USER -s /bin/sh -c "nice -n $NICE $DAEMON $ARGS"
		echo -n "$port "
	    fi
	done
	echo "."
	;;
  stop)
	echo -n "Stopping $DESC: $NAME "
	killed=0
	for port in $PORT; do
	    if test -e $RUNDIR/$NAME.$port.pid ; then
		kill -TERM `cat $RUNDIR/$NAME.$port.pid`
		killed=1
	    fi
            echo -n "$port "
        done
	if [ "$killed" -ne 1 ]; then
	    base=`basename $DAEMON`
	    killall -q -r $base || true
        fi
	echo "."
	;;
  status)
       for port in $PORT; do
               if test -e $RUNDIR/$NAME.$port.pid ; then
                       kill -0 `cat $RUNDIR/$NAME.$port.pid`
                       if [ "$?" -eq 0 ]; then
                               echo "$NAME is running on port $port."
                       fi
               else
                       echo "$NAME is not running on port $port."
               fi
       done
       ;;
  restart|force-reload)
	$0 stop
	sleep 3
	$0 start
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload|status}" >&2
	exit 1
	;;
esac

exit 0
