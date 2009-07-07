# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib base

MY_PN="${PN%i}"
MY_P="${MY_PN}-${PV}"

UPDATE="04_03_09"
PATCHDATE="090511"

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

DESCRIPTION="Protein X-ray crystallography toolkit, graphical interface"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="${SRC}/${PV}/${MY_P}-core-src.tar.gz
	${SRC}/${PV}/updates/${MY_P}-src-patch-${UPDATE}.tar.gz
	http://dev.gentooexperimental.org/~jlec/science-dist/${PV}-${PATCHDATE}-updates.patch.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="ccp4"
IUSE=""

RESTRICT="mirror"

RDEPEND=">=dev-lang/tk-8.3
	>=dev-tcltk/blt-2.4
	app-shells/tcsh"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${WORKDIR}"/${PV}-${PATCHDATE}-updates.patch
	"${FILESDIR}"/${PV}-rename-truncate.patch
	"${FILESDIR}"/${PV}-rename-rapper.patch
	"${FILESDIR}"/${PV}-rename-superpose.patch
	"${FILESDIR}"/${PV}-fix-baubles.patch
	)

src_prepare() {
	base_src_prepare

	sed -i \
		-e "s:share smartie:share ccp4 smartie:g" \
		"${S}"/ccp4i/imosflm/src/processingwizard.tcl
}

src_configure() {
	:
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
