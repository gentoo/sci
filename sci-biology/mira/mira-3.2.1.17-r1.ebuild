# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

MIRA_3RDPARTY_PV="17-04-2010"

inherit autotools base multilib

DESCRIPTION="Whole Genome Shotgun and EST Sequence Assembler for Sanger, 454 and Solexa / Illumina"
HOMEPAGE="http://www.chevreux.org/projects_mira.html"
SRC_URI="mirror://sourceforge/mira-assembler/${P}.tar.bz2
	mirror://sourceforge/mira-assembler/mira_3rdparty_${MIRA_3RDPARTY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS=""
# masked because of 'libtool: Version mismatch error.  This is libtool 2.4, but the definition of this LT_INIT comes from libtool 2.2.6b. You should recreate aclocal.m4 with macros from libtool 2.4 and run autoconf again.', dyeing at src/examples_programming/
#KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

CDEPEND=">=dev-libs/boost-1.41.0-r3
		dev-util/google-perftools"
DEPEND="${CDEPEND}
	dev-libs/expat"
RDEPEND="${CDEPEND}
	sci-biology/smalt-bin
	sci-biology/ssaha2-bin"

src_prepare() {
	find -name 'configure*' -or -name 'Makefile*' | xargs sed -i 's/flex++/flex -+/' || die
	epatch "${FILESDIR}"/${PN}-3.0.0-asneeded.patch
	# http://sourceforge.net/apps/trac/mira-assembler/ticket/47
	epatch "${FILESDIR}"/mira_left_clip.readpool.C.patch
	AT_M4DIR="config/m4" eautoreconf
}

src_configure() {
	econf \
		--with-boost="${EPREFIX}"/usr/$(get_libdir) \
		--with-boost-libdir="${EPREFIX}"/usr/$(get_libdir) \
		--with-boost-thread=boost_thread-mt
}

src_compile() {
	base_src_compile
	# TODO: resolve docbook incompatibility for building docs
	if use doc; then emake -C doc clean docs || die "This will probably die because upstream did not imrove re-genartion of the docs yet."; fi
}

src_install() {
	einstall || die
	dodoc AUTHORS GETTING_STARTED NEWS README* HELP_WANTED THANKS INSTALL
	find doc/docs/man -type f | xargs doman
	find doc/docs/texinfo -type f | xargs doinfo
	dobin "${WORKDIR}"/3rdparty/{sff_extract,qual2ball,*.pl}
}
