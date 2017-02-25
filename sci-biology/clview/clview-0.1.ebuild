# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="clview is an assembly .ace file viewer from TIGR Gene Indices project tools"
HOMEPAGE="http://sourceforge.net/projects/clview"
SRC_URI="
	http://sourceforge.net/projects/clview/files/source%20code/clview_src.tar.gz
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/clview/clview_src.tar.gz
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/clview/clview_linux_i386.tar.gz"

# the ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/tgi_cpp_library.tar.gz
# contain maybe an older but definitely larger set of .cpp files compared to clview/gcl/
# contents. clview compiles against both versions with same warning messages from g++.
#
# mokrejs@vrapenec$ ls -la /var/tmp/portage/sci-biology/clview-0.1/work/gclib/
# total 188
# drwxr-xr-x 2 mmokrejs mmokrejs  4096 Dec  2 22:23 .
# drwx------ 5 mmokrejs portage   4096 Dec  2 22:23 ..
# -rw-r--r-- 1 mmokrejs mmokrejs 11632 Sep 17  2008 AceParser.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs   906 Sep 14  2008 AceParser.h
# -rw-r--r-- 1 mmokrejs mmokrejs 32276 Dec  2 22:23 AceParser.o
# -rw-r--r-- 1 mmokrejs mmokrejs 11012 Jan 22  2009 GBase.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  9200 Dec 16  2008 GBase.h
# -rw-r--r-- 1 mmokrejs mmokrejs  8844 Dec  2 22:23 GBase.o
# -rw-r--r-- 1 mmokrejs mmokrejs 16813 Jul 29  2008 GHash.hh
# -rw-r--r-- 1 mmokrejs mmokrejs 16516 Sep 10  2008 GList.hh
# -rw-r--r-- 1 mmokrejs mmokrejs 11221 Jan 22  2009 LayoutParser.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  6246 Sep 14  2008 LayoutParser.h
# -rw-r--r-- 1 mmokrejs mmokrejs 32956 Dec  2 22:23 LayoutParser.o
# mokrejs@vrapenec$ ls -la /var/tmp/portage/sci-biology/clview-0.1/work/tgi_cl/gcl/
# total 268
# drwxr-xr-x 2 mmokrejs mmokrejs  4096 Nov 18  2008 .
# drwxr-xr-x 3 mmokrejs mmokrejs  4096 Oct 18  2006 ..
# -rw-r--r-- 1 mmokrejs mmokrejs  9515 Nov  7  2005 AceParser.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs   886 Nov  7  2005 AceParser.h
# -rw-r--r-- 1 mmokrejs mmokrejs 10768 Nov  7  2005 BitHash.hh
# -rw-r--r-- 1 mmokrejs mmokrejs  7250 Nov  7  2005 GArgs.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  2507 Nov  7  2005 GArgs.h
# -rw-r--r-- 1 mmokrejs mmokrejs 10156 Nov 18  2008 GBase.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  8142 Nov 18  2008 GBase.h
# -rw-r--r-- 1 mmokrejs mmokrejs 14742 Nov  7  2005 GCdbYank.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  1831 Nov  7  2005 GCdbYank.h
# -rw-r--r-- 1 mmokrejs mmokrejs 16723 Nov  7  2005 GFastaFile.h
# -rw-r--r-- 1 mmokrejs mmokrejs 16245 Nov  7  2005 GHash.hh
# -rw-r--r-- 1 mmokrejs mmokrejs 15561 Nov  7  2005 GList.hh
# -rw-r--r-- 1 mmokrejs mmokrejs    28 Nov  7  2005 GReadBuf.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  4022 Nov  7  2005 GReadBuf.h
# -rw-r--r-- 1 mmokrejs mmokrejs    48 Nov  7  2005 GShMem.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  4012 Nov  7  2005 GShMem.h
# -rw-r--r-- 1 mmokrejs mmokrejs 32875 Nov  7  2005 GString.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  8453 Nov  7  2005 GString.h
# -rw-r--r-- 1 mmokrejs mmokrejs 11157 Nov  7  2005 LayoutParser.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  6063 Nov  7  2005 LayoutParser.h
# -rw-r--r-- 1 mmokrejs mmokrejs 20253 Nov  7  2005 gcdb.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  6941 Nov  7  2005 gcdb.h
# -rw-r--r-- 1 mmokrejs mmokrejs  8998 Nov  7  2005 gcompress.cpp
# -rw-r--r-- 1 mmokrejs mmokrejs  3670 Nov  7  2005 gcompress.h
#

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="=x11-libs/fox-1.6*"
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack() {
	unpack clview_src.tar.gz
}

src_prepare() {
	# FIXME: we have to run `/usr/bin/fox-config --cflags' to yield
	#        `-I/usr/include/fox-1.6'
	# similarly `fox-config --libs' to yield e.g.
	# `-lFOX-1.6 -lXext -lX11 -lXft -lXrender -lfontconfig -lfreetype -lz -lX11
	# -lXcursor -lXrandr -ldl -lpthread -lrt -ljpeg -lpng -ltiff -lz -lbz2 -lm
	# -lcups -lnsl -lGLU -lGL'
	FOXVERSION=`WANT_FOX="1.6" fox-config --version`
	FOXPREFIX=`WANT_FOX="1.6" fox-config --prefix`
	FOXINCPATH=`WANT_FOX="1.6" fox-config --cflags`
	FOXLIBS=`WANT_FOX="1.6" fox-config --libs`
	einfo "Discovered path to fox ${FOXVERSION} files: ${FOXINCPATH}\n${FOXLIBS}"

	sed -i "s#FOXPREFIX = /mylocal/geo#FOXPREFIX = ${FOXPREFIX}#" clview/Makefile || die "Failed to hack FOXPREFIX in clview/Makefile"
	sed -i "s#FOXINCDIR := .*#FOXINCDIR := ${FOXINCPATH}#" clview/Makefile || die "Failed to hack FOXINCDIR in clview/Makefile"
	sed -i "s#-I\${FOXINCDIR}#\${FOXINCDIR}#" clview/Makefile || die "Failed to revert the extra -I we introduced on a previous line to clview/Makefile"
	sed -i "s#FOXLIBDIR := .*#FOXLIBDIR := ${FOXPREFIX}/lib#" clview/Makefile || die "Failed to hack FOXLIBDIR in clview/Makefile"
	sed -i "s#LOADLIBS :=.*#LOADLIBS := ${FOXLIBS}#" clview/Makefile || die "Failed to hack LOADLIBS in clview/Makefile"
	sed -i "s#-I-#-I #" clview/Makefile || die

	# see tgi_cl/gcl/
	sed -i "s#TGICLASSDIR := /tucan/geo/src/tgi_cl#TGICLASSDIR := ../gcl#" clview/Makefile || die
}

src_compile(){
	cd "${S}"/clview || die
	default
}

src_install() {
	# install at least the binaries for clview when we cannot compile it
	dobin clview/clview
}
