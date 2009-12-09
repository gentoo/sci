# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Python bindings for OpenBabel (including Pybel)"
HOMEPAGE="http://openbabel.sourceforge.net/"
SRC_URI="mirror://sourceforge/openbabel/openbabel-${PV}.tar.gz"

KEYWORDS="~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE="swig"

RDEPEND="~sci-chemistry/openbabel-${PV}
	dev-lang/python
	dev-python/imaging
	sci-libs/oasa"

DEPEND="${RDEPEND}
	!~sci-chemistry/openbabel-${PV}[python]
	swig? ( >=dev-lang/swig-1.3.39 )"

S="${WORKDIR}/openbabel-${PV}"

src_compile() {
	econf \
		$(use_enable swig maintainer-mode) \
		--enable-static \
			|| die "econf failed"
	if use swig ; then
		cd "${S}/scripts"
		emake -W openbabel-python.i python/openbabel_python.cpp \
			|| die "Failed to make SWIG python bindings"
	fi
	S="${S}/scripts/python"
	cd "${S}"
	python ./setup.py build || die "python setup build failed"
}

src_install() {
	python ./setup.py install --root="${D}" --optimize=1 \
		|| die "python setup install failed"
	dohtml *.html
	dodoc README
}

