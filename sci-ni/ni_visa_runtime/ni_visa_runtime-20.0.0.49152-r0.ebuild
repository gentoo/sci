# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-VISA Runtime (metapackage)"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-visa-runtime-20.0.0.49152-0+f0.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/libvisa-20.0.0
>=sci-ni/ni_visa_labview_io_control-20.0.0
>=sci-ni/ni_visa_lxi_discovery-20.0.0
>=sci-ni/ni_visa_passport_enet-20.0.0
>=sci-ni/ni_visa_passport_enet_serial-20.0.0
>=sci-ni/ni_visa_passport_gpib-20.0.0
>=sci-ni/ni_visa_passport_pxi-20.0.0
>=sci-ni/ni_visa_passport_remote-20.0.0
>=sci-ni/ni_visa_passport_serial-20.0.0
>=sci-ni/ni_visa_passport_usb-20.0.0
>=sci-ni/ni_visa_sysapi-20.0.0
"
