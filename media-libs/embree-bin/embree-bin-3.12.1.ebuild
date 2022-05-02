# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="high-performance ray tracing kernels from intel"
HOMEPAGE="https://github.com/embree/embree"
SRC_URI="https://github.com/embree/embree/releases/download/v${PV}/embree-${PV}.x86_64.linux.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/embree-${PV}.x86_64.linux
RESTRICT="mirror"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"

QA_PREBUILT="opt/embree/bin/.*"
QA_PRESTRIPPED="opt/embree/lib/libembree3.so.3"

RDEPEND="
	dev-cpp/tbb
	dev-lang/ispc
	media-libs/glfw
	media-libs/glu
	media-libs/libjpeg-turbo:0
	virtual/opengl
	x11-libs/libxcb
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
"

src_compile() {
	true
}

src_install() {
	dodir /opt/embree
	cp -r "${S}"/* "${ED}"/opt/embree/ || die

	doenvd "${FILESDIR}"/00embree_bin
}

pkg_postinst() {
	elog "Embree has been installed to /opt/embree"
	elog "you are all set to start using it as binary package"
	elog "after you refresh your environment with"
	elog "  env-update && . /etc/profile"
	elog "If you want to use embree as a library and wist to"
	elog "do development using embree, you need to source"
	elog "the appropriate shell script from either"
	elog "  . /opt/embree/embree-vars.sh"
	elog "or if you are using csh"
	elog "  . /opt/embree/embree-vars.csh"
}
