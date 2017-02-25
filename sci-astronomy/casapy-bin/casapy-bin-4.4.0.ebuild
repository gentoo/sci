# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit versionator

DESCRIPTION="Software package to calibrate, image, and analyze radioastronomical data"
HOMEPAGE="http://casa.nrao.edu/"

MY_P=${P/py-bin/-release}-el6
SRC_URI="https://svn.cv.nrao.edu/casa/linux_distro/release/el6/${MY_P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	app-crypt/mit-krb5
	dev-db/sqlite
	dev-libs/glib
	dev-libs/icu
	dev-libs/libxslt
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base
	media-libs/libjpeg-turbo
	media-libs/mesa
	media-libs/tiff
	sci-libs/gsl
	sci-libs/pgplot
	sys-apps/keyutils
	sys-apps/util-linux
	sys-devel/gcc[fortran]
	virtual/libffi
	x11-libs/libdrm
	x11-libs/libSM
	x11-libs/libXau
	x11-libs/libXcursor
	x11-libs/libXdmcp
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
"

S="${WORKDIR}/${MY_P}"
QA_PREBUILT="/opt/casapy/* /opt/casapy/sbin/* /opt/casapy/lib64/*"

src_compile() { :; }

src_install() {
	dodir /opt/
	cp -R "${S}" "${D}/opt/casapy" || die "Could not copy casapy into ${D}/opt"

	dodir /opt/bin
	cd "${D}/opt/casapy/bin"
	for binary in `ls`
	do
		dosym ../casapy/$binary /opt/bin/$binary
	done
}

pkg_postinst() {
	einfo "CASA will use media-gfx/graphviz if this package is installed."
	ewarn "Upstream warns that SElinux must be disabled, set to permissive, or configured to allow execheap."
}
