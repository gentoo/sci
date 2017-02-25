# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P=RNAplex-${PV}

DESCRIPTION="RNA-RNA interaction search"
HOMEPAGE="http://www.bioinf.uni-leipzig.de/Software/RNAplex/"
SRC_URI="http://www.bioinf.uni-leipzig.de/Software/RNAplex/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_P}
