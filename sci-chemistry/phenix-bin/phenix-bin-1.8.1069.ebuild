# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit python versionator

MY_PV="$(replace_version_separator 2 -)"
MY_P="phenix-installer-${MY_PV}"

DESCRIPTION="Python-based Hierarchical ENvironment for Integrated Xtallography"
HOMEPAGE="http://phenix-online.org/"
SRC_URI="
	amd64? ( phenix-installer-${MY_PV}-intel-linux-2.6-x86_64-fc15.tar )
	x86? ( phenix-installer-${MY_PV}-intel-linux-2.6-fc3.tar )
"

SLOT="0"
LICENSE="phenix"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	media-libs/jpeg:62"
DEPEND=""

RESTRICT="fetch"

QA_PREBUILT="opt/phenix-${MY_PV}/.*"

S="${WORKDIR}"/${MY_P}

pkg_nofetch() {
	elog "Please visit"
	elog "http://www.phenix-online.org/phenix_request/index.cgi"
	elog "and request a download password. With that done,"
	elog "visit http://www.phenix-online.org/download/phenix/release"
	elog "and downlaod ${A} to ${DISTDIR}"
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	./install --prefix="${S}/foo"

}

src_install() {
#	find -name "*.py[co]" -delete
#	find -name SConstruct -delete
	sed \
		-e "s:${S}/foo:${EPREFIX}/opt:g" \
		-i \
			build-binary/intel-linux-2.6-*/*/log/*.log \
			build-final/intel-linux-2.6-*/*/log/*.log \
			foo/phenix-${MY_PV}/build/intel-linux-2.6-*/*_env \
			foo/phenix-${MY_PV}/build/intel-linux-*/*sh \
			foo/phenix-${MY_PV}/build/intel-linux-*/bin/* \
			foo/phenix-${MY_PV}/build/intel-linux-2.6-*/base/etc/{gtk*,pango}/* \
			foo/phenix-${MY_PV}/phenix_env* \
			|| die
#	grep ${S} * -R
	dodir /opt
	mv "${S}/foo/phenix-${MY_PV}" "${ED}/opt/"

	cat >> phenix <<- EOF
	#!${EPREFIX}/bin/bash

	source "${EPREFIX}/opt/phenix-${MY_PV}/phenix_env.sh"
	exec phenix
	EOF
	dobin phenix
}

pkg_postinst() {
	python_mod_optimize "/opt/phenix-${MY_PV}"
}

pkg_postrm() {
	python_mod_cleanup "/opt/phenix-${MY_PV}"
}
