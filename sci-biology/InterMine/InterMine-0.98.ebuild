# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

[ "$PV" == "9999" ] && inherit git-r3

DESCRIPTION="Biological data warehouse integrating complex data"
HOMEPAGE="http://github.com/intermine/intermine"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/intermine/intermine"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
