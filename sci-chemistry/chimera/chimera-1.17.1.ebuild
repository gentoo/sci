# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop xdg

DESCRIPTION="Next generation molecular visualization program from RBVI"
HOMEPAGE="https://www.cgl.ucsf.edu/chimera/"
SRC_URI="chimera-${PV}-linux_x86_64.bin
	fetch+http://svn.cgl.ucsf.edu/svn/chimera/trunk/icons/chimera/Chimera512.png"

SLOT="0"
LICENSE="chimera"
KEYWORDS="~amd64 ~x86"

RESTRICT="fetch mirror strip"
QA_PREBUILT="*"

DEPEND=""
BDEPEND=""
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
	media-libs/libpng
	media-libs/tiff
	sci-libs/hdf5
	sys-devel/gcc[openmp,fortran]
	media-libs/libjpeg-turbo
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libSM
	x11-libs/libXt
	x11-libs/libGLw
	virtual/libcrypt:=
"

S="${WORKDIR}"

pkg_nofetch() {
	elog "Please visit"
	elog "https://www.cgl.ucsf.edu/chimera/download.html"
	elog "and download chimera-${PV}-linux_x86_64.bin into your DISTDIR"
}

src_unpack() {
	cp "${DISTDIR}"/chimera-${PV}-linux_x86_64.bin chimera-${PV}-linux_x86_64.bin.zip
	unzip chimera-${PV}-linux_x86_64.bin.zip || die
}

src_install() {
	chmod +x ./chimera.bin
	dodir /opt/
	./chimera.bin -d foo || die
	newicon "${DISTDIR}"/Chimera512.png Chimera.png
	make_desktop_entry "${EPREFIX}/opt/bin/chimera" Chimera Chimera
	mv foo "${ED}/opt/${PN}" || die

	cat >> "${T}"/chimera <<- EOF
	#!${EPREFX}/bin/bash

	export PATH="${EPREFIX}/opt/${PN}/bin:\${PATH}"
	"${EPREFIX}/opt/${PN}/bin/chimera" \$@
	EOF

	exeinto /opt/bin/
	doexe "${T}"/chimera

	# point the symlink to the correct location
	rm "${ED}/opt/chimera/include/ft2build.h" || die
	dosym ../../../usr/include/freetype2/ft2build.h opt/chimera/include/ft2build.h

	if use prefix; then
		local i
		for i in "${ED}"/opt/${PN}/bin/{tiffcp,povray,al2co} "${ED}"/opt/${PN}/lib/*.so; do
			patchelf --set-rpath "${EPREFIX}/usr/lib:${EPREFIX}/opt/${PN}/lib" "${i}" || die
		done
	fi
}
