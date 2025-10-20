# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fortran-2 toolchain-funcs flag-o-matic

DESCRIPTION="StdHEP: Standard HEP"
HOMEPAGE="
	https://gitlab.com/APN-Pucky/stdhep-mirror
	https://inspirehep.net/literature/538266
	https://launchpad.net/mg5amcnlo
	https://github.com/mg5amcnlo/mg5amcnlo
"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/APN-Pucky/stdhep-mirror"
	EGIT_BRANCH="master"
else
	SRC_URI="https://gitlab.com/APN-Pucky/stdhep-mirror/-/archive/v${PV}/stdhep-mirror-${PV}.tar.bz2 -> ${P}.tar.bz2"
	S=${WORKDIR}/${MY_PF}
	KEYWORDS="~amd64"
fi

# only lives in MG5_aMC@NLO repo => same license
LICENSE="UoI-NCSA"
SLOT="0"
IUSE="+static-libs"

src_configure() {
	default
	filter-lto
}

src_compile() {
	tc-export FC CC
	emake all CC="${CC}" FC="${FC}" F77="${FC}" #FFLAGS="${FFLAGS} -std=legacy -ffixed-line-length-none" CFLAGS="${CFLAGS}"
}

src_install() {
	dolib.so lib/lib{Fmcfio,stdhep,stdhepC}.so

	if use static-libs; then
		dolib.a lib/lib{Fmcfio,stdhep,stdhepC}.a
	fi
}
