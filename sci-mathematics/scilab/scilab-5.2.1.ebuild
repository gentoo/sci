# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools check-reqs eutils java-pkg-2

DESCRIPTION="Scientific software package for numerical computations"
LICENSE="CeCILL-2"
SRC_URI="http://www.scilab.org/download/${PV}/${P}-src.tar.gz"
HOMEPAGE="http://www.scilab.org/"

SLOT="0"
IUSE="doc fftw +gui hdf5 +matio nls tk +umfpack xcos"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/lapack
	tk? ( dev-lang/tk )
	xcos? ( dev-lang/ocaml )
	umfpack? ( sci-libs/umfpack )
	gui? ( >=virtual/jre-1.5
		dev-java/commons-logging
		dev-java/flexdock
		dev-java/gluegen
		dev-java/jeuclid-core
		dev-java/jlatexmath
		>=dev-java/jgraphx-1.2.0.7
		dev-java/jogl
		dev-java/jgoodies-looks
		dev-java/skinlf
		dev-java/jrosetta
		dev-java/javahelp
		hdf5? ( dev-java/hdf-java ) )
	fftw? ( sci-libs/fftw:3.0 )
	matio? ( sci-libs/matio )
	hdf5? ( sci-libs/hdf5 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? (
		~dev-java/saxon-6.5.5
		dev-java/fop
		dev-java/batik
		app-text/docbook-xsl-stylesheets )"

pkg_setup() {
	CHECKREQS_MEMORY="512"
	java-pkg-2_pkg_setup
}

src_prepare() {
	# avoid redefinition of exp10
	epatch "${FILESDIR}"/${P}-no-redef-exp10.patch
	# Increases java heap to 512M when available, when building docs
	check_reqs_conditional && epatch "${FILESDIR}"/${P}-java-heap.patch
	# fix for hdf-java-2.6
	epatch "${FILESDIR}"/${P}-hdf-java-2.6.patch
	# fix for jgraphx
	epatch "${FILESDIR}"/${P}-scilib-fix.patch
	epatch "${FILESDIR}"/${P}-nojavacheckversion.patch

	# apply blindly some debian patches
	#for i in "${FILESDIR}"/*.diff; do
	#	epatch ${i}
	#done

	# add the correct java directories to the config file
	sed \
		-i "/^.DEFAULT_JAR_DIR/{s|=.*|=\"$(echo $(ls -d /usr/share/*/lib))\"|}" \
		m4/java.m4 || die

	sed -i "s|-L\$SCI_SRCDIR/bin/|-L\$SCI_SRCDIR/bin/ \
		-L$(java-config -i gluegen) \
		-L$(java-config -i hdf-java) \
		-L$(java-config -i jogl)|" \
		configure.ac || die
	sed -i \
		-e "/<\/librarypaths>/i\<path value=\"$(java-config -i gluegen)\"\/>" \
		-e "/<\/librarypaths>/i\<path value=\"$(java-config -i jogl)\"\/>" \
		-e "/<\/librarypaths>/i\<path value=\"$(java-config -i hdf-java)\"\/>" \
		etc/librarypath.xml || die
	eautoreconf
	java-pkg-2_src_prepare
}

src_configure() {
	local myopts
	use doc && myopts="--with-docbook=/usr/share/sgml/docbook/xsl-stylesheets"
	export JAVA_HOME=$(java-config -O)
	export BLAS_LIBS="$(pkg-config --libs blas)"
	export LAPACK_LIBS="$(pkg-config --libs lapack)"
	# mpi is only used for hdf5 i/o
	if use hdf5 && has_version sci-libs/hdf5[mpi]; then
		export CC=mpicc
		export CXX=mpicxx
		export FC=mpif90
		export F77=mpif77
	fi
	econf \
		--disable-rpath \
		--without-pvm \
		$(use_enable doc build-help) \
		$(use_enable nls) \
		$(use_enable nls build-localization) \
		$(use_with fftw) \
		$(use_with gui)\
		$(use_with gui javasci)\
		$(use_with hdf5) \
		$(use_with matio) \
		$(use_with umfpack) \
		$(use_with tk) \
		$(use_with xcos scicos) \
		${myopts}
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		emake doc || die "emake failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# install docs
	dodoc ACKNOWLEDGEMENTS CHANGES README_Unix RELEASE_NOTES \
		Readme_Visual.txt || die "failed to install docs"

	#install icon
	newicon icons/scilab.xpm scilab.xpm
	make_desktop_entry ${PN} "Scilab" ${PN}
}

pkg_postinst() {
	einfo "To tell Scilab about your printers, set the environment"
	einfo "variable PRINTERS in the form:"
	einfo
	einfo "PRINTERS=\"firstPrinter:secondPrinter:anotherPrinter\""
}
