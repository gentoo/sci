# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit multilib python-single-r1 toolchain-funcs

DESCRIPTION="Fast way to visualise NMR spectrum and peak data"
HOMEPAGE="http://www.ccpn.ac.uk/software/specview"
SRC_URI="http://www2.ccpn.ac.uk/download/ccpnmr/${PN}${PV}.tar.gz"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/pyopengl[${PYTHON_USEDEP}]
	dev-python/pyside[webkit,${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/ccpnmr/ccpnmr3.0/

#TODO:
#install in sane place
#unbundle data model
#unbundle inchi
#parallel build

src_prepare() {
	sed \
		-e "s|/usr|\"${EPREFIX}/usr\"|g" \
		-e "s|^\(CC =\).*|\1 $(tc-getCC)|g" \
		-e '/^MALLOC_FLAG/s:^:#:g' \
		-e "/^OPT_FLAG/s:=.*$:= ${CFLAGS}:g" \
		-e "/^LINK_FLAGS/s:$: ${LDFLAGS}:g" \
		-e "/^PYTHON_DIR/s:=.*:= \"${EPREFIX}/usr\":g" \
		-e "/^PYTHON_LIB/s:=.*:= $(python_get_LIBS):g" \
		-e "/^PYTHON_INCLUDE_FLAGS/s:=.*:= -I\"$(python_get_includedir)\" -I\"$(python_get_sitedir)/numpy/core/include/numpy\":g" \
		-e "/^PYTHON_LIB_FLAGS/s:=.*:= -L\"${EPREFIX}/usr/$(get_libdir)\":g" \
		-e "/^SHARED_FLAGS/s:=.*:= -shared:g" \
		-e "/^GL_DIR/s:=.*:= \"${EPREFIX}/usr/$(get_libdir)\":g" \
		-e "/^GL_INCLUDE_FLAGS/s:=.*:= -I\"${EPREFIX}/usr/include\":g" \
		-e "/^GL_LIB_FLAGS/s:=.*:= -L\"${EPREFIX}/usr/$(get_libdir)\":g" \
		cNg/environment_default.txt > cNg/environment.txt || die
	echo "SHARED_LINK_PARM = ${LDFLAGS}" >> cNg/environment.txt || die

	rm -rf license || die

	sed \
	-e 's:ln -s:cp -f:g' \
	-i $(find python -name linkSharedObjs) || die
}

src_compile() {
	emake -C cNg all
	emake -j1 -C cNg links
}

src_install() {
	local in_path=$(python_get_sitedir)/${PN}
	local _file

	find . -name "*.pyc" -type f -delete
	dodir /usr/bin
	sed \
		-e "s|gentoo_sitedir|${EPREFIX}$(python_get_sitedir)|g" \
		-e "s|gentoolibdir|${EPREFIX}/usr/${libdir}|g" \
		-e "s|gentootk|${EPREFIX}/usr/${libdir}/tk${tkver}|g" \
		-e "s|gentootcl|${EPREFIX}/usr/${libdir}/tclk${tkver}|g" \
		-e "s|gentoopython|${PYTHON}|g" \
		-e "s|gentoousr|\"${EPREFIX}/usr\"|g" \
		-e "s|//|/|g" \
		"${FILESDIR}"/${PN} > "${ED}"/usr/bin/${PN} || die
	fperms 755 /usr/bin/${PN}

	dodir "${in_path#${EPREFIX}}/cNg"
	rm -rf cNg || die

	ebegin "Installing main files"
	python_moduleinto ${PN}
	python_domodule *
	eend
	python_optimize
}
