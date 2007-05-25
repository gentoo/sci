# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/numeric/numeric-24.2-r3.ebuild,v 1.1 2007/02/23 23:43:05 bicatali Exp $

NEED_PYTHON=2.3

inherit distutils eutils

MY_P=Numeric-${PV}

DESCRIPTION="Numerical multidimensional array language facility for Python."
HOMEPAGE="http://numeric.scipy.org/"
SRC_URI="mirror://sourceforge/numpy/${MY_P}.tar.gz
	doc? ( http://numpy.scipy.org/numpy.pdf )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	use doc && cp "${DISTDIR}"/numpy.pdf ${S}/

	# fix list problem
	epatch "${FILESDIR}"/${P}-arrayobject.patch
	# fix skips of acosh, asinh
	epatch "${FILESDIR}"/${P}-umath.patch
	# fix eigenvalue hang
	epatch "${FILESDIR}"/${P}-eigen.patch
	# fix a bug in the test
	epatch "${FILESDIR}"/${P}-test.patch
	# fix only for python-2.5
	python_version
	[[ "${PYVER}" == 2.5 ]] && epatch "${FILESDIR}"/${P}-python25.patch
	# fix for dotblas from uncommited cvs
	epatch "${FILESDIR}"/${P}-dotblas.patch
}

src_test() {
	cd build/lib*
	PYTHONPATH=. "${python}" "${S}"/Test/test.py \
		|| die "test failed"
}

src_install() {
	distutils_src_install
	distutils_python_version

	# install various README from packages
	newdoc Packages/MA/README README.MA
	newdoc Packages/RNG/README README.RNG

	# install tutorial and docs
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins -r Test Demo/NumTut || die
		newins "${S}"/numpy.pdf numeric.pdf || die
	fi
}
