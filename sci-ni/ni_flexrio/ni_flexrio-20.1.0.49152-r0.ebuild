# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="NI FlexRIO Support (metapackage)"
HOMEPAGE="http://www.ni.com/linux"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/ni-flexrio-20.1.0.49152-0+f0.x86_64.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/libniflexrioapi-20.1.0
>=sci-ni/ni_flexrio_795x-20.1.0
>=sci-ni/ni_flexrio_796x-20.1.0
>=sci-ni/ni_flexrio_797x-20.1.0
>=sci-ni/ni_flexrio_798x-20.1.0
>=sci-ni/ni_flexrio_docs-20.1.0
>=sci-ni/ni_flexrio_errors-20.1.0
"
