# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libhtmlparse/libhtmlparse-0.1.12.ebuild,v 1.6 2005/02/11 11:55:43 ka0ttic Exp $

DESCRIPTION="libhtmlparse is a HTML parsing library. It takes HTML tags, text, etc and calls callbacks you define for each type of token in the document."
HOMEPAGE="http://msalem.translator.cx/libhtmlparse.html"
SRC_URI="http://msalem.translator.cx/dist/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS COPYING INSTALL ChangeLog NEWS README TODO
}
