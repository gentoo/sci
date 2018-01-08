# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Eukaryotic gene predictor"
HOMEPAGE="http://augustus.gobics.de/"
SRC_URI="http://bioinf.uni-greifswald.de/augustus/binaries/${P}.tar.gz"

LICENSE="GPL-3"
# temporary drop in licensing scheme, see http://stubber.math-inf.uni-greifswald.de/bioinf/augustus/binaries/HISTORY.TXT
# http://stubber.math-inf.uni-greifswald.de/bioinf/augustus/binaries/LICENCE.TXT
# LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	sci-libs/gsl
	dev-libs/boost
	sys-libs/zlib"
DEPEND="${RDEPEND}
	sys-devel/flex"
S="${WORKDIR}/${PN}"

src_prepare() {
	# TODO: do we need anything from the 2.5.5 patch?
	# epatch "${FILESDIR}"/${P}-sane-build.patch
	tc-export CC CXX
	sed -e 's/ -O3//g' -i src/Makefile || die
}

src_compile() {
	emake clean && default
}

src_install() {
	dobin bin/*
#	dobin src/{augustus,etraining,consensusFinder,curve2hints,fastBlockSearch,prepareAlign}

	exeinto /usr/libexec/${PN}
	doexe scripts/*.p*
	insinto /usr/libexec/${PN}
	doins scripts/*.conf

	insinto /usr/share/${PN}
	doins -r config

	echo "AUGUSTUS_CONFIG_PATH=\"/usr/share/${PN}/config\"" > "${S}/99${PN}"
	doenvd "${S}/99${PN}"

	dodoc -r README.TXT HISTORY.TXT docs/*.{pdf,txt}

	if use examples; then
		insinto /usr/share/${PN}/
		doins -r docs/tutorial examples
	fi
}
