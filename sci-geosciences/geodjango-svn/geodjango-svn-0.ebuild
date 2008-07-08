# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion bash-completion distutils eutils

DESCRIPTION="GeoDjango supplies a geographic web framework within Django."
HOMEPAGE="http://code.djangoproject.com/wiki/GeoDjango"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples sqlite test"

DEPEND="dev-python/imaging
	sqlite? ( || (
		( >=dev-python/pysqlite-2.0.3 <dev-lang/python-2.5 )
		>=dev-lang/python-2.5 ) )
	test? ( || (
		( >=dev-python/pysqlite-2.0.3 <dev-lang/python-2.5 )
		>=dev-lang/python-2.5 ) )
	!dev-python/django
	>=dev-python/psycopg-2.0.7
	>=dev-db/postgis-1.3.3
	>=sci-libs/geos-3.0.0
	>=sci-libs/proj-4.5.0
	>=sci-libs/gdal-1.4.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/django_gis"

DOCS="docs/* AUTHORS"

src_unpack() {
	ESVN_REPO_URI="http://code.djangoproject.com/svn/django/branches/gis"
	ESVN_PROJECT="django_gis"
	subversion_src_unpack
}


src_test() {
	cat >> tests/settings.py << __EOF__
DATABASE_ENGINE='sqlite3'
ROOT_URLCONF='tests/urls.py'
SITE_ID=1
__EOF__
	PYTHONPATH="." ${python} tests/runtests.py --settings=settings -v1 || die "tests failed"
}


src_install() {
	distutils_python_version

	site_pkgs="/usr/$(get_libdir)/python${PYVER}/site-packages/"
	export PYTHONPATH="${PYTHONPATH}:${D}/${site_pkgs}"
	dodir ${site_pkgs}

	distutils_src_install

	dobashcompletion extras/django_bash_completion

	if use examples ; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
