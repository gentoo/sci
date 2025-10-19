# Copyright 2026 Gentoo Authors
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
MY_PF=stdhep-mirror-v${PV}

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/APN-Pucky/stdhep-mirror"
	EGIT_BRANCH="master"
else
	SRC_URI="https://gitlab.com/APN-Pucky/stdhep-mirror/-/archive/v${PV}/stdhep-mirror-v${PV}.tar.bz2 -> ${P}.tar.bz2"
	S=${WORKDIR}/${MY_PF}
	KEYWORDS="~amd64"
fi

# only lives in MG5_aMC@NLO repo => same license
LICENSE="UoI-NCSA"
SLOT="0"
IUSE="static-libs"

DEPEND="net-libs/libtirpc"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-5.6.1-ldflags.patch
)

src_compile() {
	filter-lto
	filter-flags -Werror=odr
	filter-flags -Werror=lto-type-mismatch
	filter-flags -Werror=strict-aliasing
	tc-export FC CC

	echo "CFLAGS += ${CFLAGS}" >> src/stdhep_arch || die
	echo "FFLAGS += ${FFLAGS}" >> src/stdhep_arch || die
	echo "FCFLAGS += ${FCFLAGS}" >> src/stdhep_arch || die
	echo "LDFLAGS += ${LDFLAGS}" >> src/stdhep_arch || die

	echo "CFLAGS += ${CFLAGS}" >> mcfio/arch_mcfio || die
	echo "FFLAGS += ${FFLAGS}" >> mcfio/arch_mcfio || die
	echo "FCFLAGS += ${FCFLAGS}" >> mcfio/arch_mcfio || die
	echo "LDFLAGS += ${LDFLAGS}" >> mcfio/arch_mcfio || die

	emake all CC="${CC}" FC="${FC}" F77="${FC}"
}

src_install() {
	dolib.so lib/lib{Fmcfio,stdhep,stdhepC}.so

	if use static-libs; then
		dolib.a lib/lib{Fmcfio,stdhep,stdhepC}.a
	fi
}
