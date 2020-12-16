# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild was generated with ../update-ebuilds.sh

EAPI=7

inherit rpm-extended

DESCRIPTION="VISA Shared Components on Linux (metapackage)"
HOMEPAGE="http://www.ivifoundation.org"
SRC_URI="https://download.ni.com/ni-linux-desktop/2020.07/rpm/ni/el8/visa-shared-7.0.0-1.noarch.rpm"

LICENSE="all-rights-reserved"
KEYWORDS="~amd64"
SLOT="0"

RESTRICT="bindist mirror"

DEPEND="
app-arch/rpm
>=sci-ni/libivivisa0-7.0.0
>=sci-ni/libivivisa0_devel-7.0.0
"
