# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/openmpi/openmpi-1.2.4.ebuild,v 1.2 2007/12/13 22:39:53 jsbronder Exp $

inherit eutils multilib flag-o-matic toolchain-funcs fortran mpi

MY_P=${P/-mpi}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="http://www.open-mpi.org"
SRC_URI="http://www.open-mpi.org/software/ompi/v1.2/downloads/${MY_P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mpi-threads? ( test )"
IUSE="fortran heterogeneous ipv6 mpi-threads nocxx pbs romio threads"
RDEPEND="pbs? ( sys-cluster/torque )
	$(mpi_imp_deplist)"
DEPEND="${RDEPEND}"

pkg_setup() {
	MPI_ESELECT_FILE="eselect.mpi.openmpi"

	if use mpi-threads; then
		ewarn
		ewarn "WARNING: use of MPI_THREAD_MULTIPLE is still disabled by"
		ewarn "default and officially unsupported by upstream."
		ewarn "You may stop now and set USE=-mpi-threads"
		ewarn
		epause 5
	fi

	elog
	elog "OpenMPI has an overwhelming count of configuration options."
	elog "Don't forget the EXTRA_ECONF environment variable can let you"
	elog "specify configure options if you find them necessary."
	elog

	if use fortran; then
		FORTRAN="g77 gfortran ifc"
		fortran_pkg_setup
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix --as-needed problems with f77 and f90.
	sed -i 's:^libs=:libs=-Wl,--no-as-needed :' \
		ompi/tools/wrappers/mpif{77,90}-wrapper-data.txt.in

	# Necessary for scalibility, see
	# http://www.open-mpi.org/community/lists/users/2008/09/6514.php
	if use threads; then
		echo 'oob_tcp_listen_mode = listen_thread' \
			>> opal/etc/openmpi-mca-params.conf
	fi
}

src_compile() {
	local c="
		--without-xgrid
		--enable-pretty-print-stacktrace
		--enable-orterun-prefix-by-default
		--without-slurm"

	if use mpi-threads; then
		c="${c}
			--enable-mpi-threads
			--with-progress-threads"
	fi

	if use fortran; then
		if [[ "${FORTRANC}" = "g77" ]]; then
			c="${c} --disable-mpi-f90"
		elif [[ "${FORTRANC}" = "gfortran" ]]; then
			# Because that's just a pain in the butt.
			c="${c} --with-wrapper-fflags=-I/usr/include"
		elif [[ "${FORTRANC}" = if* ]]; then
			# Enabled here as gfortran compile times are huge with this enabled.
			c="${c} --with-mpi-f90-size=medium"
		fi
	else
		c="${c}
			--disable-mpi-f90
			--disable-mpi-f77"
	fi

	econf $(mpi_econf_args) ${c} \
		$(use_enable !nocxx mpi-cxx) \
		$(use_enable romio io-romio) \
		$(use_enable heterogeneous) \
		$(use_with pbs tm) \
		$(use_enable ipv6) \
		|| die
	emake || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	echo
	echo
	echo
	mpi_dodoc README AUTHORS NEWS VERSION
	mpi_imp_add_eselect
}

src_test() {
	# Doesn't work with the default src_test as the dry run (-n) fails.
	cd "${S}"
	emake -j1 check || die "emake check failed"
}

