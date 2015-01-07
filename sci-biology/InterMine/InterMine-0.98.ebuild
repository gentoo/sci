# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

[ "$PV" == "9999" ] && inherit git-2

DESCRIPTION="Biological data warehouse integrating complex data"
HOMEPAGE=""
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/intermine/intermine"
	KEYWORDS=""
else
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="LGPL-v3"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
