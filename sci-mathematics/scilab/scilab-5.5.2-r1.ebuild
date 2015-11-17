# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

RESTRICT="test"

JAVA_PKG_OPT_USE="gui"
VIRTUALX_REQUIRED="manual"

inherit eutils autotools bash-completion-r1 check-reqs fdo-mime flag-o-matic \
	fortran-2 java-pkg-opt-2 pax-utils toolchain-funcs virtualx

DESCRIPTION="Scientific software package for numerical computations"
HOMEPAGE="http://www.scilab.org/"
SRC_URI="http://www.scilab.org/download/${PV}/${P}-src.tar.gz"

LICENSE="CeCILL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="bash-completion debug doc emf fftw +gui +matio mpi nls openmp
	static-libs test tk +umfpack +xcos"
REQUIRED_USE="xcos? ( gui ) doc? ( gui )"

LINGUAS="fr_FR zh_CN zh_TW ru_RU ca_ES de_DE es_ES pt_BR ja_JP it_IT uk_UA pl_PL cs_CZ"
LINGUAS_DOC="fr_FR pt_BR ja_JP ru_RU"

for l in ${LINGUAS}; do
	IUSE="${IUSE} linguas_${l}"
done

CDEPEND="
	dev-libs/libpcre
	dev-libs/libxml2:2
	sci-libs/hdf5[mpi=]
	>=sci-libs/arpack-3
	sys-devel/gettext
	sys-libs/ncurses:0=
	sys-libs/readline:0=
	virtual/lapack
	emf? (
		dev-java/freehep-graphicsio
		dev-java/freehep-graphicsio-emf
		dev-java/freehep-graphics2d
		dev-java/freehep-io
		dev-java/freehep-util
	)
	fftw? ( sci-libs/fftw:3.0 )
	gui? (
		dev-java/avalon-framework:4.2
		>=dev-java/batik-1.8-r2:1.8
		dev-java/commons-io:1
		dev-java/commons-logging:0
		>=dev-java/flexdock-1.2.4:0
		>=dev-java/fop-2.0:0
		=dev-java/gluegen-2.2.4:2.2
		dev-java/javahelp:0
		dev-java/jeuclid-core:0
		dev-java/jgoodies-looks:2.6
		>=dev-java/jlatexmath-1.0.3:1
		>=dev-java/jlatexmath-fop-1.0.3:1
		=dev-java/jogl-2.2.4:2.2
		>=dev-java/jrosetta-1.0.4:0
		dev-java/skinlf:0
		dev-java/xmlgraphics-commons:2
		virtual/opengl
		xcos? ( dev-java/jgraphx:2.5 )
		)
	matio? ( >=sci-libs/matio-1.5 )
	tk? ( dev-lang/tk:0= )
	umfpack? ( sci-libs/umfpack )"

RDEPEND="${CDEPEND}
	gui? ( >=virtual/jre-1.5 )"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	debug? ( dev-util/lcov )
	gui? (
		>=virtual/jdk-1.6
		doc? ( app-text/docbook-xsl-stylesheets
			   dev-java/xml-commons-external:1.4
			   dev-java/saxon:9 )
		xcos? ( dev-lang/ocaml )
		)
	test? (
		dev-java/junit:4
		gui? ( ${VIRTUALX_DEPEND} ) )"

DOCS=( "ACKNOWLEDGEMENTS" "README_Unix" "Readme_Visual.txt" )

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
	#bug 8053
	unset F77
	java-pkg-opt-2_pkg_setup

	ALL_LINGUAS="en_US"
	ALL_LINGUAS_DOC="en_US"
	for l in ${LINGUAS}; do
		use linguas_${l} && ALL_LINGUAS="${ALL_LINGUAS} ${l}"
	done
	for l in ${LINGUAS_DOC}; do
		use linguas_${l} && ALL_LINGUAS_DOC="${ALL_LINGUAS_DOC} ${l}"
	done
	export ALL_LINGUAS ALL_LINGUAS_DOC
}

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-followlinks.patch" \
		"${FILESDIR}/${P}-gluegen.patch" \
		"${FILESDIR}/${P}-fix-random-runtime-failure.patch" \
		"${FILESDIR}/${P}-accessviolation.patch" \
		"${FILESDIR}/${P}-missinglib.patch" \
		"${FILESDIR}/${P}-batik-1.8.patch" \
		"${FILESDIR}/${P}-fop-2.0.patch" \
		"${FILESDIR}/${P}-xmlgraphics-common-2.0.patch"

	# works for me on x86, but users are having
	# trouble without see #282 on github
	append-ldflags $(no-as-needed)

	# increases java heap to 512M when building docs (sync with cheqreqs above)
	use doc && epatch "${FILESDIR}/${P}-java-heap.patch"

	# use the LINGUAS variable that we set
	sed -i -e "/^ALL_LINGUAS=/d" -e "/^ALL_LINGUAS_DOC=/d" -i configure.ac ||die

	# make sure the DOCBOOK_ROOT variable is set
	sed -i -e "s/xsl-stylesheets-\*/xsl-stylesheets/g" bin/scilab* || die

	#add specific gentoo java directories
	if use gui; then
		sed -i -e "s|/usr/lib/jogl2|/usr/lib/jogl-2.2|" \
			-e "s|/usr/lib64/jogl2|/usr/lib64/jogl-2.2|" configure.ac || die
		sed -i -e "s|/usr/lib/gluegen2|/usr/lib/gluegen-2.2|" \
			-e "s|/usr/lib64/gluegen2|/usr/lib64/gluegen-2.2|" \
			-e "s|AC_CHECK_LIB(\[gluegen2-rt|AC_CHECK_LIB([gluegen-rt|" \
			configure.ac || die

		sed -i -e "s/jogl2/jogl-2.2/" -e "s/gluegen2/gluegen-2.2/" \
			etc/librarypath.xml || die
	fi

	mkdir jar || die
	pushd jar >/dev/null
	if use gui; then
		java-pkg_jar-from jlatexmath-1,flexdock,skinlf
		java-pkg_jar-from jgoodies-looks-2.6,jrosetta
		java-pkg_jar-from avalon-framework-4.2,jeuclid-core
		java-pkg_jar-from xmlgraphics-commons-2,commons-io-1
		java-pkg_jar-from jogl-2.2 jogl-all.jar jogl2.jar
		java-pkg_jar-from gluegen-2.2 gluegen-rt.jar gluegen2-rt.jar
		java-pkg_jar-from fop fop.jar
		java-pkg_jar-from javahelp jhall.jar
		java-pkg_jar-from jlatexmath-fop-1
		use xcos &&	java-pkg_jar-from jgraphx-2.5
		if use doc; then
			java-pkg_jar-from --build-only batik-1.8 batik-all.jar
			java-pkg_jar-from --build-only saxon-9 saxon.jar saxon9he.jar
			java-pkg_jar-from --build-only xml-commons-external-1.4 xml-apis-ext.jar
		fi
	fi
	if use emf; then
		java-pkg_jar-from freehep-graphicsio-emf,freehep-graphics2d
		java-pkg_jar-from freehep-graphicsio,freehep-io,freehep-util
	fi
	if use test; then
		java-pkg_jar-from junit-4 junit.jar junit4.jar
		java-pkg_jar-from ant-junit
	fi
	popd

	java-pkg-opt-2_src_prepare
	eautoconf
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

	econf \
		--enable-relocatable \
		--disable-rpath \
		--with-docbook="${EPREFIX}/usr/share/sgml/docbook/xsl-stylesheets" \
		--disable-static-system-lib \
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
		$(use_with emf) \
		$(use_with fftw) \
		$(use_with gui) \
		$(use_with gui javasci) \
		$(use_with matio) \
		$(use_with openmp) \
		$(use_with tk) \
		$(use_with umfpack) \
		$(use_with xcos) \
		$(use_with xcos modelica) \
		$(use_with mpi)
}

src_compile() {
	addpredict /proc/mtrr
	default
	pax-mark m .libs/scilab-bin
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
	prune_libtool_files --all
	rm -rf "${D}"/usr/share/scilab/modules/*/tests ||die
	use bash-completion && newbashcomp "${FILESDIR}"/"${PN}".bash_completion "${PN}"
	echo "SEARCH_DIRS_MASK=${EPREFIX}/usr/$(get_libdir)/scilab" \
		> 50-"${PN}"
	insinto /etc/revdep-rebuild && doins "50-${PN}"
}

pkg_postinst() {
	fdo-mime_mime_database_update
	einfo "If you are using the NVIDIA binary drivers, and run into graphics"
	einfo "crashes, you may try to run scilab as follows:"
	einfo "EGL_DRIVER=egl_glx scilab"
	einfo "See upstream http://bugzilla.scilab.org/show_bug.cgi?id=12940"
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
