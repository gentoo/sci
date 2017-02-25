# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils python-r1 toolchain-funcs

DESCRIPTION="Validate, compare and draw summary statistics for GTF files"
HOMEPAGE="http://mblab.wustl.edu/software.html"
SRC_URI="
	http://mblab.wustl.edu/software/download/${PN}-${PV}.tar.gz
	http://mblab.wustl.edu/software/download/eval-documentation.pdf"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-lang/tk:0=
	sci-biology/vcftools
	sci-visualization/gnuplot"
RDEPEND="${DEPEND}"

src_install(){
	dobin *.pl
	# TODO: prepend shebang lines to *.py files
	# https://bugs.gentoo.org/show_bug.cgi?id=602580
	sed -i -e "1i #!/usr/bin/env python" RangeFinder.py || die
	python_foreach_impl python_doscript *.py
	dodoc \
		"${DISTDIR}"/eval-documentation.pdf \
		help/*.ps
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
