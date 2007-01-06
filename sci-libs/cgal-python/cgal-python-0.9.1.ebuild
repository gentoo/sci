# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit python toolchain-funcs

DESCRIPTION="Provide Python bindings for the CGAL library"
HOMEPAGE="http://cgal-python.gforge.inria.fr/"
SRC_URI="http://gforge.inria.fr/frs/download.php/945/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86"
IUSE="examples"

DEPEND="sci-libs/cgal"
RDEPEND="sci-libs/cgal"

src_unpack(){
	python_version
	unpack "${A}"
	cd "${S}"
	# include python header needed by boost
	for i in $(find ./bindings/ -name Makefile); do
		sed "s:-I../..:-I/usr/include/python${PYVER} -I../..:g" -i $i
		sed "s:@g++:$(tc-getCXX) -fno-strict-aliasing:g" -i $i
	done
}

src_compile(){
	CGAL_MAKEFILE=/usr/share/CGAL/makefile emake
}

src_install(){
	CGAL_MAKEFILE=/usr/share/CGAL/makefile emake package
	pylibdir="$(${python} -c 'from distutils.sysconfig import get_python_lib;print get_python_lib()')"
	dodir "${pylibdir}"
	cp -r cgal_package/CGAL "${D}/${pylibdir}" 
	if use example; then
		dodir /usr/share/doc/${P}
		cp -r ./test "${D}/usr/share/doc/${P}"
	fi
}
