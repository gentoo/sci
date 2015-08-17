# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Validate, compare and draw summary statistics for GTF files"
HOMEPAGE="http://mblab.wustl.edu/software.html"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
SRC_URI="http://mblab.wustl.edu/software/download/"${PN}"-"${PV}".tar.gz
		http://mblab.wustl.edu/software/download/eval-documentation.pdf"

DEPEND="
	dev-lang/tk
	sci-biology/vcftools
	sci-visualization/gnuplot"

RDEPEND="${DEPEND}"

src_install(){
	dobin *.pl *.py
	dodoc "${DISTDIR}"/eval-documentation.pdf
	dodoc help/*.ps
	insinto /usr/share/${PN}
	doins *.gtf
	perl_set_version
	insinto ${VENDOR_LIB}
	doins *.pm
}

pkg_postinst(){
	ewarn "The version of validate_gtf.pl bundled with eval differs a bit from"
	ewarn "validate_gtf-1.0.pl from http://mblab.wustl.edu/software.html#validategtf"
}
