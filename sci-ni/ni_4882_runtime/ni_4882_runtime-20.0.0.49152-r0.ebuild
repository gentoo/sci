# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-488.2 Runtime for Linux (metapackage)"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-488.2-runtime-20.0.0.49152-0+f0.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/libni4882-20.0.0.49152
>=sci-ni/ni_4882_config-20.0.0.49152
>=sci-ni/ni_4882_dkms-20.0.0.49152
>=sci-ni/ni_4882_errors-20.0.0.49152
>=sci-ni/ni_4882_gpibenumsvc-20.0.0.49152
>=sci-ni/ni_4882_sysapi_support-20.0.0.49152
"
