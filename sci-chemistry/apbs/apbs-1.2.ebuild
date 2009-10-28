# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils fortran flag-o-matic python

MY_P="${P}-source"
FORTRAN="g77 gfortran ifc"

DESCRIPTION=" Software for evaluating the electrostatic properties of nanoscale biomolecular systems"
HOMEPAGE="http://apbs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~amd64"
LICENSE="BSD"
IUSE="arpack blas doc fetk mpi openmp python tinker"

DEPEND="
	dev-libs/maloc[mpi=]
	dev-python/zsi
	dev-python/opal-client
	sys-libs/readline
	arpack? ( sci-libs/arpack )
	blas? ( virtual/blas )
	fetk? ( dev-libs/punc )
	mpi? ( virtual/mpi )
	python? ( dev-lang/python )
	tinker? ( sci-chemistry/tinker )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${MY_P}"

src_prepare() {
	python_version
	epatch \
		"${FILESDIR}"/${P}-install-fix.patch \
		"${FILESDIR}"/${P}-contrib.patch \
		"${FILESDIR}"/${P}-LDFLAGS.patch \
		"${FILESDIR}"/${P}-vgrid-maloc.patch \
		"${FILESDIR}"/${PV}-openmp.patch

	sed \
		-e "s:GENTOO_PKG_NAME:${P}:g" \
		-i Makefile.am || die "Cannot correct package name"

	eautoreconf

	find "${S}" -type f -name "*.py" \
		-exec sed -e "s|/usr/bin/env python|${python}|g" -i '{}' \;
}

src_configure() {
	local myconf="--docdir=/usr/share/doc/${PF}"
	use arpack && myconf="${myconf} --with-arpack=/usr/$(get_libdir)"
	use blas && myconf="${myconf} --with-blas=-lblas"
	use fetk && myconf="${myconf} $(use_enable fetk) --with-fetk-include=/usr/include --with-fetk-library=/usr/$(get_libdir)"

	if use openmp; then
		append-flags -fopenmp
	else
		myconf="${myconf} --disable-openmp"
	fi

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
	econf \
		$(use_enable python) \
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
	emake -j1 DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS INSTALL README NEWS ChangeLog \
		|| die "Failed to install docs"
	use doc || rm -rf "${D}"/usr/share/${P}/doc
}
