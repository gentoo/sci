# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="The Locally Weighted Projection Regression Library"
HOMEPAGE="http://www.ipab.inf.ed.ac.uk/slmc/software/lwpr/"
SRC_URI="http://www.ipab.inf.ed.ac.uk/slmc/software/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples octave python"

RDEPEND="octave? ( >=sci-mathematics/octave-3 )
	python? ( dev-python/numpy )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	if use python; then
		epatch "${FILESDIR}"/${P}-setup.py.patch
		use python && distutils_src_prepare
	fi
}

src_configure() {
	econf $(use_with octave octave "$(octave-config -p PREFIX)")
	# threads buggy
	#	$(use_enable threads threads X) \
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		doxygen Doxyfile || die "doxygen failed"
	fi
	if use python; then
		cd  python
		distutils_src_compile
	fi
}

src_test() {
	emake check || die "emake test failed"
	if use python; then
		cd python
		LD_LIBRARY_PATH=../src/.libs \
			PYTHONPATH=$(dir -d build/lib*) \
			"$(PYTHON)" test.py || die "python test failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" \
		mexflags="-DMATLAB -I../include -L./.libs -llwproctave" \
		install || die "emake install failed"
	dodoc README.TXT || die
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/lwpr_doc.pdf
		dohtml html/* || die
	fi
	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins example_c/cross.c example_cpp/cross.cc || die
	fi
	if use octave; then
		insinto /usr/share/octave/packages/${P}
		doins matlab/*.m || die
	fi
	if use python; then
		cd python
		distutils_src_install
	fi
}
