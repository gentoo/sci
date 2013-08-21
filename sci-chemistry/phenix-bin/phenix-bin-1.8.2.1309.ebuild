# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit python-single-r1 versionator

MY_PV="$(replace_version_separator 3 -)"
MY_P="phenix-installer-${MY_PV}"

DESCRIPTION="Python-based Hierarchical ENvironment for Integrated Xtallography"
HOMEPAGE="http://phenix-online.org/"
SRC_URI="
	amd64? ( phenix-installer-${MY_PV}-intel-linux-2.6-x86_64-fc12.tar )
	x86? ( phenix-installer-${MY_PV}-intel-linux-2.6-fc3.tar )
"

SLOT="0"
LICENSE="phenix"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
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
	sys-libs/db:4.8
	sys-libs/gdbm
	sys-libs/ncurses[tinfo]
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
	sys-libs/zlib
	virtual/jpeg:62"
DEPEND="${PYTHON_DEPS}"

RESTRICT="fetch"

QA_PREBUILT="opt/phenix-${MY_PV}/.*"

S="${WORKDIR}"/${MY_P}

pkg_nofetch() {
	elog "Please visit"
	elog "http://www.phenix-online.org/phenix_request/index.cgi"
	elog "and request a download password. With that done,"
	elog "visit http://www.phenix-online.org/download/phenix/release"
	elog "and download version \"Kernel 2.6 (64-bit; Fedora 12)\" (${A})"
	elog "into ${DISTDIR}"
}

src_prepare() {
	./install --prefix="${S}/foo"
}

src_install() {
	sed \
		-e "s:${S}/foo:${EPREFIX}/opt:g" \
		-i \
			build-binary/intel-linux-2.6-*/*/log/*.log \
			build-final/intel-linux-2.6-*/*/log/*.log \
			foo/phenix-${MY_PV}/build/intel-linux-2.6-*/*_env \
			foo/phenix-${MY_PV}/build/intel-linux-*/*sh \
			foo/phenix-${MY_PV}/build/intel-linux-*/bin/* \
			foo/phenix-${MY_PV}/build/intel-linux-2.6-*/base/etc/{gtk*,pango}/* \
			foo/phenix-${MY_PV}/phenix_env* \
			|| die
	dodir /opt
	mv "${S}/foo/phenix-${MY_PV}" "${ED}/opt/"

	cat >> phenix <<- EOF
	#!${EPREFIX}/bin/bash

	source "${EPREFIX}/opt/phenix-${MY_PV}/phenix_env.sh"
	exec phenix
	EOF
	dobin phenix

	python_fix_shebang "${ED}"/opt
	python_optimize "${ED}"/opt
}
