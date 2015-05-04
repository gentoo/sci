# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils git-r3

DESCRIPTION="Genome assembly package live cvs sources"
HOMEPAGE="http://sourceforge.net/projects/amos"
SRC_URI=""
EGIT_REPO_URI="git://amos.git.sourceforge.net/gitroot/amos/amos"

LICENSE="Artistic"
SLOT="0"
KEYWORDS=""
IUSE="mpi qt4"

DEPEND="
	mpi? ( virtual/mpi )
	dev-libs/boost
	qt4? ( dev-qt/qtcore:4 )
	sci-biology/blat
	sci-biology/jellyfish"
RDEPEND="${DEPEND}
	dev-perl/DBI
	dev-perl/Statistics-Descriptive
	sci-biology/mummer"

#  --with-jellyfish        location of Jellyfish headers

src_install() {
	default
	python_replicate_script "${ED}"/usr/bin/goBambus2
	# bambus needs TIGR::FASTAreader.pm and others
	# configure --libdir sadly copies both *.a files and *.pm into /usr/lib64/AMOS/ and /usr/lib64/TIGR/, work around it
	mkdir -p "${D}/usr/share/${PN}/perl/AMOS" || die
	mv "${D}"/usr/lib64/AMOS/*.pm "${D}/usr/share/${PN}/perl/AMOS" || die
	mkdir -p "${D}"/usr/share/"${PN}"/perl/TIGR || die
	mv "${D}"/usr/lib64/TIGR/*.pm "${D}"/usr/share/"${PN}"/perl/TIGR || die
	echo "PERL5LIB=/usr/share/${PN}/perl" > "${S}/99${PN}"
	doenvd "${S}/99${PN}" || die
	# move also /usr/lib64/AMOS/AMOS.py to /usr/bin
	mv "${D}"/usr/lib64/AMOS/*.py "${D}"/usr/bin || die
}
