# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils multilib

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

MY_PN="ccp4"
MY_P="${MY_PN}-${PV}"
PATCHDATE="04_03_09"
DESCRIPTION="Protein X-ray crystallography toolkit, graphical interface"
HOMEPAGE="http://www.ccp4.ac.uk/"
RESTRICT="mirror"
SRC_URI="${SRC}/${PV}/${MY_P}-core-src.tar.gz
	${SRC}/${PV}/updates/${MY_P}-src-patch-${PATCHDATE}.tar.gz"
LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=dev-lang/tk-8.3
	 >=dev-tcltk/blt-2.4
	 app-shells/tcsh"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# conflicts w/ coreutils
	epatch "${FILESDIR}"/${PV}-rename-truncate.patch

	sed -i \
		-e "s:share smartie:share ccp4 smartie:g" \
		"${S}"/etc/configure.def.dist \
		"${S}"/ccp4i/imosflm/src/processingwizard.tcl
}

src_compile() {
	:
}

src_install() {
	# CCP4Interface - GUI
	insinto /usr/$(get_libdir)/ccp4
	doins -r "${S}"/ccp4i || die
	exeinto /usr/$(get_libdir)/ccp4/ccp4i/bin
	doexe "${S}"/ccp4i/bin/* || die

	# dbccp4i
	insinto /usr/share/ccp4
	doins -r "${S}"/share/dbccp4i || die
}
