# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis toolchain-funcs

DESCRIPTION="BLAS/LAPACK interface for OCaml"
HOMEPAGE="http://forge.ocamlcore.org/projects/lacaml"
SRC_URI="https://bitbucket.org/mmottl/lacaml/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( "README.md" "CHANGES.txt" "TODO.md" )

src_prepare() {
	if use doc; then
		cp "${FILESDIR}/API.odocl" . || die
	fi
	cclib="$($(tc-getPKG_CONFIG) --libs blas lapack)"
	cclib="[$(echo $cclib|sed -e 's/\(-[a-z0-9]*\) /\"\1\"\;/g' -e \
	's/\(-[a-z0-9]*\)$/\"\1\"/')]"
	sed -i "s/cclib = \[\]/cclib = ${cclib}/" setup.conf
	#would like to do the below, but doesn't work from ebuild
	#oasis_configure_opts="--override conf_cclib $($(tc-getPKG_CONFIG) --libs blas lapack)"
}
