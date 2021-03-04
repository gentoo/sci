# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DOCS_BUILDER="sphinx"
DOCS_DIR="doc"
DOCS_DEPEND="
	dev-python/sphinxcontrib-bibtex
	dev-python/graphviz
"

inherit python-any-r1 docs

DESCRIPTION="Why3 is a platform for deductive program verification"
HOMEPAGE="http://why3.lri.fr/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/38367/why3-1.3.3.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="float frama-c examples"

DEPEND="
	>=dev-lang/ocaml-3.12.1
	dev-ml/zarith
	dev-ml/menhir
	dev-ml/num
	sci-mathematics/coq
	frama-c? ( >=sci-mathematics/frama-c-20140301 )
	float? ( sci-mathematics/flocq )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	mv doc/why.1 doc/why3.1 || die
	sed -i configure.in -e "s/\"pvs\"/\"sri-pvs\"/g" || die
	sed -i configure -e "s/\"pvs\"/\"sri-pvs\"/g" || die
	# fix dev-ml/num path
	sed -i configure.in -e "s/nums.cma/num.cma/g" -e "s/num.cmi/core\/num.cmi/g" || die
	sed -i configure -e "s/nums.cma/num.cma/g" -e "s/num.cmi/core\/num.cmi/g" || die
	sed -i Makefile.in -e "s:DESTDIR =::g" \
		-e "s:\$(RUBBER) --warn all --pdf manual.tex:makeindex manual.tex; \$(RUBBER) --warn all --pdf manual.tex; cd ..:g" || die
	# add autodoc to sphinx
	sed -i -e "/^extensions = \[/a \ \ \ \ \'sphinx.ext.autodoc\'," doc/conf.py || die
}

src_configure() {
	econf $(use_enable frama-c)
}

src_compile() {
	docs_compile
	default
}

src_install(){
	default

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
