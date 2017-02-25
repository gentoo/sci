# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Blat-like Fast Accurate Search Tool (short read mapper)"
HOMEPAGE="https://sourceforge.net/projects/bfast"
SRC_URI="https://sourceforge.net/projects/bfast/files/bfast/0.7.0/bfast-0.7.0a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl"

S="${WORKDIR}"/bfast-0.7.0a
