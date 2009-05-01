# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit fortran flag-o-matic

DESCRIPTION="Fragment library for rosetta"
HOMEPAGE="www.rosettacommons.org"
SRC_URI="rosetta3_fragments.tgz"

LICENSE="|| ( rosetta-academic rosetta-commercial )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="fetch"

RDEPEND="sci-biology/ncbi-tools
	sci-biology/blast-db
	sci-biology/psipred"

S="${WORKDIR}"/${PN/-/_}

FORTRAN="g77 gfortran ifc"

pkg_nofetch() {
	einfo "Go to ${HOMEPAGE} and get ${PN}.tgz and rename it to ${A}"
	einfo "which must be placed in ${DISTDIR}"
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-nnmake.patch
	epatch "${FILESDIR}"/${PV}-chemshift.patch
}

src_compile() {
	append-fflags -ffixed-line-length-132

	cd "${S}"/nnmake && \
	emake || die

	cd "${S}"/chemshift && \
	emake || die
}

src_install() {
	find . -type d -name ".svn" -exec rm -rf '{}' \; 2> /dev/null

	newbin nnmake/pNNMAKE.gnu pNNMAKE && \
	newbin chemshift/pCHEMSHIFT.gnu pCHEMSHIFT || \
	die "failed to install the bins"

	dobin nnmake/*.pl || die "no additional perl scripts"

	insinto /usr/share/${PN}
	doins -r *_database || die
	dodoc fragments.README nnmake/{nnmake.README,vall/*.pl} chemshift/chemshift.README || die "no docs"
}
