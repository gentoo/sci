# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Noise removal from pyrosequenced amplicons"
HOMEPAGE="http://code.google.com/p/ampliconnoise/"
SRC_URI="
	http://ampliconnoise.googlecode.com/files/AmpliconNoiseV${PV}.tar.gz
	http://ampliconnoise.googlecode.com/files/TutorialV1.22.tar.gz
	http://ampliconnoise.googlecode.com/files/DiversityEstimates.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}/AmpliconNoiseV1.27"

src_compile(){
	emake
	cd ../DiversityEstimates || die
	emake
}

src_install(){
	default
	dodoc "${WORKDIR}"/TutorialV1.22/Tutorial.ppt "${WORKDIR}"/TutorialV1.22/SmallTwins.*
}
