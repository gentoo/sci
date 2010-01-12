# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit versionator eutils toolchain-funcs

MY_P="${PN}$(delete_all_version_separators)"

DESCRIPTION="Protein Secondary Structure Prediction"
HOMEPAGE="http://bioinf.cs.ucl.ac.uk/psipred/"
SRC_URI="http://bioinf.cs.ucl.ac.uk/downloads/${PN}/${MY_P}.tar.gz"

LICENSE="psipred"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sci-biology/blast-db-0.2
	sci-biology/ncbi-tools"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	sed \
		-e "s:EPREFIX:${EPREFIX}:g" \
		"${FILESDIR}"/${PV}-path.patch \
		> "${T}"/${PV}-path.patch
	epatch "${T}"/${PV}-path.patch
}

src_compile() {
	emake -C src CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	emake -C src DESTDIR="${D}" install || die "installation failed"
	dobin runpsipred* || die
	insinto /usr/share/${PN}
	doins -r data || die "failed to install data"
	dodoc README || die "nothing to read"
}

pkg_postinst() {
	einfo "We are not installing the blast db anymore."
	einfo "Please use the update_blastdb.pl in order to"
	einfo "maintain your own local blastdb"
}
