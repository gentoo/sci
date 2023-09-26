# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

MY_PN="${PN//-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Scientific software package for numerical computations"
HOMEPAGE="https://www.scilab.org/"
SRC_URI="https://www.scilab.org/download/${PV}/${MY_P}.bin.x86_64-linux-gnu.tar.xz"
S="${WORKDIR}/${P//-bin}"

LICENSE="GPL-2 Apache-2.0 sun-bcla-jhall jing MPL-1.0 MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

# Bundled dependencies not packaged in ::gentoo
# sci-libs/hdf5[cxx]:0/9
# libgluegen.so (in ::sci)
# libjogl_desktop.so (in ::sci)
# libOpenXLSX.so (in ::sci)
#
# Bundled dependencies in ::gentoo
# 	dev-lang/tcl
# 	dev-libs/openssl:0/1.1
# 	dev-libs/newt
# 	dev-libs/libpcre
# 	net-misc/curl
# 	sci-libs/amd
# 	sci-libs/arpack
# 	sci-libs/camd
# 	sci-libs/ccolamd
# 	sci-libs/cholmod
# 	sci-libs/colamd
# 	sci-libs/fftw:3.0/3
# 	sci-libs/lapack
# 	sci-libs/matio
# 	sci-libs/openblas
# 	sci-libs/umfpack

RDEPEND="
	sys-libs/ncurses-compat
	virtual/jre:1.8
"

QA_PREBUILT=( "opt/${MY_PN}/*" )

src_prepare() {
	default
	local SCILAB_HOME="/opt/${MY_PN}"
	# fix the .pc file to reflect the dirs where we are installing stuff
	sed -i -e "/^prefix=/c prefix=${SCILAB_HOME}" lib/pkgconfig/scilab.pc || die

	# move appdata to metainfo
	mv share/appdata share/metainfo || die
}

src_install() {
	local SCILAB_HOME="/opt/${MY_PN}"
	dodir "${SCILAB_HOME}"

	# make convenience symlinks in PATH
	for file in bin/*; do
		dosym "../${MY_PN}/${file}" "/opt/${file}"
	done

	# copy all the things
	cp -r "${S}/"*  "${ED}/${SCILAB_HOME}" || die

	# move out dekstop, icons etc
	dodir /usr/share
	mv "${ED}/${SCILAB_HOME}/share/"{metainfo,applications,icons,locale,mime} "${ED}/usr/share/" || die
	dodir /usr/lib64/pkgconfig
	mv "${ED}/${SCILAB_HOME}/lib/pkgconfig/scilab.pc" "${ED}/usr/lib64/pkgconfig/" || die
}
