# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit wxwidgets

DESCRIPTION="View and analyze genome sequences"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/projects/gbench/"
SRC_URI="ftp://ftp.ncbi.nlm.nih.gov/toolbox/gbench/ver-2.3.2/gbench-src-"${PV}".tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
#KEYWORDS="~amd64 ~x86"
IUSE="xml ssl sybase-ct zlib lzo pcre gnutls freetds mysql berkdb python opengl glut icu expat sqlite hdf5 jpeg png tiff gif xpm sybase threads fltk cgi"

DEPEND="sys-fs/fuse
		app-arch/bzip2
		dev-libs/lzo
		pcre? ( dev-libs/libpcre )
		net-libs/gnutls
		ssl? ( dev-libs/openssl )
		sybase-ct? ( dev-db/freetds )
		mysql? ( virtual/mysql )
		sys-libs/db
		dev-lang/python
		dev-libs/boost
		virtual/opengl
		virtual/glut
		media-libs/glew
		x11-libs/wxGTK
		dev-libs/icu
		dev-libs/expat
		app-text/sablotron
		xml? ( dev-libs/libxml2 )
		dev-libs/libxslt
		sqlite? ( dev-db/sqlite:3 )
		sci-libs/hdf5
		media-libs/tiff
		media-libs/giflib
		xpm?  ( x11-libs/libXpm
				virtual/jpeg
				media-libs/libpng sys-libs/zlib )
		media-libs/freetype
		x11-libs/fltk
		dev-libs/xerces-c
		dev-libs/xalan-c
		dev-cpp/muParser
		dev-util/cppunit"

RDEPEND="${DEPEND}"

# ensure in src_compile no --mandir=/usr/share/man is passed to configure, use the ebuild logic from ncbi-tools++
