EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake

MY_PN="EvtGen"
MY_P=${MY_PN}-${PV}

DESCRIPTION="EvtGen is a Monte Carlo event generator that simulates the decays"
HOMEPAGE="https://evtgen.hepforge.org/"
SRC_URI="https://evtgen.hepforge.org/downloads?f=${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}/R$(ver_rs 1-2 '-')"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+hepmc3 pythia photos tauola"

RDEPEND="
	!hepmc3? ( sci-physics/hepmc:2= )
	hepmc3? ( sci-physics/hepmc:3= )
	pythia? ( >=sci-physics/pythia-8.3.0:= )
	photos? ( >=sci-physics/photos-3.64:=[hepmc3?] )
	tauola? ( >=sci-physics/tauola-1.1.8:=[hepmc3?] )
"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DEVTGEN_HEPMC3=$(usex hepmc3 ON OFF)
		-DHEPMC3_ROOT_DIR="${ESYSROOT}/usr"
		-DEVTGEN_PYTHIA=$(usex pythia ON OFF)
		$(usex pythia -DPYTHIA8_ROOT_DIR="${ESYSROOT}/usr")
		-DEVTGEN_PHOTOS=$(usex photos ON OFF)
		-DEVTGEN_TAUOLA=$(usex tauola ON OFF)
	)
	cmake_src_configure
}
