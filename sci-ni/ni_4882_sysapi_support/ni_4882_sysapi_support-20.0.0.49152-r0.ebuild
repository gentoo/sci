# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI-488.2 system API support package"
HOMEPAGE="http://www.ni.com/linux/"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-488.2-sysapi-support-20.0.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
app-shells/bash
>=sci-ni/libni4882-20.0.0.49152
~sci-ni/ni_4882_config-20.0.0.49152
>=sci-ni/ni_4882_errors-20.0.0.49152
>=sci-ni/nicurli-20.0.0
>=sci-ni/ni_pxiplatformservices-20.0.0
>=sci-ni/ni_syscfg_runtime-20.0.0
sys-devel/gcc
"
