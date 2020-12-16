# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-DAQmx Multifunction DAQ driver stack libraries"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-daqmx-mio-libs-20.1.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
app-shells/bash
>=sci-ni/libnidrumc1-20.0.0
>=sci-ni/libnipxiepmu15-20.0.0
>=sci-ni/ni_apal_errors-19.0.0
>=sci-ni/nicurli-20.0.0
>=sci-ni/ni_daqmx_fsl_libs-20.0.0
>=sci-ni/ni_daqmx_libs-20.1.0
>=sci-ni/ni_daqmx_nicartenum_dkms-20.1.0
>=sci-ni/ni_daqmx_nicdcc_dkms-20.1.0
>=sci-ni/ni_daqmx_nicdr_dkms-20.1.0
>=sci-ni/ni_daqmx_nichenum_dkms-20.1.0
>=sci-ni/ni_daqmx_nicmr_dkms-20.1.0
>=sci-ni/ni_daqmx_nicondr_dkms-20.1.0
>=sci-ni/ni_daqmx_nicsr_dkms-20.1.0
>=sci-ni/ni_daqmx_niesr_dkms-20.1.0
>=sci-ni/ni_daqmx_nifdr_dkms-20.1.0
>=sci-ni/ni_daqmx_nifresnelmbdc_dkms-20.1.0
>=sci-ni/ni_daqmx_nifsl_dkms-20.0.0
>=sci-ni/ni_daqmx_nihorbr_dkms-20.1.0
>=sci-ni/ni_daqmx_niraptr_dkms-20.1.0
>=sci-ni/ni_daqmx_nisdig_dkms-20.1.0
>=sci-ni/ni_daqmx_nissr_dkms-20.1.0
>=sci-ni/ni_daqmx_nistc2_dkms-20.1.0
>=sci-ni/ni_daqmx_nistc3r_dkms-20.1.0
>=sci-ni/ni_daqmx_nistcr_dkms-20.1.0
>=sci-ni/ni_daqmx_nitior_dkms-20.1.0
>=sci-ni/ni_daqmx_niwfr_dkms-20.1.0
>=sci-ni/ni_daqmx_nixsr_dkms-20.1.0
>=sci-ni/ni_daqmx_notices-20.1.0
>=sci-ni/ni_dim-20.0.0
>=sci-ni/ni_mdbg-20.0.0
>=sci-ni/ni_mru-20.0.0
>=sci-ni/ni_mxdf-20.0.0
>=sci-ni/ni_orb-20.0.0
>=sci-ni/ni_pal-20.0.0
>=sci-ni/ni_syncdomain_service-20.1.0
>=sci-ni/nixercesdelayloadi-2.7.10
"
