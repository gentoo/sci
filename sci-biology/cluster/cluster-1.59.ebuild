# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Hierarchical, k-means, k-medians clustering for expression/microarray analysis"
HOMEPAGE="http://bonsai.hgc.jp/~mdehoon/software/cluster
	http://bonsai.hgc.jp/~mdehoon/software/cluster/software.htm#ctv"
SRC_URI="http://bonsai.hgc.jp/~mdehoon/software/cluster/${P}.tar.gz"

LICENSE="Eisen"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="X? ( x11-libs/motif:0= )"
RDEPEND="
	X? (
		x11-misc/xdg-utils
		app-text/mupdf
	)"

src_prepare() {
	default
	sed -i \
		-e 's:^docdir = .*$:docdir = @docdir@:' \
		-e 's:^htmldir = .*$:htmldir = @htmldir@:' \
		-e 's:^imagedir = .*$:imagedir = @htmldir@/images:' \
		-e 's:^fileformatdir = .*$:fileformatdir = @docdir@:' \
		X11/Makefile.in || die "sed failed"
}

src_configure() {
	econf \
		$(use_with X x) \
		--docdir="/usr/share/doc/${PF}" \
		--htmldir="/usr/share/doc/${PF}/html"
}

src_install() {
	default

	mv "${ED}"/usr/bin/cluster{,3} || die

	dodoc doc/cluster.pdf
	docinto examples
	dodoc example/example.c example/README
}

pkg_postinst() {
	elog "We renamed the cluster binary to cluster3"
}
