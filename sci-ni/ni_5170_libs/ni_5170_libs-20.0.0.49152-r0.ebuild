# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI 5170 Device Libraries"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-5170-libs-20.0.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
app-shells/bash
sci-ni/labview_2019_rte
>=sci-ni/ni_5170_dkms-20.0.0
>=sci-ni/ni_bds-19.7.0
>=sci-ni/ni_fpga_interface-20.0.0
>=sci-ni/ni_pxiplatformservices-18.0.0
>=sci-ni/ni_reosc_errors-20.0.0
>=sci-ni/ni_rio-20.0.0
>=sci-ni/ni_rio_sysapi-20.0.0
>=sci-ni/ni_roco-19.5.0
>=sci-ni/ni_syscfg_runtime-19.5.0
sys-devel/gcc
"
