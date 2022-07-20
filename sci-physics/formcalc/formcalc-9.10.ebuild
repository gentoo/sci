# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=FormCalc
MY_P=${MY_PN}-${PV}

DESCRIPTION="FormCalc can be used for automatic Feynman diagram computation."
HOMEPAGE="http://feynarts.de/formcalc"
SRC_URI="http://feynarts.de/formcalc/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	sci-mathematics/mathematica
	sci-mathematics/form
	"
DEPEND="${RDEPEND}"
BDEPEND="
	sci-mathematics/mathematica
	sci-mathematics/form
	"
PATCHES=( "${FILESDIR}"/${PN}-compile.patch )

src_compile() {
	# remove shipped binaries
	rm bin/Linux-x86-64/*
	rm bin/Linux-x86-64-kernel2.6/*
	export DEST=Linux-x86-64
	./compile ${LDFLAGS}
}

src_install() {
	MMADIR=/usr/share/Mathematica/Applications
	dosym ${MY_P} $MMADIR/${MY_PN}
	dodir $MMADIR/${MY_P}
	insinto $MMADIR
	doins -r "${S}"
	cd "${S}"
	# Copy executable, etc. permissions
	for f in $(find * ! -type l); do
		fperms --reference="${S}/$f" $MMADIR/${MY_P}/$f
	done
	# switch to system form
	dosym `which form` $MMADIR/${MY_P}/Linux-x86-64/form
	dosym `which form` $MMADIR/${MY_P}/Linux-x86-64/tform

	dodoc manual/*.pdf
}
