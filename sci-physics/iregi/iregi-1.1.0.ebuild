# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs

DESCRIPTION="Integral REduction with General positive propagator Indices"
HOMEPAGE="
	https://gitlab.com/APN-Pucky/iregi-mirror
	https://arxiv.org/abs/hep-ph/0303184
	https://launchpad.net/mg5amcnlo
	https://github.com/mg5amcnlo/mg5amcnlo
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/APN-Pucky/iregi-mirror"
	EGIT_BRANCH="master"
else
	SRC_URI="https://gitlab.com/APN-Pucky/iregi-mirror/-/archive/v${PV}/iregi-mirror-${PV}.tar.bz2 -> ${P}.tar.bz2"
	S=${WORKDIR}/${MY_PF}
	KEYWORDS="~amd64"
fi

# only lives in MG5_aMC@NLO repo => same license
LICENSE="UoI-NCSA"
SLOT="0"
IUSE="+static-libs"

DEPEND="
	sci-physics/oneloop
	sci-physics/qcdloop
"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export FC
	emake -j1 onelooppath="${EPREFIX}"/usr/include/ FC="${FC}" FFLAGS="${FFLAGS}"
}

src_install() {
	default

	if ! use static-libs; then
		rm -f "${D}"/usr/lib/*.a || die
	fi
}
