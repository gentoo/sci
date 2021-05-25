# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit dune

DESCRIPTION="BLAS/LAPACK interface for OCaml"
HOMEPAGE="https://mmottl.github.io/lacaml/"
SRC_URI="https://github.com/mmottl/lacaml/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ocamlopt"

RDEPEND="
	virtual/blas
	virtual/lapack
	dev-ml/dune-configurator
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

DOCS=( "README.md" "CHANGES.txt" "TODO.md" )
