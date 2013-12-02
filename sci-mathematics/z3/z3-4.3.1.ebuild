EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils vcs-snapshot autotools python-r1

DESCRIPTION="An efficient theorem prover"
HOMEPAGE="http://z3.codeplex.com/"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"
KEYWORDS="~amd64 ~x86"

SLOT="0"
IUSE=""
RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	eautoreconf
}

src_configure() {
	python_export_best
	econf --host="" --with-python="${PYTHON}"
	python2 scripts/mk_make.py
}

src_compile() {
	emake --directory="build"
}

src_install() {
	doheader src/api/z3*.h
	doheader src/api/c++/z3*.h
	dolib.so build/*.so
	dobin build/z3

	python_foreach_impl python_domodule src/api/python/*.py
}
