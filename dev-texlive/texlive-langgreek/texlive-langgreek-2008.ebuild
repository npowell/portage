# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langgreek/texlive-langgreek-2008.ebuild,v 1.1 2008/09/09 16:37:17 aballier Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-basic
"
TEXLIVE_MODULE_CONTENTS="betababel cbfonts gfsbaskerville gfsporson greek-inputenc greekdates greektex grverb ibycus-babel ibygrk kdgreek kerkis levy lgreek teubner xgreek yannisgr hyphen-greek hyphen-ancientgreek collection-langgreek
"
TEXLIVE_MODULE_DOC_CONTENTS="betababel.doc cbfonts.doc gfsbaskerville.doc gfsporson.doc greek-inputenc.doc greekdates.doc greektex.doc grverb.doc ibycus-babel.doc ibygrk.doc kdgreek.doc kerkis.doc levy.doc lgreek.doc teubner.doc xgreek.doc yannisgr.doc "
TEXLIVE_MODULE_SRC_CONTENTS="greekdates.source grverb.source ibycus-babel.source kdgreek.source teubner.source xgreek.source "
inherit texlive-module
DESCRIPTION="TeXLive Greek"

LICENSE="GPL-2 freedist GPL-1 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""
