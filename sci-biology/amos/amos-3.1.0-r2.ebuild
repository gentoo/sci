# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DESCRIPTION="A Modular, Open-Source whole genome assembler"
HOMEPAGE="http://amos.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"

DEPEND="
	dev-libs/boost
	qt4? ( dev-qt/qtcore:4 )"
RDEPEND="${DEPEND}
	dev-lang/perl
	dev-perl/DBI
	dev-perl/Statistics-Descriptive
	sci-biology/blat
	sci-biology/mummer"

MAKEOPTS+=" -j1"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc-4.7.patch \
		"${FILESDIR}"/${P}-goBambus2.py-indent-and-cleanup.patch
}

# amos-3.1.0-r2/work/amos-3.1.0/src/Bambus/Untangler/DotLib.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/Bambus/Untangler/AsmLib.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/FASTAreader.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/AmosFoundation.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/Foundation.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/AmosLib.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/FASTArecord.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/ParseFasta.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/xfig.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/FASTAwriter.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/FASTAgrammar.pm
# amos-3.1.0-r2/work/amos-3.1.0/src/PerlModules/FASTAiterator.pm

#  --with-jellyfish        location of Jellyfish headers

src_install() {
	default
	python_replicate_script "${ED}"/usr/bin/goBambus2
	# bambus needs TIGR::FASTAreader.pm and others
	# configure --libdir sadly copies both *.a files and *.pm into /usr/lib64/AMOS/ and /usr/lib64/TIGR/, work around it
	mkdir -p "${D}"/usr/share/"${PN}"/perl/AMOS || die
	mv "${D}"/usr/lib64/AMOS/*.pm "${D}"/usr/share/"${PN}"/perl/AMOS || die
	mkdir -p "${D}"/usr/share/"${PN}"/perl/TIGR || die
	mv "${D}"/usr/lib64/TIGR/*.pm "${D}"/usr/share/"${PN}"/perl/TIGR || die
	echo "PERL5LIB=/usr/share/${PN}/perl" > "${S}/99${PN}"
	doenvd "${S}/99${PN}" || die
	# move also /usr/lib64/AMOS/AMOS.py to /usr/bin
	mv "${D}"/usr/lib64/AMOS/*.py "${D}"/usr/bin || die
}
