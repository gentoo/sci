# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

PLUGINS="autodocktools bhtree cadd cmolkit dejavu geomutils gle mglutil molkit
	networkeditor opengltk pmv pyautodock pybabel pyglf qslimlib scenario2 sff
	support symserv utpackages viewer-framework vision visionlib volume
	webservices"

DESCRIPTION="Software to visualization and analysis of molecular structures"
HOMEPAGE="http://mgltools.scripps.edu/"
SRC_URI="http://mgltools.scripps.edu/downloads/downloads/tars/releases/REL${PV}/${PN}_source_${PV}.tar.gz"

LICENSE="MGLTOOLS MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"/${PN}_source_${PV/_/}

for plug in ${PLUGINS}; do
	PLUG_DEP="${PLUG_DEP} =sci-chemistry/mgltools-${plug}-${PV}*[${PYTHON_USEDEP}]"
done

RDEPEND="${PLUG_DEP}
	${PYTHON_DEPS}
	dev-lang/tk:0
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/simpy[${PYTHON_USEDEP}]
	sci-libs/msms
	dev-python/pillow[tk,${PYTHON_USEDEP}]
	virtual/python-pmw[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_install() {
	ecvs_clean
	insinto /usr/share/${PN}
	doins -r Data
}
