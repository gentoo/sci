# Config file for /etc/init.d/foldingathome
#
# The f@h client configuration can be found in /opt/foldingathome/client.cfg
# Run /opt/foldingathome/initfolding to reconfigure that.
#
# Enter options here to be passed to the Folding client:
#
#  -oneunit	Instruct the client to quit following the completion of one work unit.
#  -verbosity x Sets the output level, from 1 to 9 (max). The default is 3
#  -forceasm    Force core assembly optimizations to be used if available
#  -advmethods  Request to be assigned any new Cores or work units.
#  -smp		Set the client to run in SMP mode (multicore)
#
# A full listing of options can be found here:
# http://www.stanford.edu/group/pandegroup/folding/console-userguide.html
# But use of other options are not recommended when using the Folding client
# as a service.
#
FOLD_OPTS=""
PIDFILE=/var/run/folding

