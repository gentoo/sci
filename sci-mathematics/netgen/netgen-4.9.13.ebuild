# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib versionator

DESCRIPTION="Automatic 3d tetrahedral mesh generator"
HOMEPAGE="http://www.hpfem.jku.at/netgen/"
SRC_URI="mirror://sourceforge/netgen-mesher/${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
IUSE="-ffmpeg jpeg -mpi opencascade"

DEPEND="
	dev-tcltk/tix
	dev-tcltk/togl:1.7
	virtual/opengl
	x11-libs/libXmu
	opencascade? ( sci-libs/opencascade:* )
	ffmpeg? ( media-video/ffmpeg )
	jpeg? ( virtual/jpeg:0= )
	mpi? ( virtual/mpi ) "
RDEPEND="${DEPEND}"
# Note, MPI has not be tested.

src_configure() {
	# This is not the most clever way to deal with these flags
	# but --disable-xxx does not seem to work correcly, so...
	local myconf="--with-togl=/usr/$(get_libdir)/Togl1.7"

	if use opencascade; then
		myconf="${myconf} --enable-occ --with-occ=$CASROOT"
		append-ldflags -L$CASROOT/lin/$(get_libdir)
	fi

	use mpi && myconf="${myconf} --enable-parallel"
	use ffmpeg && myconf="${myconf} --enable-ffmpeg"
	use jpeg && myconf="${myconf} --enable-jpeglib"

	append-flags -I/usr/include/togl-1.7

	econf \
		${myconf}

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
	mv "${D}"/usr/bin/{*.tcl,*.ocf} "${D}${NETGENDIR}"

	# Install icon and .desktop for menu entry
	doicon "${FILESDIR}"/${PN}.png
	domenu "${FILESDIR}"/${PN}.desktop
}

pkg_postinst() {
	elog "Please make sure to update your environment variables:"
	elog "env-update && source /etc/profile"
	elog "Netgen ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=155424"
}
