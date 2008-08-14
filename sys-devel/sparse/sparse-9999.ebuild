# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/sparse/sparse-9999.ebuild,v 1.2 2007/09/17 19:28:20 vapier Exp $

EGIT_REPO_URI="git://git.kernel.org/pub/scm/devel/sparse/sparse.git"
inherit eutils multilib git

DESCRIPTION="C semantic parser"
HOMEPAGE="http://kernel.org/pub/linux/kernel/people/josh/sparse/"
SRC_URI=""

LICENSE="OSL-1.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	git_src_unpack
	cd "${S}"
	sed -i \
		-e '/^PREFIX=/s:=.*:=/usr:' \
		-e "/^LIBDIR=/s:/lib:/$(get_libdir):" \
		Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc FAQ README
}
