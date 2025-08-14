# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-utils-2

DESCRIPTION="Genome browser and analysis"
HOMEPAGE="https://www.johnsonlab.ucsf.edu/mochi.html"

SRC_URI="https://www.johnsonlab.ucsf.edu/s/MochiView_v${PV//.}.zip"
S="${WORKDIR}/${PN}_v${PV}"

LICENSE="MIT LGPL-3 MPL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND=">=virtual/jre-1.7:*"
BDEPEND="app-arch/unzip"

src_configure() {
	:;
}

src_compile()
{
	:;
}
src_install() {
	java-pkg_dojar INTERNAL_USE/*.jar
}
