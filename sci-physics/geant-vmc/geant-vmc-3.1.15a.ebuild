# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit fortran-2 versionator

MPV=$(get_version_component_range 2-)

DESCRIPTION="Virtual Monte Carlo Geant3 implementation"
HOMEPAGE="http://root.cern.ch/root/vmc/VirtualMC.html"
SRC_URI="http://root.cern.ch/download/vmc/geant321+_vmc.${MPV}.tar.gz"

LICENSE="GPL-2"
SLOT="3"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

RDEPEND="
	sci-physics/root:=[pythia6]
	!sci-physics/geant:3"
DEPEND="${RDEPEND}"

S="${WORKDIR}/geant3"

src_install() {
	dolib.so lib/*/*.so
	insinto /usr/include/TGeant3
	doins TGeant3/TGeant3.h
	insinto /usr/include/geant321
	doins geant321/*.inc

	if use examples; then
		insinto /usr/shared/doc/${PF}
		doins -r examples
	fi
}
