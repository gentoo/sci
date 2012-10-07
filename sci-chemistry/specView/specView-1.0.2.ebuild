# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit python toolchain-funcs

DESCRIPTION="Fast way to visualise NMR spectrum and peak data"
HOMEPAGE="http://www.ccpn.ac.uk/software/specview"
SRC_URI="http://www2.ccpn.ac.uk/download/ccpnmr/${PN}${PV}.tar.gz"

SLOT="0"
LICENSE="|| ( CCPN LGPL-2.1 )"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/pyopengl
	dev-python/pyside[webkit]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/ccpnmr/ccpnmr3.0/

#TODO:
#install in sane place
#unbundle data model
#unbundle inchi
#parallel build

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed \
		-e "s|/usr|${EPREFIX}/usr|g" \
		-e "s|^\(CC =\).*|\1 $(tc-getCC)|g" \
		-e '/^MALLOC_FLAG/s:^:#:g' \
		-e "/^OPT_FLAG/s:=.*$:= ${CFLAGS}:g" \
		-e "/^LINK_FLAGS/s:$: ${LDFLAGS}:g" \
		-e "/^PYTHON_DIR/s:=.*:= ${EPREFIX}/usr:g" \
		-e "/^PYTHON_LIB/s:=.*:= $(python_get_library -l):g" \
		-e "/^PYTHON_INCLUDE_FLAGS/s:=.*:= -I${EPREFIX}$(python_get_includedir) -I${EPREFIX}$(python_get_sitedir)/numpy/core/include/numpy:g" \
		-e "/^PYTHON_LIB_FLAGS/s:=.*:= -L${EPREFIX}/usr/$(get_libdir):g" \
		-e "/^SHARED_FLAGS/s:=.*:= -shared:g" \
		-e "/^GL_DIR/s:=.*:= ${EPREFIX}/usr/$(get_libdir):g" \
		-e "/^GL_INCLUDE_FLAGS/s:=.*:= -I${EPREFIX}/usr/include:g" \
		-e "/^GL_LIB_FLAGS/s:=.*:= -L${EPREFIX}/usr/$(get_libdir):g" \
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
	-e "s|gentoopython|$(PYTHON -a)|g" \
	-e "s|gentoousr|${EPREFIX}/usr|g" \
	-e "s|//|/|g" \
		"${FILESDIR}"/${PN} > "${ED}"/usr/bin/${PN} || die
	fperms 755 /usr/bin/${PN}

	insinto ${in_path}

	dodir ${in_path}/cNg
	rm -rf cNg || die

	ebegin "Installing main files"
		doins -r *
	eend

	ebegin "Adjusting permissions"

	for _file in $(find "${ED}" -type f -name "*so"); do
		chmod 755 ${_file}
	done
	eend
}

pkg_postinst() {
	python_mod_optimize ${PN}
}

pkg_postrm() {
	python_mod_cleanup ${PN}
}
