# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils flag-o-matic fortran-2 multilib python-single-r1 toolchain-funcs

DATE="2013-10-17"

DESCRIPTION="Delivering High-Performance Computational Chemistry to Science"
HOMEPAGE="http://www.nwchem-sw.org/index.php/Main_Page"
SRC_URI="http://www.nwchem-sw.org/images/Nwchem-${PV%_p*}.revision${PV#*_p}-src.${DATE}.tar.gz"

LICENSE="ECL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="blas mpi doc examples nwchem-tests openmp mrcc python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	sys-fs/sysfsutils
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	app-shells/tcsh
	mpi? ( virtual/mpi[fortran] )
	doc? (
		dev-texlive/texlive-latex
		dev-tex/latex2html )"

LONG_S="${WORKDIR}/${PN}-${PV%_p*}.revision${PV#*_p}-src.${DATE}"
S="${WORKDIR}/${PN}"

pkg_setup() {
	# fortran-2.eclass does not handle mpi wrappers
	if use mpi; then
		export FC="mpif90"
		export F77="mpif77"
		export CC="mpicc"
		export CXX="mpic++"
	else
		tc-export FC F77 CC CXX
	fi

	use openmp && FORTRAN_NEED_OPENMP=1

	fortran-2_pkg_setup

	if use openmp; then
		# based on _fortran-has-openmp() of fortran-2.eclass
		local openmp=""
		local fcode=ebuild-openmp-flags.f
		local _fc=$(tc-getFC)

		pushd "${T}"
		cat <<- EOF > "${fcode}"
		1     call omp_get_num_threads
		2     end
		EOF

		for openmp in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
			"${_fc}" "${openmp}" "${fcode}" -o "${fcode}.x" && break
		done

		rm -f "${fcode}.*"
		popd

		append-flags "${openmp}"
	fi

	use python && python-single-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
	mv "${LONG_S}" "${S}"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/nwchem-6.1.1-makefile.patch \
		"${FILESDIR}"/nwchem-6.1.1-nwchemrc.patch \
		"${FILESDIR}"/nwchem-6.1.1-adjust-dir-length.patch
	use python && epatch "${FILESDIR}"/nwchem-6.1.1-python_makefile.patch
	use doc && epatch "${FILESDIR}"/nwchem-6.3-r1-html_doc.patch

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
		export USE_MPI=y
		export USE_MPIF=y
		export MPI_LOC="${EPREFIX}"/usr
		export MPI_INCLUDE=$MPI_LOC/include
		export MPI_LIB=$MPI_LOC/$(get_libdir)
		export LIBMPI="$(mpif90 -showme:link)"
	else
		unset USE_MPI
		unset USE_MPIF
		export MSG_COMMS=TCGMSG
		export ARMCI_NETWORK=SOCKETS
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
		export PYTHONVERSION=$(eselect python show --python2 |awk -Fpython '{ print $2 }')
		export PYTHONPATH="./:${S}/contrib/python/"
		export NWCHEM_MODULES="all python"
	else
		export NWCHEM_MODULES="all"
	fi
	use mrcc && export MRCC_THEORY="TRUE"
	if use blas; then
		export HAS_BLAS=yes
		export BLASOPT="$(pkg-config --libs blas)"
	else
		unset HAS_BLAS
		unset BLASOPT
	fi
	export LARGE_FILES="TRUE"

	cd src
	emake \
		DIAG=PAR \
		FC=$(tc-getFC) \
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		NWCHEM_TOP="${S}" \
		NWCHEM_EXECUTABLE="${S}/bin/${NWCHEM_TARGET}/nwchem"

	if use doc; then
		cd "${S}"/doc
		export VARTEXFONTS="${T}/fonts"
		emake \
			DIAG=PAR \
			NWCHEM_TOP="${S}" \
			pdf html
	fi
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

	use nwchem-tests && \
		insinto /usr/share/NWChem && \
		doins -r QA/tests

	use doc && \
		insinto /usr/share/doc/"${P}" && \
		doins -r doc/nwahtml && \
		doins -r web

}

pkg_postinst() {
	echo
	elog "The user will need to link \$HOME/.nwchemrc to /etc/nwchemrc"
	elog "or copy it in order to tell NWChem the right position of the"
	elog "basis library and other necessary data."
	echo
}
