# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_2,3_3,3_4} )

inherit eutils toolchain-funcs

DESCRIPTION="De novo assembler for smaller genomes (bacteria to fungi)"
HOMEPAGE="http://bioinf.spbau.ru/en/spades"
SRC_URI="http://spades.bioinf.spbau.ru/release3.5.0/SPAdes-3.5.0.tar.gz
	http://spades.bioinf.spbau.ru/release3.5.0/manual.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-libs/zlib
	app-arch/bzip2
	dev-python/regex
	dev-libs/boost"
RDEPEND="${DEPEND}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if [[ $(tc-getCXX) == *g++ ]] ; then
			if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 || $(gcc-major-version) -lt 4 ]] ; then
				eerror "You need at least sys-devel/gcc-4.7.0"
				die "You need at least sys-devel/gcc-4.7.0"
			fi
		fi
	fi
}

src_prepare(){
	insinto /usr/share/doc/SPAdes
	dodoc "${DISTDIR}"/manual.html
}

src_compile(){
	# grr, it actually also installs the files into $PREFIX
	PREFIX="${D}"/usr ./spades_compile.sh || die
}

# BUG: contents of "${D}" do not propagate during qmerge?
