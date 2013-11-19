EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils git-2 autotools python-r1

DESCRIPTION="An efficient theorem prover"
HOMEPAGE="http://z3.codeplex.com/"
EGIT_REPO_URI="https://git01.codeplex.com/z3"
EGIT_COMMIT="v${PV}"
KEYWORDS="amd64 x86"

SLOT="0"
IUSE=""
DEPEND="
	app-arch/unzip
	sys-devel/autoconf
	>=net-misc/curl-7.33"
RDEPEND="${DEPEND}"

S="${WORKDIR}/z3"

src_prepare() {
	eautoconf
}

src_configure() {
	econf --host="" --with-python="$(which python2)"
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

	sed -i '1i#!/usr/bin/python2' src/api/python/*.py || die "sed failed"
	python_foreach_impl python_domodule src/api/python/*.py
}
