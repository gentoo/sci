# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/probe/probe-2.11.050121.ebuild,v 1.2 2006/07/09 07:10:24 dberkholz Exp $

EAPI="2"

inherit toolchain-funcs eutils

MY_P="${PN}.${PV}"

DESCRIPTION="Prepares molecular kinemages (input files for Mage & KiNG) from PDB-format coordinate files"
HOMEPAGE="http://kinemage.biochem.duke.edu/software/prekin.php"
SRC_URI="http://kinemage.biochem.duke.edu/downloads/software/prekin/${MY_P}.src.tgz"

LICENSE="richardson"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="X"

RDEPEND="x11-libs/openmotif"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	sed  \
		-e 's:cc:$(CC):g' \
		"${S}"/Makefile.linux > Makefile
}

src_compile() {
	local mytarget

	if use X; then
		mytarget="${PN}"
	else
		mytarget="nogui"
	fi

	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		${mytarget} || die "make failed"
}

src_install() {
	dobin ${S}/prekin || die "dobin failed"
}
