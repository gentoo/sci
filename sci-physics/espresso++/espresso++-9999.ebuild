# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/espresso/espresso-3.1.0.ebuild,v 1.5 2012/05/06 23:08:00 ottxor Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit cmake-utils multilib python-single-r1

DESCRIPTION="extensible, flexible, fast and parallel simulation software for soft matter research"
HOMEPAGE="https://www.espresso-pp.de"

if [[ ${PV} = 9999 ]]; then
	EHG_REPO_URI="https://hg.berlios.de/repos/espressopp"
	EHG_REVISION="default"
	inherit mercurial
	KEYWORDS=
else
	SRC_URI="https://espressopp.mpip-mainz.mpg.de/Download/${PN//+/p}-${PV}.tgz"
	S="${WORKDIR}/${PN//+/p}-${PV}"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
	PATCHES=( "${FILESDIR}/${P}-multilib.patch" )
fi

CMAKE_REMOVE_MODULES_LIST="FindBoost"

EHP_OPTS="--config hostfingerprints.hg.berlios.de=f4:79:d2:17:f8:0c:9b:c2:6e:65:60:2a:49:0e:09:79:85:6d:4b:e3"
EHG_CLONE_CMD="hg clone ${EHG_QUIET_CMD_OPT} ${EHP_OPTS} --pull --noupdate"
EHG_PULL_CMD="hg pull ${EHG_QUIET_CMD_OPT} ${EHP_OPTS}"
LICENSE="GPL-3 !system-boost? ( Boost-1.0 )"
SLOT="0"
IUSE="-system-boost"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	virtual/mpi
	system-boost? ( dev-libs/boost[python,mpi,${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

src_configure() {
	mycmakeargs=( $(cmake-utils_use system-boost EXTERNAL_BOOST) -DLIB="$(get_libdir)" )
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm "${ED}/usr/bin/ESPRC" || die
	rmdir "${ED}/usr/bin" || die
}
