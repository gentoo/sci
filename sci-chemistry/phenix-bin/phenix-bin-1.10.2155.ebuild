# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

WX_GTK_VER=2.8

inherit multilib python-single-r1 versionator wxwidgets

MY_PV="$(replace_version_separator 2 -)"
MY_P="phenix-installer-${MY_PV}"

DESCRIPTION="Python-based Hierarchical ENvironment for Integrated Xtallography"
HOMEPAGE="http://phenix-online.org/"
SRC_URI="${MY_P}-intel-linux-2.6-x86_64-centos6.tar.gz"

SLOT="0"
LICENSE="phenix"
KEYWORDS="~amd64 ~amd64-linux"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-arch/bzip2
	dev-db/sqlite:3
	dev-libs/atk
	dev-libs/boost
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/openssl
	media-gfx/nvidia-cg-toolkit
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng:1.2
	sys-libs/db:4.7
	sys-libs/gdbm
	sys-libs/ncurses:5/5[tinfo]
	sys-libs/readline
	virtual/glu
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
	x11-libs/pixman
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86vm
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	sys-libs/zlib
	virtual/jpeg:62"
DEPEND="${PYTHON_DEPS}"

RESTRICT="fetch"

QA_PREBUILT="opt/phenix-${MY_PV}/.*"

S="${WORKDIR}"/${MY_P}-intel-linux-2.6-x86_64-centos6

pkg_nofetch() {
	elog "Please visit"
	elog "http://www.phenix-online.org/phenix_request/index.cgi"
	elog "and request a download password. With that done,"
	elog "visit http://www.phenix-online.org/download/phenix/release"
	elog "and download version \"Kernel 2.6 (64-bit; Fedora 12)\" (${A})"
	elog "into ${DISTDIR}"
}

src_prepare() {
	cat > "${S}/bin/machine_type" <<-EOF
	#!${EPREFIX}/bin/sh
	echo intel-linux-2.6-x86_64
	exit 0
	EOF
}

src_compile() {
	LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)" ./install --prefix="${S}/foo" || die
}

src_install() {
	find "${S}/foo" -type f -name "*.pyc" -delete || die
	sed \
		-e "s:${S}/foo:${EPREFIX}/opt:g" \
		-i \
			foo/phenix-${MY_PV}/build/*_env \
			foo/phenix-${MY_PV}/build/*sh \
			foo/phenix-${MY_PV}/build/bin/* \
			foo/phenix-${MY_PV}/base/etc/{gtk*,pango}/* \
			foo/phenix-${MY_PV}/phenix_env* \
			|| die
	dodir /opt
	mv "${S}/foo/phenix-${MY_PV}" "${ED}/opt/" || die

	cat >> phenix <<- EOF
	#!${EPREFIX}/bin/bash

	source "${EPREFIX}/opt/phenix-${MY_PV}/phenix_env.sh"
	export LD_LIBRARY_PATH="${EPREFIX}/usr/$(get_libdir)"
	exec phenix
	EOF
	dobin phenix

	python_fix_shebang "${ED}"/opt
	python_optimize "${ED}"/opt
}
