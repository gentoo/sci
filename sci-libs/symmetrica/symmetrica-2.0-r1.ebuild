# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="A collection of routine to handle a variety of topics"
HOMEPAGE="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/index.html"
MY_P=SYM${PV//./_}
SRC_URI="http://www.neu.uni-bayreuth.de/de/Uni_Bayreuth/Fakultaeten/1_Mathematik_Physik_und_Informatik/Fachgruppe_Informatik/prof_diskrete_algorithmen/en/research/SYMMETRICA/${MY_P}_tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${P}-banner.patch"
	"${FILESDIR}/${P}-freeing_errors.patch"
	"${FILESDIR}/${P}-function_names.patch"
	"${FILESDIR}/${P}-integersize.patch"
)

src_prepare() {
	epatch ${PATCHES[@]}
	# symmetrica by itself is just a bunch of files and a few headers
	# plus documentation that you can use as you wish in your programs.
	# For sage and ease of use we make it into a library with the following
	# makefile (developped by F. Bissey and T. Abbott (sage on debian).
	cp "${FILESDIR}/makefile" "${S}/makefile" || die
}

src_install() {
	default
	use doc && dodoc *.doc
}
