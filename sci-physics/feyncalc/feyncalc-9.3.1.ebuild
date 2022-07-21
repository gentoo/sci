# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_rs 1-3 '_')
MY_PN=FeynCalc

DESCRIPTION="FeynCalc is a Mathematica package for computing Feynman diagrams."
HOMEPAGE="https://feyncalc.github.io/"
SLOT="0"
SRC_URI="https://github.com/FeynCalc/feyncalc/archive/refs/tags/Release-${MY_PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/feyncalc-Release-${MY_PV}"

LICENSE="GPL-3+"
KEYWORDS="~amd64"
IUSE="+FCtraditionalFormOutput"

RDEPEND="
	sci-mathematics/mathematica
	"
DEPEND="${RDEPEND}"

src_configure() {
	mv "${MY_PN}/DocOutput" "${MY_PN}/Documentation" || die
	if use FCtraditionalFormOutput; then
		echo '$FCTraditionalFormOutput=True;' > "${MY_PN}/FCConfig.m" || die
	fi
}

src_install() {
	MMADIR=/usr/share/Mathematica/Applications
	dodir "${MMADIR}/${MY_PN}"
	insinto "${MMADIR}/"
	doins -r "${S}/${MY_PN}"
	# copy permissions
	for f in $(find "${MY_PN}/*" ! -type l); do
		fperms --reference="${S}/$f" "${MMADIR}/$f"
	done
	# documentation are notebook(.nb) files
	dodoc -r ${MY_PN}/Documentation/English/*
	docompress -x /usr/share/doc/${PF}/
}
