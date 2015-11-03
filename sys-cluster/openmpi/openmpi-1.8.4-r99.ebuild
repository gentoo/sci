# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

FORTRAN_NEEDED=fortran

inherit autotools cuda eutils flag-o-matic fortran-2 multilib toolchain-funcs versionator multilib-minimal

MY_P=${P/-mpi}
S=${WORKDIR}/${MY_P}

IUSE_OPENMPI_FABRICS="
	openmpi_fabrics_ofed
	openmpi_fabrics_knem
	openmpi_fabrics_open-mx
	openmpi_fabrics_psm"

IUSE_OPENMPI_RM="
	openmpi_rm_pbs
	openmpi_rm_slurm"

IUSE_OPENMPI_OFED_FEATURES="
	openmpi_ofed_features_control-hdr-padding
	openmpi_ofed_features_connectx-xrc
	openmpi_ofed_features_udcm
	openmpi_ofed_features_rdmacm
	openmpi_ofed_features_dynamic-sl
	openmpi_ofed_features_failover"

DESCRIPTION="A high-performance message passing library (MPI)"
HOMEPAGE="http://www.open-mpi.org"
SRC_URI="http://www.open-mpi.org/software/ompi/v$(get_version_component_range 1-2)/downloads/${MY_P}.tar.bz2"
LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="cma cuda +cxx elibc_FreeBSD fortran heterogeneous ipv6 mpi-threads numa romio threads vt
	${IUSE_OPENMPI_FABRICS} ${IUSE_OPENMPI_RM} ${IUSE_OPENMPI_OFED_FEATURES}"

REQUIRED_USE="openmpi_rm_slurm? ( !openmpi_rm_pbs )
	openmpi_rm_pbs? ( !openmpi_rm_slurm )
	openmpi_fabrics_psm? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_control-hdr-padding? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_connectx-xrc? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_udcm? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_rdmacm? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_dynamic-sl? ( openmpi_fabrics_ofed )
	openmpi_ofed_features_failover? ( openmpi_fabrics_ofed )"

MPI_UNCLASSED_DEP_STR="
	vt? (
		!dev-libs/libotf
		!app-text/lcdf-typetools
	)"

# dev-util/nvidia-cuda-toolkit is always multilib
RDEPEND="
	!sys-cluster/mpich
	!sys-cluster/mpich2
	!sys-cluster/mpiexec
	>=dev-libs/libevent-2.0.21[${MULTILIB_USEDEP}]
	dev-libs/libltdl:0[${MULTILIB_USEDEP}]
	>=sys-apps/hwloc-1.10.0-r2[${MULTILIB_USEDEP},numa?]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.5.19-r1 )
	elibc_FreeBSD? ( dev-libs/libexecinfo )
	openmpi_fabrics_ofed? ( sys-infiniband/ofed:* )
	openmpi_fabrics_knem? ( sys-cluster/knem )
	openmpi_fabrics_open-mx? ( sys-cluster/open-mx )
	openmpi_fabrics_psm? ( sys-infiniband/infinipath-psm:* )
	openmpi_rm_pbs? ( sys-cluster/torque )
	openmpi_rm_slurm? ( sys-cluster/slurm )
	openmpi_ofed_features_rdmacm? ( sys-infiniband/librdmacm:* )
	"
DEPEND="${RDEPEND}"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/mpi.h
)

pkg_setup() {
	fortran-2_pkg_setup

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
	# Necessary for scalibility, see
	# http://www.open-mpi.org/community/lists/users/2008/09/6514.php
	if use threads; then
		echo 'oob_tcp_listen_mode = listen_thread' \
			>> opal/etc/openmpi-mca-params.conf
	fi

	# https://github.com/open-mpi/ompi/issues/163
	epatch "${FILESDIR}"/openmpi-ltdl.patch

	AT_M4DIR=config eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--sysconfdir="${EPREFIX}/etc/${PN}"
		--enable-pretty-print-stacktrace
		--enable-orterun-prefix-by-default
		--with-hwloc="${EPREFIX}/usr"
		--with-libltdl=external
		)

	if use mpi-threads; then
		myconf+=(--enable-mpi-threads
			--enable-opal-multi-threads)
	fi

	if use fortran; then
		myconf+=(--enable-mpi-fortran=all)
	else
		myconf+=(--enable-mpi-fortran=no)
	fi

	! use vt && myconf+=(--enable-contrib-no-build=vt)

	ECONF_SOURCE=${S} econf "${myconf[@]}" \
		$(use_enable cxx mpi-cxx) \
		$(use_with cma) \
		$(use_with cuda cuda "${EPREFIX}"/opt/cuda) \
		$(use_enable romio io-romio) \
		$(use_enable heterogeneous) \
		$(use_enable ipv6) \
		$(multilib_native_use_with openmpi_fabrics_ofed verbs "${EPREFIX}"/usr) \
		$(multilib_native_use_with openmpi_fabrics_knem knem "${EPREFIX}"/usr) \
		$(multilib_native_use_with openmpi_fabrics_open-mx mx "${EPREFIX}"/usr) \
		$(multilib_native_use_with openmpi_fabrics_psm psm "${EPREFIX}"/usr) \
		$(multilib_native_use_enable openmpi_ofed_features_control-hdr-padding openib-control-hdr-padding) \
		$(multilib_native_use_enable openmpi_ofed_features_connectx-xrc openib-connectx-xrc) \
		$(multilib_native_use_enable openmpi_ofed_features_rdmacm openib-rdmacm) \
		$(multilib_native_use_enable openmpi_ofed_features_udcm openib-udcm) \
		$(multilib_native_use_enable openmpi_ofed_features_dynamic-sl openib-dynamic-sl) \
		$(multilib_native_use_enable openmpi_ofed_features_failover btl-openib-failover) \
		$(multilib_native_use_with openmpi_rm_pbs tm) \
		$(multilib_native_use_with openmpi_rm_slurm slurm)
}

multilib_src_install() {
	default

	# Remove la files, no static libs are installed and we have pkg-config
	find "${ED}"/usr/$(get_libdir)/ -type f -name '*.la' -delete

	# fortran header cannot be wrapped (bug #540508), workaround part 1
	if multilib_is_native_abi && use fortran; then
		mkdir "${T}"/fortran || die
		mv "${ED}"/usr/include/mpif* "${T}"/fortran || die
	else
		#some fortran files get installed unconditionally 
		rm "${ED}"/usr/include/mpif* "${ED}"/usr/bin/mpif* || die
	fi
}

multilib_src_install_all() {
	# From USE=vt see #359917
	rm "${ED}"/usr/share/libtool &> /dev/null

	# fortran header cannot be wrapped (bug #540508), workaround part 2
	if use fortran; then
		mv "${T}"/fortran/mpif* "${ED}"/usr/include || die
	fi

	# Avoid collisions with libevent
	rm -rf "${ED}"/usr/include/event2 &> /dev/null

	dodoc README AUTHORS NEWS VERSION
}

multilib_src_test() {
	# Doesn't work with the default src_test as the dry run (-n) fails.
	emake -j1 check
}
