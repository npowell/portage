# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pytables/pytables-1.4.ebuild,v 1.3 2008/02/23 13:21:09 dev-zero Exp $

NEED_PYTHON="2.2"

inherit distutils

DESCRIPTION="Module for Python that use HDF5"
SRC_URI="mirror://sourceforge/pytables/${P}.tar.gz"
HOMEPAGE="http://pytables.sourceforge.net/"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
LICENSE="BSD"
IUSE="doc examples"

DEPEND="sci-libs/hdf5
	>=dev-python/numarray-1.5.2"
RDEPEND="${DEPEND}"

src_install() {
	DOCS="ANNOUNCE.txt RELEASE-NOTES.txt THANKS TODO.txt VERSION"

	distutils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	if use doc; then
		cd doc

		dohtml -r html/*

		docinto text
		dodoc text/*

		insinto /usr/share/doc/${PF}
		doins -r usersguide.pdf scripts/
	fi
}

src_test() {
	python_version
	"${python}" setup.py install --root="${T}" --no-compile "$@" || die "temporary install failed"
	PYTHONPATH="${T}/usr/$(get_libdir)/python${PYVER}/site-packages" "${python}" tables/tests/test_all.py || die "tests failed"
}
