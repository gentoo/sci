# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic multilib versionator

MY_PN=${PN}-mesher
MY_PV=$(get_version_component_range 1-2)
DESCRIPTION="Automatic 3d tetrahedral mesh generator"
HOMEPAGE="http://www.hpfem.jku.at/netgen/"
SRC_URI="mirror://sourceforge/project/${MY_PN}/${MY_PN}/${MY_PV}/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="-ffmpeg jpeg -mpi opencascade openmp"

DEPEND="
	dev-lang/tcl:0
	dev-lang/tk:0
	dev-tcltk/tix
	dev-tcltk/togl:1.7
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXmu
	opencascade? ( sci-libs/opencascade:* )
	ffmpeg? ( media-video/ffmpeg )
	jpeg? ( virtual/jpeg:0= )
	mpi? ( virtual/mpi || ( sci-libs/parmetis <sci-libs/metis-5.0 ) opencascade? ( sci-libs/hdf5[mpi] ) ) "
RDEPEND="${DEPEND}"
# Note, MPI has not be tested.

PATCHES=(
	# Adapted from http://sourceforge.net/projects/netgen-mesher/forums/forum/905307/topic/5422824
	"${FILESDIR}"/${PN}-5.x-missing-define.patch
	# Adapted from http://pkgs.fedoraproject.org/cgit/rpms/netgen-mesher.git/tree/netgen-5.3.0_metis.patch
	"${FILESDIR}"/${PN}-5.x-metis-fixes.patch
	"${FILESDIR}"/${PN}-5.x-occ-stl-api-change.patch
	# Adapted from http://pkgs.fedoraproject.org/cgit/rpms/netgen-mesher.git/tree/netgen-5.3.1_build.patch
	"${FILESDIR}"/${PN}-5.x-makefiles-fixes.patch
	# Adapted from http://pkgs.fedoraproject.org/cgit/rpms/netgen-mesher.git/tree/netgen-5.3.0_fixes.patch
	"${FILESDIR}"/${PN}-5.x-fedora-fixes.patch
	"${FILESDIR}"/${PN}-5.x-includes-fixes.patch
	"${FILESDIR}"/${PN}-5.x-parallelmetis4-fix.patch
)

src_prepare() {
	default
	if use mpi; then
		export CC=mpicc
		export CXX=mpic++
		export FC=mpif90
		export F90=mpif90
		export F77=mpif77
	fi
	eautoreconf
}

src_configure() {
	# This is not the most clever way to deal with these flags
	# but --disable-xxx does not seem to work correcly, so...
	local myconf=( --with-togl=/usr/$(get_libdir)/Togl1.7 )

	myconf+=( $(use_enable openmp) )

	if use opencascade; then
		myconf+=( --enable-occ --with-occ=$CASROOT )
		append-ldflags -L$CASROOT/$(get_libdir)
	fi
	if use mpi; then
		ewarn "*************************************************************************"
		ewarn ""
		ewarn "MPI has not been tested, you should probably deactivate the mpi use flag"
		ewarn ""
		ewarn "*************************************************************************"
		myconf+=( --enable-parallel )
		append-cppflags -I/usr/include/metis
		append-ldflags -L/usr/$(get_libdir)/openmpi/
	fi
	use ffmpeg && myconf+=( --enable-ffmpeg )
	use jpeg && myconf+=( --enable-jpeglib )
	append-cppflags -I/usr/include/togl-1.7

	econf \
		${myconf[@]}

	# This would be the more elegant way:
# 	econf \
# 		$(use_enable opencascade occ) \
# 		$(use_with opencascade "occ=$CASROOT") \
# 		$(use_enable mpi parallel) \
# 		$(use_enable ffmpeg) \
# 		$(use_enable jpeg jpeglib)
}

src_install() {
	local NETGENDIR="/usr/share/netgen"

	echo -e "NETGENDIR=${NETGENDIR} \nLDPATH=/usr/$(get_libdir)/Togl1.7" > ./99netgen
	doenvd 99netgen

	default
	mv "${D}"/usr/bin/{*.tcl,*.ocf} "${D}${NETGENDIR}" || die

	# Install icon and .desktop for menu entry
	doicon "${FILESDIR}"/${PN}.png
	domenu "${FILESDIR}"/${PN}.desktop

	prune_libtool_files
}

pkg_postinst() {
	elog "Please make sure to update your environment variables:"
	elog "env-update && source /etc/profile"
	elog "Netgen ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=155424"
}
