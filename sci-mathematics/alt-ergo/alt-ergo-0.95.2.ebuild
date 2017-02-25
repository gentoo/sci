# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Alt-Ergo is an automatic theorem prover"
HOMEPAGE="http://alt-ergo.ocamlpro.com"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ocamlopt gtk"

DEPEND="
	>=dev-lang/ocaml-3.12.1[ocamlopt?]
	>=dev-ml/ocamlgraph-1.8.2[gtk?,ocamlopt?]
	dev-ml/zarith
	gtk? (
		>=x11-libs/gtksourceview-2.8:2.0
		>=dev-ml/lablgtk-2.14[sourceview,ocamlopt?]
	)"
RDEPEND="${DEPEND}"

src_prepare(){
	sed \
		-e 's: /usr/share/: $(DESTDIR)/usr/share/:g' \
		-e 's:cp -f altgr-ergo.opt:mkdir -p $(DESTDIR)/usr/share/gtksourceview-2.0/language-specs/\n\tcp -f altgr-ergo.opt:g' \
		-i "${S}"/Makefile.in || die
}
src_compile(){
	default
	use gtk && emake gui
}

src_install(){
	default
	use gtk && emake install-gui DESTDIR="${D}"
	dodoc README.md CHANGES
}
