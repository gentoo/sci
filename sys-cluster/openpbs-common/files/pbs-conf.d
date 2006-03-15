# /etc/conf.d/pbs
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later

# Set this to 1 if you want to run both MOM and the server on the same machine.
# Set it to 0 if you don't want to run any jobs on your head/master.
#PBS_SERVER_AND_MOM=0
PBS_SERVER_AND_MOM=1

# Uncomment the next 2 lines to use the maui scheduler
#PBS_SCHEDULER=maui
#PBS_SCHEDULER_PID=/usr/spool/maui/maui.pid
