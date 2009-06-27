= Introduction =
Empi is basically a reworking of vapier's crossdev script to
handle installing multiple mpi implementations and applications
that depend on them.  This is done through trickery involving
adding categories that portage will recognize, moving mpi-enabled
packages (defined as those using mpi.eclass) to a local overlay
directory and then emerging these packages using the new
category.

Empi handles getting mpi application ebuilds into the overlay,
copying anything in package.{use,keywords}, and wrapping the
emerge process.  The eclass handles putting the package files
into separate "root" directories based on the category name as
well as making sure the applications build against the
appropriate environment.

I also provide eselect-mpi, which unlike every other eselect
module I've ever used, is designed to manage a users personal
environment by writing to ${HOME}/.env.d/mpi.  This provides a
quick and easy way for users to experiment with various
implementations while imposing on any other user's ability to
use their preferred implementation.

The newly written mpi.eclass should handle empi-based and standard
emerging of packages in a manner that enables package maintainers
to quickly port their applications without much knowledge of the
underlying mechanics.  At least, that was my intent, maybe I
succeeded.


= Definitions =
Class:  Fake category name used by empi.  Must be
    prefixed with mpi-
Base Implementation:  Actual mpi-implementation package that will
    provide all mpi functionality to the above.


= Instructions =

The following creates a class called "mpi-openmpi"
using sys-cluster/openmpi as the base implementation.  We also
set some USE flags and make sure to unmask the appropriate
version of sys-cluster/openmpi.  Long options and full package
atoms are used, but not required.

1.) Sync the science overlay.

2.) Emerge empi

3.) Setup /etc/portage/package stuff.
    # echo ">=sys-cluster/openmpi-1.2.5-r1 pbs fortran romio smp" >> /etc/portage/package.use
    # echo ">=sys-cluster/openmpi-1.2.5-r1" >> /etc/portage/package.keywords

4.) Create the implementation.
    # empi --create --class mpi-openmpi =sys-cluster/openmpi-1.2.5-r1

5.) Add packages.
    # empi --add --class mpi-openmpi hpl mpi-examples

6.) Setup your user.
    $ eselect mpi set mpi-openmpi
    $ echo <<-EOF >> .bash_profile
for i in $(ls ${HOME}/.env.d/*); do
    source ${i}
done
EOF
    $ source .bash_profile

7.) Do stuff, or decide this is all worthless and cleanup the mess.
    # empi --delete mpi-openmpi


= Links =
http://dev.gentoo.org/~vapier/CROSS-COMPILE-HOWTO
http://archives.gentoo.org/gentoo-cluster/msg_f29032b0d85f7f47d9e52940e9322d91.xml
http://dev.gentoo.org/~jsbronder/empi.xml
