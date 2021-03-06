# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="De novo De Bruijn graph assembler iteratively using multimple k-mers"
HOMEPAGE="https://i.cs.hku.hk/~alse/hkubrg/projects/idba_ud/"
SRC_URI="https://github.com/loneknightpy/idba/releases/download/${PV}/${P}.tar.gz"

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
	default
}
