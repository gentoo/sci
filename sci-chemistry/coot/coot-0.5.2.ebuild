# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

MY_S_PV=${PV}-${PR}
MY_S_P=${PN}-${MY_S_PV}
MY_PV=${PV}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Crystallographic Object-Oriented Toolkit for model building, completion and validation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~emsley/coot/"
if [[ ${MY_PV} = *pre* ]]; then
	SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/pre-release/${MY_S_P}.tar.gz"
else
	SRC_URI="http://www.ysbl.york.ac.uk/~emsley/software/${MY_P}.tar.gz"
fi
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=sci-libs/gsl-1.3
	>=x11-libs/gtk+-2.2
	gnome-base/libgnomecanvas
	=x11-libs/guile-gtk-2.1
	x11-libs/gtkglext
	virtual/glut
	virtual/opengl
	dev-lang/python
	dev-scheme/guile-gui
	dev-scheme/net-http
	dev-scheme/goosh
	dev-scheme/guile-www
	>=dev-scheme/guile-lib-0.1.6
	sci-libs/coot-data
	sci-chemistry/reduce
	sci-chemistry/refmac
	sci-chemistry/probe
	sci-libs/ccp4-libs
	dev-python/pygtk
	gnome-base/librsvg
	>=dev-libs/gmp-4.2.2-r2"
DEPEND="${RDEPEND}
	dev-lang/swig"
S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# To send upstream
	epatch "${FILESDIR}"/${PV}-gcc-4.3.patch

	epatch "${FILESDIR}"/${PV}-as-needed.patch
	epatch "${FILESDIR}"/link-against-guile-gtk-properly.patch
	epatch "${FILESDIR}"/fix-namespace-error.patch

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

	# Look for clipper slotted with '-2' suffix
#	sed -i \
#		-e "s~\(-lclipper[[:alnum:]-]*\)~\1-2~g" \
#		"${S}"/macros/clipper.m4 \
#		|| die "sed to find -2 slotted libraries failed"
#	grep 'include.*clipper' -rl . \
#		| xargs sed -i \
#			-e "s~\(include.*clipper\)/~\1-2/~g" \
#			|| die "sed to find -2 slotted headers failed"

	# So we don't need to depend on crazy old gtk and friends
	cp "${FILESDIR}"/*.m4 "${S}"/macros/

	cd "${S}"
	eautoreconf
}

src_compile() {
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

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	# Install misses this
	insinto /usr/share/coot/python
	doins "${S}"/src/coot.py
}
