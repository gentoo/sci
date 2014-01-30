# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_OPT_USE="gui"
VIRTUALX_REQUIRED="manual"

inherit eutils autotools check-reqs fdo-mime bash-completion-r1 \
	java-pkg-opt-2 fortran-2 flag-o-matic toolchain-funcs virtualx

# TODO:
# - work out src_test. do we need testng? (java-experimental overlay)
# - emacs mode: http://forge.scilab.org/index.php/p/scilab-emacs/
# - work out as-needed
# - compatibility with matio >= 1.5
# - apply extra patches? (fedora, mageia, debian, freebsd have some)
# - do ebuilds for scilab packages: plotlib, scimax, scimysql, scivp, swt, ann,
#   celestlab, jims,...

DESCRIPTION="Scientific software package for numerical computations"
HOMEPAGE="http://www.scilab.org/"
SRC_URI="http://www.scilab.org/download/${PV}/${P}-src.tar.gz"

SLOT="0"
LICENSE="CeCILL-2"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion debug doc fftw +gui hdf5 +matio nls openmp
	static-libs test tk +umfpack xcos"
REQUIRED_USE="xcos? ( hdf5 gui ) doc? ( gui )"

# ALL_LINGUAS variable defined in configure.ac
LINGUAS="fr_FR zh_CN zh_TW ca_ES es_ES pt_BR"
for l in ${LINGUAS}; do
	IUSE="${IUSE} linguas_${l}"
done
LINGUASLONG="de_DE ja_JP it_IT uk_UA pl_PL ru_RU"
for l in ${LINGUASLONG}; do
	IUSE="${IUSE} linguas_${l%_*}"
done

CDEPEND="
	dev-libs/libpcre
	dev-libs/libxml2:2
	sys-devel/gettext
	sys-libs/ncurses
	sys-libs/readline
	virtual/lapack
	fftw? ( sci-libs/fftw:3.0 )
	gui? (
		dev-java/avalon-framework
		dev-java/batik
		dev-java/commons-io
		dev-java/commons-logging
		dev-java/flexdock
		dev-java/fop
		=dev-java/gluegen-1*
		dev-java/javahelp
		dev-java/jeuclid-core
		dev-java/jgoodies-looks
		>=dev-java/jlatexmath-0.9.4
		=dev-java/jogl-1*
		dev-java/jrosetta
		dev-java/skinlf
		dev-java/xmlgraphics-commons
		virtual/opengl
		doc? ( dev-java/saxon:6.5 )
		hdf5? (
			dev-java/hdf-java
			xcos? ( =dev-java/jgraphx-1.4.1.0 ) ) )
	hdf5? ( sci-libs/hdf5 )
	matio? ( <sci-libs/matio-1.5 )
	tk? ( dev-lang/tk )
	umfpack? ( sci-libs/umfpack )"

RDEPEND="${CDEPEND}
	gui? ( >=virtual/jre-1.5 )"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	debug? ( dev-util/lcov )
	gui? (
		>=virtual/jdk-1.5
		doc? (
			app-text/docbook-xsl-stylesheets
			>=dev-java/jlatexmath-fop-0.9.4
			dev-java/xml-commons-external )
		xcos? ( dev-lang/ocaml ) )
	test? ( gui? ( ${VIRTUALX_DEPEND} ) )"

pkg_pretend() {
	use doc && CHECKREQS_MEMORY="512M" check-reqs_pkg_pretend
}

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc* ]] && ! tc-has-openmp; then
			ewarn "You are using a gcc without OpenMP capabilities"
			die "Need an OpenMP capable compiler"
		fi
		FORTRAN_NEED_OPENMP=1
	fi
	FORTRAN_STANDARD="77 90"
	fortran-2_pkg_setup
	java-pkg-opt-2_pkg_setup
	ALL_LINGUAS=
	for l in ${LINGUAS}; do
		use linguas_${l} && ALL_LINGUAS="${ALL_LINGUAS} ${l}"
	done
	for l in ${LINGUASLONG}; do
		use linguas_${l%_*} && ALL_LINGUAS="${ALL_LINGUAS} ${l}"
	done
	export ALL_LINGUAS
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-fortran-link.patch \
		"${FILESDIR}"/${P}-jvm-detection.patch \
		"${FILESDIR}"/${P}-disable-build-help.patch \
		"${FILESDIR}"/${P}-hdf18.patch \
		"${FILESDIR}"/${P}-no-lhpi.patch \
		"${FILESDIR}"/${P}-blas-libs.patch \
		"${FILESDIR}"/${P}-no-xcos-deps.patch \
		"${FILESDIR}"/${P}-javadoc-utf8.patch \
		"${FILESDIR}"/${P}-fix-random-runtime-failures.patch \
		"${FILESDIR}"/${P}-gui-no-xcos.patch \
		"${FILESDIR}"/${P}-java-version-check.patch

	# need serious as-needed work (inter-dependencies among modules)
	#	"${FILESDIR}"/${P}-as-needed.patch \
	append-ldflags $(no-as-needed)

	# to apply with matio-1.5, unfortunately needs more work
	#   "${FILESDIR}"/${P}-matio15.patch

	# increases java heap to 512M when building docs (sync with cheqreqs above)
	use doc && epatch "${FILESDIR}"/${P}-java-heap.patch

	# make sure library path are preloaded in binaries
	sed -i \
		-e "s|^LD_LIBRARY_PATH=|LD_LIBRARY_PATH=${EPREFIX}/usr/$(get_libdir)/scilab:|g" \
		bin/scilab* || die

	# fix jgraphx min version (fixed upstream)
	sed -i -e 's/\[=\]/\[\]/p' configure.ac || die

	# upstream http://bugzilla.scilab.org/show_bug.cgi?id=10244
	mv  modules/call_scilab/examples/call_scilab/NET/VB.NET/My\ Project/ \
		modules/call_scilab/examples/call_scilab/NET/VB.NET/My_Project || die

	# gentoo bug #392363 (fixed upstream)
	sed -i \
		-e "s|Cl.*ment DAVID|Clement DAVID|g" \
		$(find . -iname '*.java') || die

	# add specific gentoo java directories
	if use gui; then
		sed -i -e "s|-L\$SCI_SRCDIR/bin/|-L\$SCI_SRCDIR/bin/ \
		-L$(java-config -i gluegen) \
		-L$(java-config -i jogl)|" \
			configure.ac || die
		sed -i \
			-e "/<\/librarypaths>/i\<path value=\"$(java-config -i gluegen)\"\/>" \
			-e "/<\/librarypaths>/i\<path value=\"$(java-config -i jogl)\"\/>" \
			etc/librarypath.xml || die
		if use xcos; then
			sed -i \
				-e "s|/usr/lib/jni|$(java-config -i hdf-java)|g" \
				m4/hdf5.m4 || die
		sed -i \
			-e "/<\/librarypaths>/i\<path value=\"$(java-config -i hdf-java)\"\/>" \
			etc/librarypath.xml || die
		fi
	fi
	java-pkg-opt-2_src_prepare
	eautoreconf
}

src_configure() {
	if use gui; then
		export JAVA_HOME="$(java-config -O)"
	else
		unset JAVAC
	fi

	export BLAS_LIBS="$($(tc-getPKG_CONFIG) --libs blas)"
	export LAPACK_LIBS="$($(tc-getPKG_CONFIG) --libs lapack)"
	export F77_LDFLAGS="${LDFLAGS}"
	# gentoo bug #302621
	use hdf5 && has_version sci-libs/hdf5[mpi] && \
		export CXX=mpicxx CC=mpicc FC=mpif77 F77=mpif77

	econf \
		--enable-relocatable \
		--disable-rpath \
		--with-docbook="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets" \
		--without-pvm \
		$(use_enable debug) \
		$(use_enable debug code-coverage) \
		$(use_enable debug debug-C) \
		$(use_enable debug debug-CXX) \
		$(use_enable debug debug-fortran) \
		$(use_enable debug debug-java) \
		$(use_enable debug debug-linker) \
		$(use_enable doc build-help) \
		$(use_enable nls) \
		$(use_enable nls build-localization) \
		$(use_enable static-libs static) \
		$(use_enable test compilation-tests) \
		$(use_with fftw) \
		$(use_with gui) \
		$(use_with gui javasci) \
		$(use_with hdf5) \
		$(use_with matio) \
		$(use_with openmp) \
		$(use_with tk) \
		$(use_with umfpack) \
		$(use_with xcos) \
		$(use_with xcos modelica)
}

src_compile() {
	emake
	use doc && emake doc
}

src_test() {
	if use gui; then
		Xemake check
	else
		emake check
	fi
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	dodoc ACKNOWLEDGEMENTS README_Unix Readme_Visual.txt
	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/${PN}.xml
	use bash-completion && newbashcomp "${FILESDIR}"/"${PN}".bash_completion "${PN}"
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
