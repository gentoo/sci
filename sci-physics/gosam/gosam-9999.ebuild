# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=standalone
DISTUTILS_SINGLE_IMPL=1
inherit fortran-2 distutils-r1

DESCRIPTION="An Automated One-Loop Matrix Element Generator"
HOMEPAGE="
	https://github.com/gudrunhe/gosam
	https://gosam.hepforge.org/
"


if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gudrunhe/gosam"
else
	SRC_URI="https://github.com/gudrunhe/gosam/releases/download/${PV}/gosam-${PV}+c307997.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=sci-mathematics/form-4.0.0
	sci-physics/qgraf
	sci-physics/ninja
	sci-physics/samurai
	sci-physics/golem95
	sci-physics/qcdloop
	sci-physics/oneloop
	sci-physics/ff
"
DEPEND="${RDEPEND}"

src_compile() {
#    emake FFLAGS="-std=legacy ${FFLAGS}"
	:
}

src_install() {
	"${EPYTHON}" setup.py install --single-version-externally-managed --root=/ --prefix="${D}/usr"
}
