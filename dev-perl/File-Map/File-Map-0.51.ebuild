# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PDL/PDL-2.4.7.ebuild,v 1.3 2010/08/23 13:39:54 tove Exp $

MODULE_AUTHOR="LEONT"

inherit perl-module

DESCRIPTION="Memory mapping made simple and safe."

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Const-Fast
	dev-perl/PerlIO-Layers
	dev-perl/Sub-Exporter"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	test? (
			dev-perl/Test-Exception
			dev-perl/Test-NoWarnings
			dev-perl/Test-Warn
		   )"
