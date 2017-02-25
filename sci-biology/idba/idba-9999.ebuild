# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="De novo De Bruijn graph assembler iteratively using multimple k-mers"
HOMEPAGE="http://i.cs.hku.hk/~alse/hkubrg/projects/idba_ud"
EGIT_REPO_URI="https://github.com/loneknightpy/idba.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="openmp"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	use openmp && ! tc-has-openmp && die "Please switch to an openmp compatible compiler"
}

src_prepare(){
	if [[ $(tc-getCC) =~ gcc ]]; then
		local eopenmp=-fopenmp
	elif [[ $(tc-getCC) =~ icc ]]; then
		local eopenmp=-openmp
		sed -e 's/-fopenmp/-openmp/' -i BUILD || die
	else
		elog "Cannot detect compiler type so not setting openmp support"
	fi
	find . -name Makefile.in | while read f; do \
		sed -e "s/-Wall -O3 ${eopenmp}//" -i $f || die
	done
	sed -e 's/"-Wall", "-O3", //' -i BUILD || die
	default
}

src_compile(){
	sh build.sh || die
}

src_install(){
	default
	# https://github.com/loneknightpy/idba/issues/23
	mkdir -p "${ED}"/usr/bin || die
	mv "${D}"/usr/local/bin/* "${ED}"/usr/bin/ || die "Move to EPREFIX-compliant place"
	rm "${ED}"/usr/bin/scan.py "${ED}"/usr/bin/run-unittest.py || die
	rm bin/test bin/*.o bin/Makefile* || die # avoid file collision
	dobin bin/* # https://github.com/loneknightpy/idba/issues/23
	if [ ! -z "${EPREFIX}" ]; then rm -rf "${D}"/usr || die "Failed to zap empty non-EPREFIXED dirs"; fi
}
