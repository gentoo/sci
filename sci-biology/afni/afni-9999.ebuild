# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib pax-utils git-r3 toolchain-funcs

DESCRIPTION="An open-source environment for processing and displaying functional MRI data"
HOMEPAGE="http://afni.nimh.nih.gov/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/afniHQ/AFNI"


LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/motif[-static-libs]"

# x11-libs/motif[static-libs] breaks the build.
# See upstream discussion
# http://afni.nimh.nih.gov/afni/community/board/read.php?1,85348,85348#msg-85348

DEPEND="${RDEPEND}
	app-shells/tcsh
	sci-libs/gsl
	dev-libs/expat
	x11-libs/libXpm
	media-libs/netpbm
	media-video/mpeg-tools
	x11-libs/libGLw"

S=${WORKDIR}/${P}/src
BUILD="linux_fedora_19_64"

src_prepare() {
	cp other_builds/Makefile.${BUILD} Makefile || die "Could not copy Makefile"
	sed -e "s~CC     = /usr/bin/gcc -O2 -m64~CC     = $(tc-getCC) \$(CFLAGS)~" \
		-e "s~CCMIN  = /usr/bin/gcc -m64~CCMIN  = $(tc-getCC) \$(CFLAGS)~" \
		-e "s~LD     = /usr/bin/gcc~LD     = $(tc-getCC)~" \
		-e "s~AR     = /usr/bin/ar~AR     = $(tc-getAR)~" \
		-e "s~RANLIB = /usr/bin/ranlib~RANLIB = $(tc-getRANLIB)~" \
		-i Makefile || die "Could not edit Makefile"
		# they provide somewhat problematic makefiles :(
	sed -e "s~ifeq ($(CC),gcc)~ifeq (1,1)~"\
		-i SUMA/SUMA_Makefile || die "Could not edit SUMA/SUMA_Makefile"
		# upstream checks if $CC is EXACTLY gcc, else sets variables for Mac
}

src_compile() {
	emake INSTALLDIR="${D}/opt/${PN}" -j1 all plugins suma_exec
}

src_install() {
	emake INSTALLDIR="${D}/opt/${PN}" -j1 install install_plugins
	emake LIBDIR="${D}/opt/${PN}" -j1 install_lib
#	insinto /opt/${PN}
#	doins -r "${S}/${BUILD}"/*

#	exeinto /opt/${PN}
#	PROG_LIST=$(grep -v '^$\|^\s*\#' "${S}"/prog_list.txt | while read LINE; do echo "${S}/${BUILD}/${LINE}"; done)

#	echo ${PROG_LIST}
#	nonfatal doexe "${PROG_LIST[@]}"

	echo "LDPATH=/opt/afni" >> "${T}"/98${PN} || die "Cannot write environment variable."
	echo "PATH=/opt/afni" >> "${T}"/98${PN} || die "Cannot write environment variable."
	doenvd "${T}"/98${PN}

#	dobin "${S}/${BUILD}/${PN}"
#	pax-mark m "${D}/usr/bin/${PN}"
}
