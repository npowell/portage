# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-ShareDir/File-ShareDir-1.00.ebuild,v 1.1 2008/09/08 10:27:53 tove Exp $

MODULE_AUTHOR="ADAMK"
inherit perl-module

DESCRIPTION="Locate per-dist and per-module shared files"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/Class-Inspector
	dev-perl/Params-Util"

SRC_TEST="do"

src_install(){
	find "${S}" \( -name "sample.txt" -o -name "test_file.txt" \) -delete
	perl-module_src_install
}
