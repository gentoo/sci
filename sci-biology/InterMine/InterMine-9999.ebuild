# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Biological data warehouse integrating complex data"
HOMEPAGE="https://github.com/intermine/intermine"
if [ "$PV" == "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intermine/intermine"
	KEYWORDS="~amd64"
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="LGPL-2.1+"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}"
