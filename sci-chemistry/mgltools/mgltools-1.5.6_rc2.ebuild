# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PLUGINS="autodocktools bhtree cadd cmolkit dejavu geomutils gle mglutil molkit networkeditor opengltk pmv
	pyautodock pybabel pyglf qslimlib scenario2 sff support symserv utpackages viewer-framework
	vision visionlib volume webservices"

DESCRIPTION="Software to visualization and analysis of molecular structures"
HOMEPAGE="http://mgltools.scripps.edu/"
#SRC_URI="http://mgltools.scripps.edu/downloads/tars/releases/REL${PV}/mgltools_source_${PV}.tar.gz"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/mgltools_source_${PV/_/}.tar.gz"

LICENSE="MGLTOOLS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${PN}_source_${PV/_/}

for plug in ${PLUGINS}; do
	PLUG_DEP="${PLUG_DEP} =sci-chemistry/mgltools-${plug}-${PV}*"
done

RDEPEND="${PLUG_DEP}
	dev-lang/tk
	sci-libs/msms
	>=dev-python/pmw-1.3
	dev-python/simpy
	dev-python/imaging[tk]
	dev-python/numpy"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/${PN}
	doins -r Data
}
