# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib

MY_P="ncbi_cxx--Dec_31_2008"

DESCRIPTION="NCBI C++ Toolkit"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/books/bv.fcgi?rid=toolkit"
SRC_URI="ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/2008/Dec_31_2008/${MY_P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
IUSE="X unicode opengl gnutls -minimal"
KEYWORDS="~amd64 ~x86"

# wxGTK: must run eselect wxwindows after installing wxgtk or build will fail. Check and abort here.
# dev-libs/xalan-c
#	X? ( x11-libs/fltk
#		x11-libs/wxGTK )
DEPEND="!minimal? ( dev-libs/libxml2
	dev-libs/libxslt
	dev-db/sqlite:3
	dev-libs/xerces-c
	media-libs/libpng
	media-libs/tiff
	media-libs/jpeg
	x11-libs/libXpm
	dev-libs/lzo:2
	app-text/sablotron
	dev-libs/boost
	unicode? ( dev-libs/icu )
	opengl? ( media-libs/glut
		media-libs/mesa )
	gnutls? ( net-libs/gnutls ) )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	# econf fails
	"${S}"/configure --without-debug --with-bin-release --prefix="${D}"/usr \
		--libdir="${D}"/usr/$(get_libdir) \
		--with-z="/usr" \
		--with-bz2="/usr" \
		--with-pcre="/usr" \
		--with-openssl="/usr" \
		--with-icu="/usr" \
		--with-boost="/usr" \
		--with-fltk="/usr" \
		--with-mesa="/usr" \
		--with-glut="/usr" \
		--with-sablot="/usr" \
		--without-wxwidgets \
		|| die
#		--with-wxwidgets="/usr" \
}

src_compile() {
	emake all_r -C GCC412-Release64/build || die
}

src_install() {
	emake install || die
	# File collisions with sci-biology/ncbi-tools. TODO: check for more
	(cd "${D}/usr"; rm -f bin/asn2asn bin/rpsblast bin/test_regexp lib64/libblast.a)
}
