# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

[ "$PV" == "9999" ] && VCS=git-2

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils ${VCS}

DESCRIPTION="Genome assembly package live cvs sources"
HOMEPAGE="http://sourceforge.net/projects/amos"
SRC_URI=""
EGIT_REPO_URI="git://amos.git.sourceforge.net/gitroot/amos/amos"

LICENSE="Artistic"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/boost
	dev-qt/qtcore:4"
RDEPEND="${DEPEND}
		dev-perl/DBI
		sci-biology/mummer"
