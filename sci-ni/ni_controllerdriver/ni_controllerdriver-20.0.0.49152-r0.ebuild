# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI Controller Driver (metapackage)"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-controllerdriver-20.0.0.49152-0+f0.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/libnicntdrv1-20.0.0.49152
>=sci-ni/ni_apal_errors-19.0.0
>=sci-ni/ni_controllerdriver_errors-19.5.0.49152
>=sci-ni/ni_controllerdriver_libs-20.0.0.49152
>=sci-ni/ni_pxihw_nicntdrv_dkms-20.0.0.49152
>=sci-ni/ni_pxiplatformsoftware_errors-19.0.0
>=sci-ni/ni_sysapi-20.0.0
>=sci-ni/ni_syscfg_runtime-20.0.0
"
