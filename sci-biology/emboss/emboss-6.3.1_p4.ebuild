# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/emboss/emboss-6.3.1_p4.ebuild,v 1.2 2011/03/09 16:29:05 jlec Exp $

EBO_PATCH="4"
EBOV="${PV/_p${EBO_PATCH}}"

inherit embassy-ng

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

src_install() {
	embassy-ng_src_install

	sed "s:EPREFIX:${EPREFIX}:g" "${FILESDIR}"/${PN}-README.Gentoo-2 > README.Gentoo && \
	dodoc README.Gentoo

	# Install env file for setting libplplot and acd files path.
	cat <<- EOF > 22emboss
		# plplot libs dir
		PLPLOT_LIB="${EPREFIX}/usr/share/EMBOSS/"
		# ACD files location
		EMBOSS_ACDROOT="${EPREFIX}/usr/share/EMBOSS/acd"
	EOF
	doenvd 22emboss

	# Symlink preinstalled docs to "/usr/share/doc".
	dosym /usr/share/EMBOSS/doc/manuals /usr/share/doc/${PF}/manuals
	dosym /usr/share/EMBOSS/doc/programs /usr/share/doc/${PF}/programs
	dosym /usr/share/EMBOSS/doc/tutorials /usr/share/doc/${PF}/tutorials
	dosym /usr/share/EMBOSS/doc/html /usr/share/doc/${PF}/html

	# Clashes #330507
	mv "${ED}"/usr/bin/{digest,pepdigest} || die

	# Remove useless dummy files from the image.
	find emboss/data -name dummyfile -delete || die "Failed to remove dummy files."

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
