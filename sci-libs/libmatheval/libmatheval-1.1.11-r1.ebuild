# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="library to parse and evaluate symbolic expressions"
HOMEPAGE="https://www.gnu.org/software/libmatheval/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

PATCHES=( "${FILESDIR}"/"${P}"_update_configure.ac.patch  )

src_prepare() {
	# rename configure.in -> configure.ac for Q/A
	mv configure.in configure.ac || die
	# patch configure.ac
	default
	# remove test subdirectory depends on masked guile-1*
	# Bug: https://bugs.gentoo.org/755353
	sed -e 's/SUBDIRS = doc lib tests/SUBDIRS = doc lib/' -i Makefile.am || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}
