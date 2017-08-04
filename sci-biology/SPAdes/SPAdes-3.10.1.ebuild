# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit eutils toolchain-funcs cmake-utils

DESCRIPTION="De novo de Bruijn genome assembler overcoming uneven coverage"
HOMEPAGE="http://cab.spbu.ru/software/spades"
SRC_URI="
	http://spades.bioinf.spbau.ru/release${PV}/SPAdes-${PV}.tar.gz
	http://spades.bioinf.spbau.ru/release${PV}/manual.html -> ${P}_manual.html
	http://spades.bioinf.spbau.ru/release${PV}/dipspades_manual.html -> ${P}_dipspades_manual.html
	http://spades.bioinf.spbau.ru/release${PV}/rnaspades_manual.html -> ${P}_rnaspades_manual.html
	http://spades.bioinf.spbau.ru/release${PV}/truspades_manual.html -> ${P}_truspades_manual.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sys-libs/zlib
	app-arch/bzip2
	dev-python/regex"
RDEPEND="${DEPEND}"
# BUG:
# SPAdes uses bundled while modified copy of dev-libs/boost (only headers are used,
# not *.so or *.a are even used)
#
# BUG: "${S}"/ext/src/ contains plenty of bundled 3rd-party tools. Drop them all and properly DEPEND on their
#      existing packages
# nlopt
# llvm
# python_libs
# bamtools
# ConsensusCore
# ssw
# jemalloc
# htrie
# getopt_pp
# cppformat
# cityhash
# samtools
# bwa

# BUG: "${S}"/ext/tools/ contains even two version of bwa, being installed as bwa-spades binary?
# bwa-0.7.12
# bwa-0.6.2

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
	# https://github.com/Homebrew/homebrew-science/pull/5616
	epatch "${FILESDIR}"/"${P}"-fix-missing-include.patch
	cp -p spades_compile.sh spades_install.sh || die
	sed -e 's/make install/#make install/;s/cd $PREFIX/#cd $PREFIX/' -i spades_compile.sh || die
	default
}

src_compile(){
	mkdir build_spades || die
	cd build_spades || die
	cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${ED}/usr" $* "${S}/src" || die
}

src_install(){
	cd build_spades || die
	emake install PREFIX="${ED}"/usr
	# cmake-utils_src_install # dies with "${S}" does not appear to contain CMakeLists.txt
	# BUG: move *.py files to standard site-packages/ subdirectories
	insinto /usr/share/"${PN}"
	dodoc "${DISTDIR}"/${P}_*manual.html
}
