# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Alt-Ergo is an automatic theorem prover"
HOMEPAGE="http://alt-ergo.lri.fr"
SRC_URI="http://alt-ergo.lri.fr/http/${P}/${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+ocamlopt gtk"

DEPEND="
	>=dev-lang/ocaml-3.10.2[ocamlopt?]
	>=dev-ml/ocamlgraph-1.8.2[gtk?,ocamlopt?]
	gtk? (
		x11-libs/gtksourceview:2.0
		>=dev-ml/lablgtk-2.14[sourceview,ocamlopt?]
	)"
RDEPEND="${DEPEND}"

src_prepare(){
	sed \
		-e "s: /usr/share/: \$(DESTDIR)/usr/share/:g" \
		-e "s:cp -f altgr-ergo.opt:mkdir -p \$(DESTDIR)/usr/share/gtksourceview-2.0/language-specs/\n\tcp -f altgr-ergo.opt:g" \
		-i "${S}"/Makefile.in || die
}

src_compile(){
	emake
	use gtk && emake gui
}
