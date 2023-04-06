# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=FormCalc
MY_P=${MY_PN}-${PV}

DESCRIPTION="FormCalc can be used for automatic Feynman diagram computation."
HOMEPAGE="https://feynarts.de/formcalc"
SRC_URI="https://feynarts.de/formcalc/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-mathematics/mathematica
	sci-mathematics/form[threads]
	"
DEPEND="${RDEPEND}"
BDEPEND="
	sci-mathematics/mathematica
	sci-mathematics/form
	"

PATCHES=( "${FILESDIR}"/${P}-compile.patch )

src_compile() {
	# remove shipped binaries
	rm bin/Linux-x86-64/* || die
	rm bin/Linux-x86-64-old/* || die

	export DEST=Linux-x86-64
	./compile ${LDFLAGS} || die
}

src_install() {
	MMADIR=/usr/share/Mathematica/Applications
	dosym ${MY_P} ${MMADIR}/${MY_PN}
	dodir ${MMADIR}/${MY_P}
	insinto ${MMADIR}
	doins -r "${S}"
	# Copy executable, etc. permissions
	for f in $(find * ! -type l); do
		fperms --reference="${S}/$f" ${MMADIR}/${MY_P}/$f
	done
	# switch to system form
	dosym `command -v form` ${MMADIR}/${MY_P}/Linux-x86-64/form
	dosym `command -v tform` ${MMADIR}/${MY_P}/Linux-x86-64/tform

	dodoc manual/*.pdf
}
