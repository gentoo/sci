# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
IUSE="mpi"
RDEPEND="
	mpi? ( virtual/mpi )
	sci-libs/gsl
	sci-biology/mafft
	sci-biology/usearch-bin
	dev-haskell/biosff || ( sci-biology/flower )"
	# sci-biology/flower::haskell installs renamed binaries to avoid file collision
	# unfortunately flower executable from the two packages
	# dev-haskell/biosff::science vs. sci-biology/flower::haskell
	# do not offer same cmdline options (upstream did not sync the two packages)

S="${WORKDIR}/AmpliconNoiseV1.27"

src_compile(){
	# FIXME: the Makefile forcibly calls 'mpicc'
	emake
	cd ../DiversityEstimates || die
	emake
}

src_install(){
	default
	dodoc "${WORKDIR}"/TutorialV1.22/Tutorial.ppt "${WORKDIR}"/TutorialV1.22/SmallTwins.* Doc.pdf
	mv bin "${DESTDIR}/${EPREFIX}"/usr/ || die
	insinto /usr/share/"${PN}"/scripts
	doins Scripts/*.pl Scripts/*.sh
}
