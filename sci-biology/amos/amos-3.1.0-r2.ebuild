# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Whole genome assembler, Hawkeye and AMOScmp to compare multiple assemblies"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi qt4"

DEPEND="
	mpi? ( virtual/mpi )
	dev-libs/boost
	qt4? ( dev-qt/qtcore:4[qt3support]
		dev-qt/qt3support:4 )
	sci-biology/blat
	sci-biology/jellyfish:1"
RDEPEND="${DEPEND}
	dev-lang/perl
	dev-perl/DBI
	dev-perl/Statistics-Descriptive
	sci-biology/mummer"

MAKEOPTS+=" -j1"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc-4.7.patch \
		"${FILESDIR}"/${P}-goBambus2.py-indent-and-cleanup.patch
	# $ gap-links
	# ERROR:  Could not open file  LIBGUESTFS_PATH=/usr/share/guestfs/appliance/
	# $
}

#  --with-jellyfish        location of Jellyfish headers

src_install() {
	default
	python_replicate_script "${ED}"/usr/bin/goBambus2
	# bambus needs TIGR::FASTAreader.pm and others
	# configure --libdir sadly copies both *.a files and *.pm into /usr/lib64/AMOS/ and /usr/lib64/TIGR/, work around it
	perl_set_version
	insinto ${VENDOR_LIB}/AMOS
	doins "${D}"/usr/lib64/AMOS/*.pm
	insinto ${VENDOR_LIB}/TIGR
	doins "${D}"/usr/lib64/TIGR/*.pm
	# move also /usr/lib64/AMOS/AMOS.py to /usr/bin
	mv "${D}"/usr/lib64/AMOS/*.py "${D}"/usr/bin || die
	# zap the mis-placed files ('make install' is at fault)
	rm -f "${D}"/usr/lib64/AMOS/*.pm
	rm -rf "${D}"/usr/lib64/TIGR
	echo AMOSCONF="${EPREFIX}"/etc/amos.acf > "${S}"/99amos || die
	mkdir -p "${ED}"/etc || die
	touch "${ED}"/etc/amos.acf || die
	doenvd "${S}/99amos"
}
