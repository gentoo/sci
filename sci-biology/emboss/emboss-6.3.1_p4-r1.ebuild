# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/emboss/emboss-6.3.1_p4.ebuild,v 1.2 2011/03/09 16:29:05 jlec Exp $

EBO_PATCH="4"
EBO_ECONF="--includedir=${EPREFIX}/usr/include/emboss"

inherit emboss

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

src_install() {
	emboss_src_install

	sed "s:EPREFIX:${EPREFIX}:g" "${FILESDIR}"/${PN}-README.Gentoo-2 > README.Gentoo && \
	dodoc README.Gentoo

	# Install env file for setting libplplot and acd files path.
	cat <<- EOF > 22emboss
		# ACD files location
		EMBOSS_ACDROOT="${EPREFIX}/usr/share/EMBOSS/acd"
		EMBOSS_DATA="${EPREFIX}/usr/share/EMBOSS/data"
	EOF
	doenvd 22emboss

	# Clashes #330507
	mv "${ED}"/usr/bin/{digest,pepdigest} || die

	# Remove useless dummy files from the image.
	find "${ED}"/usr/share/EMBOSS -name dummyfile -delete || die "Failed to remove dummy files."

	# Move the provided codon files to a different directory. This will avoid
	# user confusion and file collisions on case-insensitive file systems (see
	# bug #115446). This change is documented in "README.Gentoo".
	mv "${ED}"/usr/share/EMBOSS/data/CODONS{,.orig} || \
			die "Failed to move CODON directory."

	# Move the provided restriction enzyme prototypes file to a different name.
	# This avoids file collisions with versions of rebase that install their
	# own enzyme prototypes file (see bug #118832).
	mv "${ED}"/usr/share/EMBOSS/data/embossre.equ{,.orig} || \
			die "Failed to move enzyme equivalence file."
}
