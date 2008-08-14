# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/gnat/gnat-3.4.ebuild,v 1.5 2007/05/27 18:13:59 george Exp $

DESCRIPTION="Virtual for the gnat compiler selection"
HOMEPAGE="http://www.gentoo.org/proj/en/glep/glep-0037.html"
SRC_URI=""
LICENSE="GMGPL"
SLOT="3.4"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="|| (
	=dev-lang/gnat-gcc-3.4*
	=dev-lang/gnat-gpl-3.4* )"
DEPEND=""
