# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="De novo de Bruijn genome assembler overcoming uneven coverage"
HOMEPAGE="https://cab.spbu.ru/software/spades"
SRC_URI="
	https://github.com/ablab/spades/releases/download/v${PV}/${P}.tar.gz
	https://cab.spbu.ru/files/release${PV}/manual.html -> ${P}_manual.html
	https://cab.spbu.ru/files/release${PV}/rnaspades_manual.html -> ${P}_rnaspades_manual.html
	https://cab.spbu.ru/files/release${PV}/truspades_manual.html -> ${P}_truspades_manual.html"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND="
	sys-libs/zlib
	app-arch/bzip2
	dev-python/regex"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/cmake"
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

src_compile(){
	PREFIX="${ED}"/usr ./spades_compile.sh || die
}

src_install(){
	# BUG: move *.py files to standard site-packages/ subdirectories
	insinto /usr/share/"${PN}"
	dodoc "${DISTDIR}"/${P}_*manual.html
}
