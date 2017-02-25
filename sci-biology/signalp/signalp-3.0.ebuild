# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Prediction of signal peptide cleavage sites in amino acid sequences"
HOMEPAGE="http://www.cbs.dtu.dk/services/SignalP/"
SRC_URI="${P}.Linux.tar.Z"

LICENSE="signalp"
SLOT="0"
IUSE="gnuplot"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="gnuplot? (
	sci-visualization/gnuplot
	media-libs/netpbm )"

RESTRICT="fetch strip"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "\"${SRC_URI}\", then place it in ${DISTDIR}"
}

src_prepare() {
	sed -i -e '/SIGNALP=/ s/\/usr//' \
		-e '/TMPDIR=/ s/$SIGNALP//' "${S}/signalp" || die
	sed -i 's/nawk/gawk/' "${S}"/bin/* || die
}

src_install() {
	dobin signalp
	insinto /opt/${P}
	doins -r bin hmm how mod syn* test
	exeinto /opt/${P}/bin
	doexe bin/*
	exeinto /opt/${P}/hmm
	doexe hmm/*
	exeinto /opt/${P}/how
	doexe how/*
	doman signalp.1
	dodoc *readme
}
