# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit eutils toolchain-funcs

DESCRIPTION="De novo de Bruijn genome assembler (bacteria to fungi) or uneven coverage"
HOMEPAGE="http://bioinf.spbau.ru/en/spades"
SRC_URI="
	http://spades.bioinf.spbau.ru/release${PV}/SPAdes-${PV}.tar.gz
	http://spades.bioinf.spbau.ru/release${PV}/manual.html -> ${P}_manual.html
	http://spades.bioinf.spbau.ru/release3.9.1/dipspades_manual.html -> ${P}_dipspades_manual.html
	http://spades.bioinf.spbau.ru/release3.9.1/rnaspades_manual.html -> ${P}_rnaspades_manual.html
	http://spades.bioinf.spbau.ru/release3.9.1/truspades_manual.html -> ${P}_truspades_manual.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	sys-libs/zlib
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

#src_compile(){
#	# grr, it actually also installs the files into $DESTDIR but that is purged before pkg_qmerge starts
#	PREFIX="${D}"/usr ./spades_compile.sh || die
#}

src_install(){
	PREFIX="${ED}"/usr ./spades_compile.sh || die
	insinto /usr/share/"${PN}"
	dodoc "${DISTDIR}"/${P}_*manual.html
}
