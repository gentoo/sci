# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION=" Why3 is a platform for deductive program verification"
HOMEPAGE="http://why3.lri.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/33490/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="float frama-c doc examples"

DEPEND=">=dev-lang/ocaml-3.12.1
		dev-ml/zarith
		sci-mathematics/coq
		frama-c? ( >=sci-mathematics/frama-c-20140301 )
		float? ( sci-mathematics/flocq )
		doc? ( dev-tex/rubber )"
RDEPEND="${DEPEND}"

DOCS=( CHANGES README Version )

src_prepare() {
	mv doc/why.1 doc/why3.1 || die
	sed -i configure.in -e "s/\"pvs\"/\"sri-pvs\"/g" || die
	sed -i configure -e "s/\"pvs\"/\"sri-pvs\"/g" || die
	sed -i Makefile.in -e "s:DESTDIR =::g" \
		-e "s:\$(RUBBER) --warn all --pdf manual.tex:makeindex manual.tex; \$(RUBBER) --warn all --pdf manual.tex; cd ..:g" || die
}

src_configure() {
	econf $(use_enable frama-c)
}

src_compile() {
	MAKEOPTS+=" -j1"

	default
	if use doc; then
		emake doc/manual.pdf
	fi
}

src_install(){
	default

	doman doc/why3.1
	if use doc; then
		dodoc doc/manual.pdf
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
