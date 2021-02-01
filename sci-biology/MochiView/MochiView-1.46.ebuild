# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-utils-2

DESCRIPTION="Genome browser and analysis"
HOMEPAGE="http://johnsonlab.ucsf.edu/mochi.html"
SRC_URI="https://www.johnsonlab.ucsf.edu/s/MochiView_v${PV//.}.zip"

LICENSE="MIT LGPL-3 MPL-1.1 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.7:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}_v${PV}"

src_install() {
	java-pkg_dojar INTERNAL_USE/*.jar
}
