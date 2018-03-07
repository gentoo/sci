# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs autotools flag-o-matic python-single-r1 qmake-utils

AUTOTOOLS_AUTORECONF=true
inherit autotools-utils git-r3

DESCRIPTION="Whole genome assembler, Hawkeye and AMOScmp to compare multiple assemblies"
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
	qt4? ( dev-qt/qtcore:4[qt3support]
		dev-qt/qt3support:4 )
	sci-biology/blat
	sci-biology/jellyfish"
RDEPEND="${DEPEND}
	dev-perl/DBI
	dev-perl/Statistics-Descriptive
	sci-biology/mummer"

#  --with-jellyfish        location of Jellyfish headers

# $ gap-links
# ERROR:  Could not open file  LIBGUESTFS_PATH=/usr/share/guestfs/appliance/
# $

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-fix-include-paths.patch
	default
	eautoreconf

	# prevent GCC 6 log pollution due
	# to hash_map deprecation in C++11
	append-cxxflags -Wno-cpp
}

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
