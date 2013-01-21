EAPI=4
inherit cmake-utils
inherit versionator

S="${WORKDIR}/${PN}_${PV}"

# MY_PN="hpx"
# MY_PV="${PV}"
# MY_P="${MY_PN}_${MY_PV}"

DESCRIPTION="HPX (High Performance ParalleX) is a general C++ runtime system for parallel and distributed applications of any scale."
HOMEPAGE="http://stellar.cct.lsu.edu/tag/hpx/"
SRC_URI="http://stellar.cct.lsu.edu/files/hpx_${PV}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/boost-1.48"
RDEPEND="${DEPEND}"

src_configure() {
    export CMAKE_BUILD_TYPE=Release
    cmake-utils_src_configure
}
