# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-DAQmx nimsdr kernel module"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-daqmx-nimsdr-dkms-20.1.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
app-shells/bash
>=sci-ni/ni_daqmx_nidmxf_dkms-20.1.0
>=sci-ni/ni_daqmx_notices-20.1.0
>=sci-ni/ni_kal-20.0.0
>=sci-ni/ni_mdbg_dkms-20.0.0
>=sci-ni/ni_mxdf_dkms-20.0.0
>=sci-ni/ni_orb_dkms-20.0.0
>=sci-ni/ni_pal_dkms-20.0.0
sys-kernel/dkms
"
