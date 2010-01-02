# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PYTHON_USE_WITH="tk"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit eutils flag-o-matic multilib python toolchain-funcs

DESCRIPTION="Graphical NMR assignment and integration program for proteins, nucleic acids, and other polymers"
HOMEPAGE="http://www.cgl.ucsf.edu/home/sparky/"
SRC_URI="http://www.cgl.ucsf.edu/home/sparky/distrib-${PV}/${PN}-source-${PV}.tar.gz"

LICENSE="sparky"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="app-shells/tcsh"
DEPEND="${RDEPEND}"

RESTRICT="mirror"

S="${WORKDIR}/${PN}"

pkg_setup() {
	python_version
	TKVER=$(best_version dev-lang/tk | cut -d- -f3 | cut -d. -f1,2)
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-ldflags.patch
	epatch "${FILESDIR}"/${PV}-wrapper.patch
	epatch "${FILESDIR}"/${PV}-paths.patch

	sed -i \
		-e "s:^\(set PYTHON =\).*:\1 ${EPREFIX}/usr/bin/python${PYVER}:g" \
		-e "s:^\(setenv SPARKY_INSTALL[[:space:]]*\).*:\1 ${EPREFIX}/usr/$(get_libdir)/${PN}:g" \
		-e "s:tcl8.4:tcl${TKVER}:g" \
		-e "s:tk8.4:tk${TKVER}:g" \
		-e "s:^\(setenv TCLTK_LIB[[:space:]]*\).*:\1 ${EPREFIX}/usr/$(get_libdir):g" \
		"${S}"/bin/sparky
}

src_compile() {
	append-flags -fPIC

	emake \
		SPARKY="${S}" \
		PYTHON_VERSION="${PYVER}" \
		PYTHON_PREFIX="${EPREFIX}/usr" \
		PYTHON_LIB="${EPREFIX}$(python_get_libdir)" \
		PYTHON_INC="${EPREFIX}$(python_get_includedir)" \
		TK_PREFIX="${EPREFIX}/usr" \
		TCLTK_VERSION="${TKVER}" \
		TKLIBS="-L${EPREFIX}/usr/$(get_libdir)/ -ltk${TKVER} -ltcl${TKVER} -lX11" \
		CXX="$(tc-getCXX)" \
		CC="$(tc-getCC)" \
		|| die "make failed"
}

src_install() {
	# The symlinks are needed to avoid hacking the complete code to fix the locations

	dobin c++/{{bruk,matrix,peaks,pipe,vnmr}2ucsf,ucsfdata,sparky-no-python} bin/${PN} || die

	insinto /usr/share/${PN}/
	doins lib/{print-prolog.ps,Sparky} || die
	dosym ../../share/${PN}/print-prolog.ps /usr/$(get_libdir)/${PN}/
	dosym ../../share/${PN}/Sparky /usr/$(get_libdir)/${PN}/

	dohtml -r manual/* || die
	dosym ../../share/doc/${PF}/html /usr/$(get_libdir)/${PN}/manual

	insinto $(python_get_sitedir)/${PN}
	doins python/*.py c++/{spy.so,_tkinter.so} || die
	fperms 755 $(python_get_sitedir)/${PN}/{spy.so,_tkinter.so} || die
	dosym ../python${PYVER}/site-packages /usr/$(get_libdir)/${PN}/python

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r example || die
		dosym ../../share/doc/${PF}/example /usr/$(get_libdir)/${PN}/example
	fi

	dodoc README || die
	newdoc python/README README.python || die
}

pkg_postinst() {
	python_mod_optimize sparky
}

pkg_postrm() {
	python_mod_cleanup sparky
}
