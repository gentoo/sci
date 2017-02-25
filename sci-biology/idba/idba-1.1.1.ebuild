# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="De novo De Bruijn graph assembler iteratively using multimple k-mers"
HOMEPAGE="http://i.cs.hku.hk/~alse/hkubrg/projects/idba
	https://code.google.com/archive/p/hku-idba"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hku-idba/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="openmp"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	use openmp && ! tc-has-openmp && die "Please switch to an openmp compatible compiler"
}

src_prepare(){
	# Makefile.am also forces '-fopenmp -pthread', do we care?
	#code stolen from velvet-1.2.10.ebuild
	if [[ $(tc-getCC) =~ gcc ]]; then
		local eopenmp=-fopenmp
	elif [[ $(tc-getCC) =~ icc ]]; then
		local eopenmp=-openmp
		sed -e 's/-fopenmp/-openmp/' -i BUILD || die
	else
		elog "Cannot detect compiler type so not setting openmp support"
	fi
	find . -name Makefile.in | while read f; do \
		sed -e "s/-Wall -O3//" -i $f || die
	done || die
	sed -e 's/"-Wall", "-O3", //' -i BUILD || die
	default
}

src_compile(){
	sh build.sh || die
}

src_install(){
	default
	mkdir -p "${ED}"/usr/bin || die
	mv "${D}"/usr/local/bin/* "${ED}"/usr/bin/ || die "Move to EPREFIX-compliant place"
	rm "${ED}"/usr/bin/scan.py "${ED}"/usr/bin/run-unittest.py || die
	rm bin/test bin/*.o bin/Makefile* || die # avoid file collision
	dobin bin/* # https://github.com/loneknightpy/idba/issues/23
	if [ ! -z "${EPREFIX}" ]; then rm -rf "${D}"/usr || die "Failed to zap empty non-EPREFIXED dirs"; fi
}
