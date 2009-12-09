# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/openmpi/openmpi-1.2.4.ebuild,v 1.2 2007/12/13 22:39:53 jsbronder Exp $

EAPI=2
inherit eutils multilib flag-o-matic toolchain-funcs fortran mpi

MY_P=${P/-mpi}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="http://www.open-mpi.org"
SRC_URI="http://www.open-mpi.org/software/ompi/v1.4/downloads/${MY_P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
RESTRICT="mpi-threads? ( test )"
IUSE="+cxx fortran heterogeneous ipv6 infiniband mpi-threads pbs romio threads vt"
RDEPEND="pbs? ( sys-cluster/torque )
		vt? (
			!dev-libs/libotf
			!app-text/lcdf-typetools
		)
		infiniband? ( sys-infiniband/libibverbs )
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

src_prepare() {
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

src_configure() {
	local c="
		--without-xgrid
		--enable-pretty-print-stacktrace
		--enable-orterun-prefix-by-default
		--without-slurm"

	if use mpi-threads; then
		c="${c}
			--enable-mpi-threads
			--enable-progress-threads"
	fi

	if use fortran; then
		if [[ "${FORTRANC}" = "g77" ]]; then
			c="${c} --disable-mpi-f90"
		elif [[ "${FORTRANC}" = if* ]]; then
			# Enabled here as gfortran compile times are huge with this enabled.
			c="${c} --with-mpi-f90-size=medium"
		fi
	else
		c="${c}
			--disable-mpi-f90
			--disable-mpi-f77"
	fi

	! use vt && c="${c} --enable-contrib-no-build=vt"
	econf $(mpi_econf_args) ${c} \
		$(use_enable cxx mpi-cxx) \
		$(use_enable romio io-romio) \
		$(use_enable heterogeneous) \
		$(use_with pbs tm) \
		$(use_enable ipv6) \
		$(use_with infiniband openib) 
}

src_install () {
	emake DESTDIR="${D}" install || die
	mpi_dodoc README AUTHORS NEWS VERSION
	mpi_imp_add_eselect
}

src_test() {
	# Doesn't work with the default src_test as the dry run (-n) fails.
	cd "${S}"
	emake -j1 check || die "emake check failed"
}

