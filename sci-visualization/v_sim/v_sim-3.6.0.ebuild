# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="Displays atomic structures such as crystals, gain boudaries, molecules"
HOMEPAGE="http://www-drfmc.cea.fr/sp2m/L_Sim/V_Sim/index.en.html"
SRC_URI="http://www-drfmc.cea.fr/sp2m/L_Sim/V_Sim/download/${P}.tar.bz2"

LICENSE="CeCILL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# doc:   Adds developer documentation (/usr/share/doc/${PF}/APIreference/)
#        Example files are copied even when USE='-doc'
# debug: Adds console debug messages. This is really verbose.
IUSE="abinit blas cube debug doc netcdf openbabel xsf"

RDEPEND="
	x11-libs/gtk+:2
	dev-libs/glib:2
	x11-libs/pango
	media-libs/libpng:0=
	virtual/opengl"
DEPEND="${RDEPEND}
	abinit? ( sci-physics/abinit sci-libs/etsf_io )
	blas? ( virtual/blas )
	netcdf? ( sci-libs/netcdf )
	openbabel? ( sci-chemistry/openbabel )
	doc?  ( >=dev-util/gtk-doc-1.4-r1 )"

src_prepare() {
	# The author follows Debian conventions, hence the example files and docs
	# end up in /usr/share/doc/${PN} instead of /usr/share/doc/${PF}. We
	# correct this here.
	sed -i -e "s@/doc/.\${package}.@/doc/${PF}@g" -e "s@/doc/\$PACKAGE@/doc/${PF}@g" configure \
		|| die "sed failed on tweaking configure file"
	# TODO: test if this can be done via --docdir

	# The /share/ directories are #define in the code and must be adapted.
	sed -i -e "s:/usr/local/:/usr/:g" src/visu_basic.c || die "sed failed on updating directories in visu_basic.c"
}

src_configure() {
	if use doc ; then
		gtkdocize || die
	fi
	local MY_CONF="--without-etsf-io"
	use abinit && MY_CONF="--with-etsf-io=/usr --with-etsf-io-include=/usr/lib/finclude --with-etsf-io-libdir=/usr/$(get_libdir)"
	econf "${MY_CONF}" \
		$(use_with blas) \
		$(use_with cube) \
		$(use_with netcdf) \
		$(use_with openbabel) \
		$(use_with xsf) \
		$(use_enable doc gtk-doc) \
		$(use_enable debug debug-messages)
}

src_compile() {
	HOME="${S}" emake
}

pkg_postinst() {
	einfo "Example files are in /usr/share/doc/${PF}/examples"
	einfo "(even with USE='-doc')"
	einfo ""
	einfo "The global v_sim config files are in /usr/share/${PN}/"
	einfo "There are a few options which can only be configured in these files"
	einfo "and not through the UI. For example, one can specify different"
	einfo "colors for the box and the axes in the files, but in the UI one can"
	einfo "only change them together."
	einfo ""
	einfo "V_sim uses by default its own weird gtk skin. You can edit the"
	einfo "skin settings in /usr/share/${PN}/v_sim.rc"
	einfo "You can change the skin file used in the config file v_sim.par:"
	einfo "Go to the line 'config_skin[gtk]: V_Sim'. The argument may be:"
	einfo "'V_Sim', 'none' or the path to your own rc file. The keyword "
	einfo "'V_Sim' stands for the default rc file, /usr/share/v_sim/v_sim.rc"
	einfo "If you choose 'none' or if you comment the line, your current"
	einfo "gtk skin will be used."
}
