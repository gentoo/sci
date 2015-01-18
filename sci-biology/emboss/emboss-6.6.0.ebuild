# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools-utils emboss eutils

EBO_PATCH=""
EBOV=${PV}
EBO_EAUTORECONF=yes

DESCRIPTION="The European Molecular Biology Open Software Suite - A sequence analysis package"
SRC_URI="ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-${PV}.tar.gz"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE+=" minimal"

RDEPEND+=" !sys-devel/cons"
PDEPEND+="
	!minimal? (
		sci-biology/aaindex
		sci-biology/cutg
		sci-biology/prints
		sci-biology/prosite
		sci-biology/rebase
		)"

S="${WORKDIR}"/EMBOSS-${EBOV}

EBO_EXTRA_ECONF="--includedir=${EPREFIX}/usr/include/emboss"

DOCS=( ChangeLog AUTHORS NEWS THANKS FAQ )
PATCHES=(
	"${FILESDIR}/${P}_FORTIFY_SOURCES.patch"
	"${FILESDIR}/${P}_underlinking.patch"
)

src_install() {
	# Use autotools-utils_* to remove useless *.la files
	autotools-utils_src_install

	sed -e "s:EPREFIX:${EPREFIX}:g" "${FILESDIR}"/${PN}-README.Gentoo-2 > README.Gentoo && \
	dodoc README.Gentoo

	# Install env file for setting libplplot and acd files path.
	cat <<- EOF > 22emboss
		# ACD files location
		EMBOSS_ACDROOT="${EPREFIX}/usr/share/EMBOSS/acd"
		EMBOSS_DATA="${EPREFIX}/usr/share/EMBOSS/data"
	EOF
	doenvd 22emboss

	# Remove useless dummy files from the image.
	find "${ED}"/usr/share/EMBOSS -name dummyfile -delete || die "Failed to remove dummy files."

	# Move the provided codon files to a different directory. This will avoid
	# user confusion and file collisions on case-insensitive file systems (see
	# bug #115446). This change is documented in "README.Gentoo".
	mv "${ED}"/usr/share/EMBOSS/data/CODONS{,.orig} || \
			die "Failed to move CODON directory."
}
