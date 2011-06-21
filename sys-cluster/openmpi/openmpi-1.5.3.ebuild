# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/openmpi/openmpi-1.2.4.ebuild,v 1.2 2007/12/13 22:39:53 jsbronder Exp $

EAPI=3
inherit eutils fortran-2 multilib flag-o-matic toolchain-funcs mpi

MY_P=${P/-mpi}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="http://www.open-mpi.org"
SRC_URI="http://www.open-mpi.org/software/ompi/v1.5/downloads/${MY_P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+cxx elibc_FreeBSD fortran heterogeneous ipv6 infiniband mpi-threads pbs romio threads vt"
MPI_UNCLASSED_DEP_STR="
	vt? (
		!dev-libs/libotf
		!app-text/lcdf-typetools
	)"
RDEPEND="pbs? ( sys-cluster/torque )
		infiniband? ( sys-infiniband/libibverbs )
		elibc_FreeBSD? ( dev-libs/libexecinfo )
		>=sys-apps/hwloc-1.1.1
		$(mpi_imp_deplist)"
DEPEND="${RDEPEND}"

pkg_setup() {
	fortran-2_pkg_setup
	MPI_ESELECT_FILE="eselect.mpi.openmpi"

	if use mpi-threads; then
		echo
		ewarn "WARNING: use of MPI_THREAD_MULTIPLE is still disabled by"
		ewarn "default and officially unsupported by upstream."
		ewarn "You may stop now and set USE=-mpi-threads"
		echo
	fi

	echo
	elog "OpenMPI has an overwhelming count of configuration options."
	elog "Don't forget the EXTRA_ECONF environment variable can let you"
	elog "specify configure options if you find them necessary."
	echo
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

	# Gentoo bug 360185
	epatch "${FILESDIR}"/openmpi-r24328.patch
}

src_configure() {
	local myconf=(
		--sysconfdir="${EPREFIX}/etc/${PN}"
		--enable-pretty-print-stacktrace
		--enable-orterun-prefix-by-default
		--without-slurm
		--with-hwloc=/usr
		)

	if use mpi-threads; then
		myconf+=(--enable-mpi-threads
			--enable-progress-threads)
	fi

	if use fortran; then
		if [[ $(tc-getFC) =~ g77 ]]; then
			myconf+=(--disable-mpi-f90)
		elif [[ $(tc-getFC) =~ if ]]; then
			# Enabled here as gfortran compile times are huge with this enabled.
			myconf+=(--with-mpi-f90-size=medium)
		fi
	else
		myconf+=(--disable-mpi-f90 --disable-mpi-f77)
	fi

	! use vt && myconf+=(--enable-contrib-no-build=vt)

	econf $(mpi_econf_args) "${myconf[@]}" \
		$(use_enable cxx mpi-cxx) \
		$(use_enable romio io-romio) \
		$(use_enable heterogeneous) \
		$(use_with pbs tm) \
		$(use_enable ipv6) \
		$(use_with infiniband openib)
}

src_install () {
	emake DESTDIR="${D}" install || die
	# From USE=vt see #359917
	rm "${D}"/$(mpi_root)/usr/share/libtool &> /dev/null
	mpi_dodoc README AUTHORS NEWS VERSION || die
	mpi_imp_add_eselect
}

src_test() {
	# Doesn't work with the default src_test as the dry run (-n) fails.
	cd "${S}"
	emake -j1 check || die "emake check failed"
}
