# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit cmake-utils multilib subversion versionator

DESCRIPTION="Parallelized reader for OpenFOAM(R) file format for use with ParaView/VTK"
HOMEPAGE="http://of-interfaces.sourceforge.net"
ESVN_REPO_URI="http://of-interfaces.svn.sourceforge.net/svnroot/of-interfaces/trunk/vtkPOFFReader@${PV}"

LICENSE="paraview GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	>=sci-visualization/paraview-3.8.1"
DEPEND="${RDEPEND}"

pkg_setup() {
	PVP=$(best_version sci-visualization/paraview | cut -d '-' -f 3-)
	MAJOR_PV=$(get_version_component_range 1-2 $PVP)

	PVLIBDIR=/usr/$(get_libdir)/paraview-${MAJOR_PV}
	S=${WORKDIR}/${PN}
}

src_configure() {
	mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX="${PVLIBDIR}"/plugins
		-DParaView_DIR="${PVLIBDIR}")

	cmake-utils_src_configure
}
