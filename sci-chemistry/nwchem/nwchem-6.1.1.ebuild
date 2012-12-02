# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils fortran-2 multilib python toolchain-funcs

DESCRIPTION="NWChem: Delivering High-Performance Computational Chemistry to Science"
HOMEPAGE="http://www.nwchem-sw.org/index.php/Main_Page"
DATE="2012-06-27"
SRC_URI="http://www.nwchem-sw.org/images/Nwchem-${PV}-src.${DATE}.tar.gz"
LICENSE="ECL-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="mpi examples nwchem-tests python"

RDEPEND="
	sys-fs/sysfsutils
"

DEPEND="${RDEPEND}
	virtual/fortran
	mpi? ( virtual/mpi[fortran] )
"

S="${WORKDIR}/${P}-src"

pkg_setup() {
	  fortran-2_pkg_setup
	  python_set_active_version 2
	  python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/nwchem-${PV}-makefile.patch
	epatch "${FILESDIR}"/nwchem-${PV}-nwchemrc.patch
	epatch "${FILESDIR}"/nwchem-${PV}-adjust-dir-length.patch
	if use python ; then
		epatch "${FILESDIR}"/nwchem-${PV}-python_makefile.patch
	fi
	sed -e "s:DBASIS_LIBRARY=\"'\$(SRCDIR)'\":DBASIS_LIBRARY=\"'${EPREFIX}/usr/share/NWChem'\":g" \
		-i src/basis/MakeFile \
		-i src/basis/GNUmakefile || die
	sed -e "s:DNWPW_LIBRARY=\"'\$(SRCDIR)'\":DNWPW_LIBRARY=\"'${EPREFIX}/usr/share/NWChem'\":g" \
		-i src/nwpw/libraryps/GNUmakefile || die
	sed -e "s:-DCOMPILATION_DIR=\"'\$(TOPDIR)'\":-DCOMPILATION_DIR=\"''\":g" \
		-i src/GNUmakefile \
		-i src/MakeFile

	if [[ $(tc-getFC) == *-*-*-*-gfortran ]]; then
		sed -e "s:ifneq (\$(FC),gfortran):ifneq (\$(FC),$(tc-getFC)):g" \
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
		export LIBMPI="-lfmpich -lmpich -lpthread" # fix mpi linking!
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
		NWCHEM_EXECUTABLE="${S}/bin/${NWCHEM_TARGET}/nwchem" \
		|| die "Compilation failed"
}

src_install() {
	dobin bin/${NWCHEM_TARGET}/nwchem || die "Failed to install binary"

	dodir /usr/share/NWChem/basis || die "Failed to create data directory"
	insinto /usr/share/NWChem/basis/libraries
	doins -r src/basis/libraries/* || die "Failed to install basis library"
	dodir /usr/share/NWChem/data || die "Failed to create data directory"
	insinto /usr/share/NWChem/data
	doins -r src/data/* || die "Failed to install data"
	dodir /usr/share/NWChem/nwpw || die "Failed to create data directory"
	insinto /usr/share/NWChem/nwpw/libraryps
	doins -r src/nwpw/libraryps/* || die "Failed to install data"

	insinto /etc
	doins nwchemrc

	if use examples ; then
		dodir /usr/share/NWChem/examples || die "Failed to create examples directory"
		insinto /usr/share/NWChem/examples
		doins -r examples/* || die "Failed to install examples"
	fi

	if use nwchem-tests ; then
		dodir /usr/share/NWChem/tests || die "Failed to create tests directory"
		insinto /usr/share/NWChem/tests
		doins -r QA/tests/* || "Failed to install tests"
	fi
}

pkg_postinst() {
	elog
	elog "The user will need to link \$HOME/.nwchemrc to /etc/nwchemrc"
	elog "or copy it in order to tell NWChem the right position of the"
	elog "basis library and other necessary data."
	elog
}
