# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV//./_}"

inherit java-pkg-2

DESCRIPTION="Multiple experiment Viewer for genomic data analysis"
HOMEPAGE="https://sourceforge.net/projects/mev-tm4/"
SRC_URI="https://downloads.sourceforge.net/project/mev-tm4/mev-tm4/MeV%20${PV}/MeV_${MY_PV}_r2727_linux.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}_${MY_PV}"
LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.5:*
	${DEPEND}"
DEPEND="${RDEPEND}
		>=virtual/jdk-1.5:*
		"

src_install() {
	dodoc -r documentation/*
	rm -r documentation
	insinto "/opt/${PN}"
	doins -r *
	dosym ../${PN}/tmev.sh /opt/bin/tmev
}
