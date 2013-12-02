# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="An extensible Molecular Modelling System"
HOMEPAGE="http://www.cgl.ucsf.edu/chimera"
SRC_URI="
	amd64? ( chimera-${PV}-linux_x86_64.bin )
	x86? ( chimera-${PV}-linux.bin )"

SLOT="0"
LICENSE="chimera"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="prefix? ( dev-util/patchelf )"
RDEPEND="
	dev-lang/tcl
	dev-lang/tk
	dev-libs/expat
	dev-libs/libotf
	dev-libs/openssl:0
	dev-libs/libpcre
	sys-libs/zlib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/ftgl
	media-libs/libpng:1.2
	media-libs/tiff
	media-libs/tiff:3
	sci-libs/hdf5
	sys-devel/gcc[openmp,fortran]
	virtual/jpeg
	virtual/glu
	virtual/opengl
	www-apps/swish-e
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libSM
	x11-libs/libXt
	|| ( x11-libs/libGLw <media-libs/mesa-8 )"

S="${WORKDIR}"

RESTRICT="fetch strip"

QA_PREBUILT="opt/.*"

pkg_nofetch() {
	elog "Please visit"
	elog "http://www.cgl.ucsf.edu/chimera/download.html"
	elog "and download ${A} into ${DISTDIR}"
}

src_unpack() {
	cp "${DISTDIR}"/${A} ${A}.zip
	unzip ${A}.zip || die
}

src_install() {
	chmod +x ./chimera.bin
	dodir /opt/
	./chimera.bin -d foo || die
	doicon foo/chimeraIcon.png
	mv foo "${ED}/opt/${PN}" || die

	cat >> "${T}"/chimera <<- EOF
	#!${EPREFX}/bin/bash

	export PATH="${EPREFIX}/opt/${PN}/bin:\${PATH}"
	"${EPREFIX}/opt/${PN}/bin/chimera" \$@
	EOF

	exeinto /opt/bin/
	doexe "${T}"/chimera

	make_desktop_entry "${EPREFIX}/opt/bin/chimera" Chimera chimeraIcon

	if use prefix; then
		local i
		for i in "${ED}"/opt/${PN}/bin/{tiffcp,povray,al2co} "${ED}"/opt/${PN}/lib/*.so; do
			patchelf --set-rpath "${EPREFIX}/usr/lib:${EPREFIX}/opt/${PN}/lib" "${i}" || die
		done
	fi
}
