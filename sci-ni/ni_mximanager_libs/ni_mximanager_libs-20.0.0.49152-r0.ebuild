# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI MXI Manager Libraries"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-mximanager-libs-20.0.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/libnicpcie1-20.0.0
>=sci-ni/libnimximgr1-20.0.0.49152
>=sci-ni/libnimximgr1_errors-19.5.0
>=sci-ni/libnipcibrd1-20.0.0
>=sci-ni/libnipcibrd1_errors-20.0.0
>=sci-ni/ni_apal_errors-19.0.0
>=sci-ni/ni_pxiplatformsoftware_errors-19.0.0
"
