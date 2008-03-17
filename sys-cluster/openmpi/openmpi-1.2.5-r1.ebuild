# Copyright 1999-2007 Gentoo Foundation
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
IUSE="pbs fortran nocxx threads romio heterogeneous smp ipv6"
RDEPEND="pbs? ( sys-cluster/torque )
	$(mpi_imp_deplist)"
DEPEND="${RDEPEND}"

pkg_setup() {
	MPI_ESELECT_FILE="eselect.mpi.openmpi"
	mpi_pkg_setup
	if use threads; then
		ewarn
		ewarn "WARNING: use of threads is still disabled by default in"
		ewarn "upstream builds."
		ewarn "You may stop now and set USE=-threads"
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
	unpack "${A}"
	cd "${S}"

	# Fix --as-needed problems with f77 and f90.
	sed -i 's:^libs=:libs=-Wl,--no-as-needed :' \
		ompi/tools/wrappers/mpif{77,90}-wrapper-data.txt.in
}

src_compile() {
	mpi_conf_args="
		--without-xgrid
		--enable-pretty-print-stacktrace
		--enable-orterun-prefix-by-default
		--without-slurm"

	if use threads; then
		mpi_conf_args="${mpi_conf_args}
			--enable-mpi-threads
			--with-progress-threads
			--with-threads=posix"
	fi

	if use fortran; then
		if [[ "${FORTRANC}" = "g77" ]]; then
			mpi_conf_args="${mpi_conf_args} --disable-mpi-f90"
		elif [[ "${FORTRANC}" = "gfortran" ]]; then
			# Because that's just a pain in the butt.
			mpi_conf_args="${mpi_conf_args} --with-wrapper-fflags=-I/usr/include"
		elif [[ "${FORTRANC}" = if* ]]; then
			# Enabled here as gfortran compile times are huge with this enabled.
			mpi_conf_args="${mpi_conf_args} --with-mpi-f90-size=medium"
		fi
	else
		mpi_conf_args="${mpi_conf_args}
			--disable-mpi-f90
			--disable-mpi-f77"
	fi

	mpi_conf_args="
		${mpi_conf_args}
		$(use_enable !nocxx mpi-cxx)
		$(use_enable romio romio-io)
		$(use_enable smp smp-locks)
		$(use_enable heterogeneous)
		$(use_with pbs tm)
		$(use_enable ipv6)"
	mpi_src_compile
		
}

src_install () {
	mpi_src_install
	mpi_dodoc README AUTHORS NEWS VERSION
}

