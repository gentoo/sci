# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI timing and synchronization shared library"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/libnisync1-20.1.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
app-shells/bash
>=sci-ni/nicurli-20.0
>=sci-ni/ni_euladepot-20.1.0
>=sci-ni/ni_pxiplatformservices-20.0
>=sci-ni/ni_roco-20.2
>=sci-ni/ni_sysapi-20.0
>=sci-ni/ni_syscfg_runtime-20.0
"
