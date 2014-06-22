# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Alt-Ergo is an automatic theorem prover"
HOMEPAGE="http://alt-ergo.ocamlpro.com"
SRC_URI="${HOMEPAGE}/download_manager.php?target=${P}.tar.gz"

LICENSE="CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ocamlopt gtk"

DEPEND=">=dev-lang/ocaml-3.12.1[ocamlopt?]
		>=dev-ml/ocamlgraph-1.8.2[gtk?,ocamlopt?]
		gtk? ( >=x11-libs/gtksourceview-2.8
				>=dev-ml/lablgtk-2.14[sourceview,ocamlopt?] )"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i ${S}/Makefile.in \
		-e "s: /usr/share/: \$(DESTDIR)/usr/share/:g" \
		-e "s:cp -f altgr-ergo.opt:mkdir -p \$(DESTDIR)/usr/share/gtksourceview-2.0/language-specs/\n\tcp -f altgr-ergo.opt:g"
}
src_compile(){
	emake || die "emake failed"
	if use gtk; then
		emake gui || die "emake gui failed"
	fi
}

src_install(){
	DESTDIR="${D}" emake install || die "emake install failed"
	dodoc README.md CHANGES
}
