# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 wxwidgets

DESCRIPTION="View and analyze genome sequences"
HOMEPAGE="http://www.ncbi.nlm.nih.gov/projects/gbench/"
SRC_URI="ftp://ftp.ncbi.nlm.nih.gov/toolbox/gbench/ver-2.3.2/gbench-src-"${PV}".tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
#KEYWORDS="~amd64 ~x86"
IUSE="xml ssl sybase-ct zlib lzo pcre gnutls freetds mysql berkdb python opengl glut icu expat sqlite hdf5 jpeg png tiff gif xpm sybase threads fltk cgi"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-arch/bzip2
	app-text/sablotron
	dev-cpp/muParser
	dev-libs/boost:=
	dev-libs/expat
	dev-libs/icu
	dev-libs/libxslt
	dev-libs/lzo
	dev-libs/xalan-c
	dev-libs/xerces-c
	dev-util/cppunit
	media-libs/freetype
	media-libs/giflib
	media-libs/glew
	media-libs/tiff:0=
	net-libs/gnutls
	sci-libs/hdf5
	sys-fs/fuse
	sys-libs/db:*
	virtual/glut
	virtual/opengl
	x11-libs/fltk
	x11-libs/wxGTK:*
	mysql? ( virtual/mysql )
	pcre? ( dev-libs/libpcre )
	sqlite? ( dev-db/sqlite:3= )
	ssl? ( dev-libs/openssl:0= )
	sybase-ct? ( dev-db/freetds )
	xml? ( dev-libs/libxml2:2= )
	xpm? (
		x11-libs/libXpm
		virtual/jpeg:0=
		media-libs/libpng:0=
		sys-libs/zlib
	)
"
DEPEND="${RDEPEND}"

# ensure in src_compile no --mandir=/usr/share/man is passed to configure, use the ebuild logic from ncbi-tools++
