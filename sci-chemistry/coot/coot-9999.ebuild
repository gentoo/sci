# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools base versionator subversion

MY_S2_PV=$(replace_version_separator 2 - ${PV})
MY_S2_P=${PN}-${MY_S2_PV/pre1/pre-1}
MY_S_P=${MY_S2_P}-${PR/r/revision-}
MY_PV=${PV}
MY_P=${PN}-${MY_PV}

ESVN_REPO_URI="http://coot.googlecode.com/svn/trunk"

DESCRIPTION="Crystallographic Object-Oriented Toolkit for model building, completion and validation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~emsley/coot/"
#if [[ ${MY_PV} = *pre* ]]; then
#	SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/pre-release/${MY_S_P}.tar.gz"
#else
#	SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/${MY_P}.tar.gz"
#fi
SRC_URI=""

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/gtkglext
	virtual/glut
	dev-lang/python
	>=x11-libs/gtk+-2.2
	gnome-base/libgnomecanvas
	dev-python/pygtk
	gnome-base/librsvg
	=x11-libs/guile-gtk-2.1
	dev-scheme/guile-gui
	dev-scheme/net-http
	dev-scheme/goosh
	dev-scheme/guile-www
	>=dev-scheme/guile-lib-0.1.6
	>=sci-libs/gsl-1.3
	>=sci-libs/coot-data-2
	sci-chemistry/reduce
	sci-chemistry/refmac
	sci-chemistry/probe
	>=sci-libs/ccp4-libs-6.1
	>=sci-libs/clipper-20090520
	>=dev-libs/gmp-4.2.2-r2"
DEPEND="${RDEPEND}
	dev-lang/swig"

#S="${WORKDIR}/${MY_P}"
S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${PV}-as-needed.patch
	"${FILESDIR}"/${PV}-check.patch
	"${FILESDIR}"/link-against-guile-gtk-properly.patch
	"${FILESDIR}"/fix-namespace-error.patch
	)

src_prepare() {
	base_src_prepare

	# Link against single-precision fftw
	sed -i \
		-e "s:lfftw:lsfftw:g" \
		-e "s:lrfftw:lsrfftw:g" \
		"${S}"/macros/clipper.m4

	# Fix where it looks for some binaries
	sed -i \
		-e "s:/y/people/emsley/coot/Linux/bin/probe.2.11.050121.linux.RH9:/usr/bin/probe:g" \
		-e "s:/y/people/emsley/coot/Linux/bin/reduce.2.21.030604:/usr/bin/reduce:g" \
		"${S}"/scheme/group-settings.scm

	# So we don't need to depend on crazy old gtk and friends
	cp "${FILESDIR}"/*.m4 "${S}"/macros/

	cat >> src/svn-revision.cc <<- EOF
	extern "C" {
	int svn_revision() {
		return  ${ESVN_WC_REVISION};
	}
	}

	EOF

	eautoreconf
}

src_configure() {
	# All the --with's are used to activate various parts.
	# Yes, this is broken behavior.
	econf \
		--includedir='${prefix}/include/coot' \
		--with-gtkcanvas-prefix=/usr \
		--with-clipper-prefix=/usr \
		--with-mmdb-prefix=/usr \
		--with-ssmlib-prefix=/usr \
		--with-guile \
		--with-python=/usr \
		--with-guile-gtk \
		--with-gtk2 \
		--with-pygtk \
		|| die "econf failed"
}

src_compile() {
	# Regenerate wrappers, otherwise at least gtk-2 build fails
	pushd src
	rm -f coot_wrap_python.cc coot_wrap_python_pre.cc \
		&& emake coot_wrap_python.cc \
		|| die "failed to regenerate python wrapper"

	rm -f coot_wrap_guile.cc coot_wrap_guile_pre.cc \
		&& emake coot_wrap_guile.cc \
		||die "failed to regenerate guile wrapper"
	popd

	emake || die "emake failed"
}

src_test() {
	cp "${S}"/src/coot.py python
	export COOT_PYTHON_DIR=${S}/python
	export PYTHONPATH=$COOT_PYTHON_DIR
	export PYTHONHOME=/usr

	cat << EOF > command-line-greg.scm
   (use-modules (ice-9 greg))
         (set! greg-tools (list "greg-tests"))
         (set! greg-debug #t)
         (set! greg-verbose 5)
         (let ((r (greg-test-run)))
            (if r
	        (coot-real-exit 0)
	        (coot-real-exit 1)))
EOF


	${S}/src/coot-real --no-graphics --script command-line-greg.scm


#	emake check || die
}
src_install() {
	base_src_install

	# Install misses this
	insinto /usr/share/coot/python
	doins "${S}"/src/coot.py
}
