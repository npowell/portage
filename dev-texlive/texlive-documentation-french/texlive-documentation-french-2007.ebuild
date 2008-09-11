# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-documentation-french/texlive-documentation-french-2007.ebuild,v 1.16 2008/09/09 18:04:36 aballier Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-documentation-base
"
TEXLIVE_MODULE_CONTENTS="FAQ-fr epslatex-fr impatient-fr l2tabu-french lshort-french texlive-fr collection-documentation-french
"
inherit texlive-module
DESCRIPTION="TeXLive French documentation"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""
