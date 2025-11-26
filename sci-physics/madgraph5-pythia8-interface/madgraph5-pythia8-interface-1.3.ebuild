# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Interface to pythia8 for madgraph5"
HOMEPAGE="
	https://github.com/mg5amcnlo/MG5aMC_PY8_interface
"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mg5amcnlo/MG5aMC_PY8_interface"
	EGIT_BRANCH="main"
else
	SRC_URI="http://madgraph.phys.ucl.ac.be//Downloads/MG5aMC_PY8_interface/MG5aMC_PY8_interface_V${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}"
fi

LICENSE="UoI-NCSA"
SLOT="0"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	sci-physics/pythia:8=[static-libs(-),hepmc2(-),-hepmc3(-),examples]
"
BDEPEND="sci-physics/madgraph5"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CXX
	${CXX} \
		${CXXFLAGS} MG5aMC_PY8_interface.cc -o MG5aMC_PY8_interface \
		$(pythia8-config --ldflags) -lHepMC  ${LDFLAGS} || die
	echo "$(pythia8-config --version)" >> PYTHIA8_VERSION_ON_INSTALL || die
	echo "$(best_version sci-physics/madgraph5)" >> MG5AMC_VERSION_ON_INSTALL || die
}

src_install() {
	insinto /opt/${PN}
	exeinto /opt/${PN}
	doexe MG5aMC_PY8_interface
	doins MG5AMC_VERSION_ON_INSTALL
	doins PYTHIA8_VERSION_ON_INSTALL
	doins VERSION
	doins MultiHist.h
	doins SyscalcVeto.h
}
