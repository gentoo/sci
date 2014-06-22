# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit autotools eutils

DESCRIPTION=" Why3 is a platform for deductive program verification"
HOMEPAGE="http://why3.lri.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/33490/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="frama-c doc examples"

DEPEND=">=dev-lang/ocaml-3.12.1
		dev-ml/zarith
		sci-mathematics/coq
		frama-c? ( >=sci-mathematics/frama-c-20140301 )
		doc? ( dev-tex/rubber )"
RDEPEND="${DEPEND}"

src_prepare() {
	mv doc/why.1 doc/why3.1
    sed -i configure.in -e "s/\"pvs\"/\"sri-pvs\"/g"
	sed -i configure -e "s/\"pvs\"/\"sri-pvs\"/g"
	sed -i Makefile.in -e "s:DESTDIR =::g" \
		-e "s:\$(RUBBER) --warn all --pdf manual.tex:makeindex manual.tex; \$(RUBBER) --warn all --pdf manual.tex; cd ..:g"
}

src_configure() {
	econf $(use_enable frama-c) || die "econf failed"
}

src_compile() {
	emake -j1 || die "emake failed"
	if use doc; then
		emake -j1 doc/manual.pdf || die "emake doc failed"
	fi
}

src_install(){
	DESTDIR="${D}" emake install || die "emake install failed"
	dodoc CHANGES README Version
	doman doc/why3.1
	if use doc; then
		dodoc doc/manual.pdf
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	}
