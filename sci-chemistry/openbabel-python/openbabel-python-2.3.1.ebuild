# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/openbabel-python/openbabel-python-2.3.0.ebuild,v 1.7 2011/09/14 05:06:41 jlec Exp $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython"
PYTHON_MODNAME="openbabel.py pybel.py"

inherit distutils eutils flag-o-matic

DESCRIPTION="Python bindings for OpenBabel (including Pybel)"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="
	dev-cpp/eigen:2
	dev-libs/libxml2:2
	!sci-chemistry/babel
	~sci-chemistry/openbabel-${PV}
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2"

S="${WORKDIR}"/openbabel-${PV}

DISTUTILS_SETUP_FILES=("scripts|python/setup.py")

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-system_openbabel.patch

	sed \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-i ./scripts/python/setup.py || die

	swig -python -c++ -small -O -templatereduce -naturalvar \
		-I"${EPREFIX}/usr/include/openbabel-2.0" \
		-o scripts/python/openbabel-python.cpp \
		-DHAVE_EIGEN2 \
		-outdir scripts/python \
		scripts/openbabel-python.i \
		|| die "Regeneration of openbabel-python.cpp failed"

	append-cxxflags "$(pkg-config --cflags-only-I eigen2)"
}
