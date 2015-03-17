# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit pax-utils git-r3

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

DEPEND="x11-libs/motif[-static-libs]
	app-shells/tcsh
	dev-libs/expat
	x11-libs/libXpm
	media-libs/netpbm
	media-video/mpeg-tools"

S=${WORKDIR}/${P}/src
BUILD="linux_fedora_19_64"

src_prepare() {
	sed -e 's/-V 32//g' -i other_builds/Makefile.${BUILD} || die "Could not edit Makefile"
		# they provide somewhat problematic makefiles :(
	cp other_builds/Makefile.${BUILD} Makefile || die "Could not copy Makefile" 
		# some Makefile under ptaylor looks for the parent makefile at "Makefile".
	pwd
	cat Makefile.INCLUDE >> Makefile || die "Could not include Makefile.INCLUDE"
		# because this builds some additional files
	}

src_compile() {
	emake -j1 totality
	}

src_install() {
	insinto /opt/${PN}
	doins -r "${S}/${BUILD}"/*

	exeinto /opt/${PN}
	PROG_LIST=$(grep -v '^$\|^\s*\#' "${S}"/prog_list.txt | while read LINE; do echo "${S}/${BUILD}/${LINE}"; done)
		
	echo ${PROG_LIST}
	nonfatal doexe "${PROG_LIST[@]}"

	echo "LDPATH=/opt/afni" >> "${T}"/98${PN} || die "Cannot write environment variable."
	echo "PATH=/opt/afni" >> "${T}"/98${PN} || die "Cannot write environment variable."
	doenvd "${T}"/98${PN}

	dobin "${S}/${BUILD}/${PN}"
	pax-mark m "${D}/usr/bin/${PN}"
	}
