# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Validate, compare and draw summary statistics for GTF files"
HOMEPAGE="http://mblab.wustl.edu/software.html"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
SRC_URI="http://mblab.wustl.edu/software/download/"${PN}"-"${PV}".tar.gz
		http://mblab.wustl.edu/software/download/eval-documentation.pdf"

DEPEND="dev-lang/perl
	dev-lang/tk
	sci-biology/vcftools
	sci-visualization/gnuplot"

RDEPEND="${DEPEND}"

src_install(){
	dobin *.pl *.py
	dodoc "${DISTDIR}"/eval-documentation.pdf
	dodoc help/*.ps
	insinto /usr/share/eval
	doins *.gtf
	eval `perl '-V:installvendorlib'`
	vendor_lib_install_dir="${installvendorlib}"
	dodir ${vendor_lib_install_dir}/eval
	insinto ${vendor_lib_install_dir}/eval
	doins *.pm
	echo "PERL5LIB="${vendor_lib_install_dir}"/eval" > ${S}"/99eval"
	doenvd ${S}"/99eval" || die
}

# the version of validate_gtf.pl bundled with eval differs a bit from
# validate_gtf-1.0.pl from http://mblab.wustl.edu/software.html#validategtf
