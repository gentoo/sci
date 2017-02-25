# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN=miRanda
MY_P=${MY_PN}-${PV}

DESCRIPTION="An algorithm for finding genomic targets for microRNAs"
HOMEPAGE="http://www.microrna.org/"
SRC_URI="http://cbio.mskcc.org/microrna_data/${MY_PN}-aug2010.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog NEWS README THANKS )
