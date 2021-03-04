# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scientific multi-agent simulation library"
HOMEPAGE="https://sourceforge.net/projects/zarja/"
# latest version is binary only?
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PN}_${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/gsl
	virtual/lapack
	sci-libs/fftw:3.0
	dev-libs/boost
	dev-cpp/tclap"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}_${PV}"

src_install() {
	cp -a "${S}"/* "${ED}" || die
}
