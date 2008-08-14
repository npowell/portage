# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libidmef/libidmef-0.7.2.ebuild,v 1.4 2006/02/08 00:35:43 halcy0n Exp $

DESCRIPTION="Implementation of the IDMEF XML draft"
HOMEPAGE="http://www.silicondefense.com/idwg/libidmef/"
SRC_URI="http://www.silicondefense.com/idwg/libidmef/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/libxml2-2.5.6"

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc API AUTHORS ChangeLog FAQ NEWS README TODO
}
