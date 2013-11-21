# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

<<<<<<< HEAD
inherit autotools eutils flag-o-matic multilib
=======
inherit eutils flag-o-matic multilib
>>>>>>> 1d153dbd7e5d5a6ffb5726973722f2d45510bbbc

DESCRIPTION="A set of tools designed for the efficient estimation of statistical n-gram language models"
HOMEPAGE="https://code.google.com/p/mitlm/"
SRC_URI="https://mitlm.googlecode.com/files/${P}.tar.gz"

LICENSE="MIT"
<<<<<<< HEAD
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	echo "m4_ifdef([AM_PROG_AR], [AM_PROG_AR])" >> configure.ac
	eautoreconf
=======

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	./autogen.sh
	econf || die "configure failed"
>>>>>>> 1d153dbd7e5d5a6ffb5726973722f2d45510bbbc
}
