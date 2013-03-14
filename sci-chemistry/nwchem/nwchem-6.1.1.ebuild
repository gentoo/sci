# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils fortran-2 multilib python toolchain-funcs

DATE="2012-06-27"

DESCRIPTION="NWChem: Delivering High-Performance Computational Chemistry to Science"
HOMEPAGE="http://www.nwchem-sw.org/index.php/Main_Page"
SRC_URI="http://www.nwchem-sw.org/images/Nwchem-${PV}-src.${DATE}.tar.gz"

LICENSE="ECL-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mpi examples nwchem-tests python"

RDEPEND="sys-fs/sysfsutils"
DEPEND="${RDEPEND}
	virtual/fortran
	mpi? ( virtual/mpi[fortran] )"

S="${WORKDIR}/${P}-src"

pkg_setup() {
	fortran-2_pkg_setup
	use python && python_set_active_version 2 &&  python_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/nwchem-${PV}-makefile.patch \
		"${FILESDIR}"/nwchem-${PV}-nwchemrc.patch \
		"${FILESDIR}"/nwchem-${PV}-adjust-dir-length.patch
	use python && "${FILESDIR}"/nwchem-${PV}-python_makefile.patch

	sed \
		-e "s:DBASIS_LIBRARY=\"'\$(SRCDIR)'\":DBASIS_LIBRARY=\"'${EPREFIX}/usr/share/NWChem'\":g" \
		-i src/basis/MakeFile src/basis/GNUmakefile || die
	sed \
		-e "s:DNWPW_LIBRARY=\"'\$(SRCDIR)'\":DNWPW_LIBRARY=\"'${EPREFIX}/usr/share/NWChem'\":g" \
		-i src/nwpw/libraryps/GNUmakefile || die
	sed \
		-e "s:-DCOMPILATION_DIR=\"'\$(TOPDIR)'\":-DCOMPILATION_DIR=\"''\":g" \
		-i src/GNUmakefile src/MakeFile || die

	if [[ $(tc-getFC) == *-*-*-*-gfortran ]]; then
		sed \
			-e "s:ifneq (\$(FC),gfortran):ifneq (\$(FC),$(tc-getFC)):g" \
			-e "s:ifeq (\$(FC),gfortran):ifeq (\$(FC),$(tc-getFC)):g" \
			-i src/config/makefile.h || die
	fi
}

src_compile() {
	export USE_SUBGROUPS=yes
	if use mpi ; then
		export MSG_COMMS=MPI
		export USE_MPI=yes
		export MPI_LOC=/usr
		export MPI_INCLUDE=$MPI_LOC/include
		export MPI_LIB=$MPI_LOC/$(get_libdir)
		export LIBMPI="$(mpif90 -showme:link)"
	fi
	if [ "$ARCH" = "amd64" ]; then
		export NWCHEM_TARGET=LINUX64
	elif [ "$ARCH" = "ia64" ]; then
		export NWCHEM_TARGET=LINUX64
	elif [ "$ARCH" = "x86" ]; then
		export NWCHEM_TARGET=LINUX
	elif [ "$ARCH" = "ppc" ]; then
		export NWCHEM_TARGET=LINUX
	else
		die "Unknown architecture"
	fi
	if use python ; then
		if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "ia64" ]; then
			export USE_PYTHON64=yes
		fi
		export PYTHONHOME=/usr
		export PYTHONVERSION=$(eselect python show|awk -Fpython '{ print $2 }')
		export PYTHONPATH="./:${S}/contrib/python/"
		export NWCHEM_MODULES="all python"
	else
		export NWCHEM_MODULES="all"
	fi

	cd src
	emake \
		DIAG=PAR \
		FC=$(tc-getFC) \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		NWCHEM_TOP="${S}" \
		NWCHEM_EXECUTABLE="${S}/bin/${NWCHEM_TARGET}/nwchem"
}

src_install() {
	dobin bin/${NWCHEM_TARGET}/nwchem

	insinto /usr/share/NWChem/basis/
	doins -r src/basis/libraries src/data
	insinto /usr/share/NWChem/nwpw
	doins -r src/nwpw/libraryps

	insinto /etc
	doins nwchemrc

	use examples && \
		insinto /usr/share/NWChem/ && \
		doins -r examples

	use nwchem-tests \
		insinto /usr/share/NWChem \
		doins -r QA/tests
}

pkg_postinst() {
	echo
	elog "The user will need to link \$HOME/.nwchemrc to /etc/nwchemrc"
	elog "or copy it in order to tell NWChem the right position of the"
	elog "basis library and other necessary data."
	echo
}
