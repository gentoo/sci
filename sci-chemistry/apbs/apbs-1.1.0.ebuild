# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/apbs/apbs-1.0.0-r1.ebuild,v 1.1 2008/10/11 17:29:20 markusle Exp $

EAPI="2"

inherit eutils fortran autotools python

MY_P="${P}-source"
S="${WORKDIR}"/"${MY_P}"

DESCRIPTION=" Software for evaluating the electrostatic properties of nanoscale biomolecular systems"
LICENSE="BSD"
HOMEPAGE="http://apbs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

SLOT="0"
IUSE="arpack blas doc fetk mpi python tinker"
KEYWORDS="~x86 ~amd64"

DEPEND="dev-libs/maloc[mpi=]
	blas? ( virtual/blas )
	python? ( dev-lang/python )
	sys-libs/readline
	arpack? ( sci-libs/arpack )
	mpi? ( virtual/mpi )
	fetk? ( dev-libs/punc )
	tinker? ( sci-chemistry/tinker )"
RDEPEND="${DEPEND}"

FORTRAN="g77 gfortran ifc"

src_prepare() {
	python_version

	epatch "${FILESDIR}"/${P}-install-fix.patch
	epatch "${FILESDIR}"/${P}-automagic.patch
	epatch "${FILESDIR}"/${P}-LDFLAGS.patch
	epatch "${FILESDIR}"/${P}-vgrid-maloc.patch
	sed "s:GENTOO_PKG_NAME:${P}:g" \
	-i Makefile.am || die "Cannot correct package name"
	eautoreconf

	find "${S}" -type f -name "*.py" \
		-exec sed -e "s|/usr/bin/env python|${python}|g" -i '{}' \;
}

src_configure() {
	local myconf="--docdir=/usr/share/doc/${PF}"
	use blas && myconf="${myconf} --with-blas=-lblas"
	use arpack && myconf="${myconf} --with-arpack=/usr/$(get_libdir)"
	use fetk && myconf="${myconf} $(use_enable fetk) --with-fetk-include=/usr/include --with-fetk-library=/usr/$(get_libdir)"

	# check which mpi version is installed and tell configure
	if use mpi; then
		export CC="/usr/bin/mpicc"
		export F77="/usr/bin/mpif77"

		if has_version sys-cluster/mpich; then
	 		myconf="${myconf} --with-mpich=/usr"
		elif has_version sys-cluster/mpich2; then
			myconf="${myconf} --with-mpich2=/usr"
		elif has_version sys-cluster/lam-mpi; then
			myconf="${myconf} --with-lam=/usr"
		elif has_version sys-cluster/openmpi; then
			myconf="${myconf} --with-openmpi=/usr"
		fi
	fi || die "Failed to select proper mpi implementation"

	econf $(use_enable python) \
		$(use_enable tinker) \
		--disable-maloc-rebuild \
		${myconf} || die "configure failed"
}

src_compile() {
	emake -j1 || die "make failed"
}

src_test() {
	cd examples && make test \
		|| die "Tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS INSTALL README NEWS ChangeLog \
		|| die "Failed to install docs"
	use doc || rm -rf "${D}"/usr/share/${P}/doc
}
