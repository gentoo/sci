# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/allpathslg/allpathslg-42337.ebuild,v 1.6 2013/11/13 02:34:46 patrick Exp $

EAPI=4

inherit autotools flag-o-matic

DESCRIPTION="De novo assembly of whole-genome shotgun microreads"
# see also http://www.broadinstitute.org/software/allpaths-lg/blog/?page_id=12
HOMEPAGE="http://www.broadinstitute.org/science/programs/genome-biology/crd"
SRC_URI="ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

# as of release 44849, GCC 4.7.0 (or higher) is required
# seems pre gcc-4.7 users must stay with:
# ftp://ftp.broadinstitute.org/pub/crd/ALLPATHS/Release-LG/latest_source_code/2013/2013-01/allpathslg-44837.tar.gz
DEPEND="
	>=sys-devel/gcc-4.7
	dev-libs/boost
	!sci-biology/allpaths
	sci-biology/vaal"
RDEPEND=""

src_prepare() {
	sed -i 's/-ggdb3//' configure.ac || die
	eautoreconf
}

src_install() {
	einstall || die
	# Provided by sci-biology/vaal
	for i in QueryLookupTable ScaffoldAccuracy MakeLookupTable Fastb ShortQueryLookup; do
		rm "${D}/usr/bin/$i" || die
	done
}
