# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A restriction enzyme database"
LICENSE="public-domain"
HOMEPAGE="http://rebase.neb.com"
#SRC_URI="mirror://gentoo/${P}.tar.bz2"
SRC_URI="http://dev.gentooexperimental.org/~jlec/science-dist/${P}.tar.bz2"

SLOT="0"
# Minimal build keeps only the indexed files (if applicable) and the
# documentation. The non-indexed database is not installed.
IUSE="emboss minimal"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"

DEPEND="emboss? ( >=sci-biology/emboss-5.0.0 )"
RDEPEND="${DEPEND}"

src_compile() {
	if use emboss; then
		echo; einfo "Indexing Rebase for usage with EMBOSS."
		mkdir REBASE
		EMBOSS_DATA="." rebaseextract -auto -infile withrefm.${PV} \
				-protofile proto.${PV} -equivalences \
				|| die "Indexing Rebase failed."
		echo
	fi
}

src_install() {
	if ! use minimal; then
		insinto /usr/share/${PN}
		doins withrefm.${PV} proto.${PV} gcg.${PV} || die \
				"Failed to install raw database."
	fi
	newdoc REBASE.DOC README || die "Failed to install documentation."
	if use emboss; then
		insinto /usr/share/EMBOSS/data/REBASE
		doins REBASE/embossre.{enz,ref,sup} || die \
				"Failed to install EMBOSS data files."
		insinto /usr/share/EMBOSS/data
		doins REBASE/embossre.equ \
				|| die "Failed to install enzyme prototypes file."
	fi
}
