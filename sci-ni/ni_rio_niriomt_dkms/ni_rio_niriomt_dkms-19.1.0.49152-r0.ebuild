# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-RIO niriomt kernel module"
HOMEPAGE="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-rio-niriomt-dkms-19.1.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
app-shells/bash
>=sci-ni/ni_kal-19.2.0
>=sci-ni/ni_rio_dkms-19.0.0
sys-kernel/dkms
"
