# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A desktop genome browser using GFF inputs"
HOMEPAGE="http://www.sanger.ac.uk/science/tools/zmap"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/zmap/production/zmap-${PV}.tar.gz
	ftp://ftp.sanger.ac.uk/pub/resources/software/zmap/ZMap_User_Manual.pdf"

LICENSE="GPL-2" # website states Apache-2.0, bundled COPYING says GPL-2
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl"

DEPEND="
	sys-libs/readline:=
	dev-libs/glib
	x11-libs/gtk+:=
	curl? ( net-misc/curl )
	dev-db/sqlite:3
	virtual/mysql
	dev-libs/openssl:="
RDEPEND="${DEPEND}
	sci-biology/seqtools"
