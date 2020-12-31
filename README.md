# The [Gentoo Science Project](https://wiki.gentoo.org/wiki/Project:Science) Repository    
[![pkgcheck](https://github.com/gentoo/sci/workflows/pkgcheck/badge.svg)](https://github.com/gentoo/sci/actions?query=workflow%3Apkgcheck)
[![repoman](https://github.com/gentoo/sci/workflows/repoman/badge.svg)](https://github.com/gentoo/sci/actions?query=workflow%3Arepoman)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/gentoo/sci#guide)
[![chat on freenode](https://img.shields.io/badge/chat-on%20freenode-brightgreen.svg)](https://webchat.freenode.net/#gentoo-science)

<table>
<tr>
<td width="69%">

**This is an official mirror of the Gentoo Science Projects [ebuild repository](https://wiki.gentoo.org/wiki/Ebuild_repository) which provides numerous scientific software packages.**

The Gentoo [developer manual](https://devmanual.gentoo.org/) take precedence over any information here.

*See [Project:Science](https://wiki.gentoo.org/wiki/Project:Science) for more information on the project.*

</td>
<td width="27%" style="border-style:solid; border-radius:10px;">

### Contents

1. [Installation and usage](#install)
  - [Manual](#install-manual)
  - [Layman](#install-layman)
2. [Contributor guidelines](#guide)

</td>
</tr>
</table>

## Install <a name="install"></a>

### Manual install <a name="install-manual"></a>

As per the current [Portage specifications](https://dev.gentoo.org/~zmedico/portage/doc/man/portage.5.html), ebuild repositories (a.k.a. overlays) can be managed via file collections under `/etc/portage/repos.conf/`, via the new [plug-in sync system](https://wiki.gentoo.org/wiki/Project:Portage/Sync).

To enable our overlay without the need for additional software, you first need to have **git(1)** installed:

```
emerge --ask --verbose dev-vcs/git 
````

Then you can add the custom entry for the science repository by downloading the [science.conf](metadata/science.conf) file

```
wget https://gitweb.gentoo.org/proj/sci.git/plain/metadata/science.conf \
	-O /etc/portage/repos.conf/science
```

To start using the overlay you now only need to sync the overlay, via 

```
emaint sync --repo science
```

or the traditional 

```
emerge --sync
```

### Manual uninstall

To uninstall the overlay simply run:

```
rm /etc/portage/repos.conf/science
rm /var/db/repos/science -rf
```

### Layman install <a name="install-layman"></a>

You can also install the overlay via the [layman](https://wiki.gentoo.org/wiki/Layman) overlay manager

```
layman --add science
```

### Layman uninstall

To delete the overlay run

```
layman --delete science
```

### Using packages from ::science

To enable the packges from `::science` you need to make sure that you are accepting the `~${ARCH}` keywords for your respective arch.

Make sure that the  `/etc/portage/package.accept_keywords/` folder exists and run

```
printf '*/*::science ~%s' "$(portageq envvar ARCH)" >> /etc/portage/package.accept_keywords/SCIENCE
```

## Generic guidelines for contributors <a name="guide"></a>

If you fork, we will merge!   
We are always going to welcome new contributors and love expanding our collection.   

For basic guidelines please see our [contributing guide](CONTRIBUTING.md).


The [GURU Project](https://wiki.gentoo.org/wiki/Project:GURU) has created excellent documentation for potential contributors.   
We highly advise you to give them a read along with other general Gentoo guidelines
- GURU guidelines - https://wiki.gentoo.org/wiki/Project:GURU#The_regulations
- Contributing to Gentoo - https://wiki.gentoo.org/wiki/Contributing_to_Gentoo
- Gentoo Developers Manual - https://devmanual.gentoo.org/

In addition to the above guidelines please make sure that if you submitting a new package, please add the Science Project as an additional maintainer to the package.   
For an example, take a look at the metadata for the [Numba](dev-python/numba) package - [dev-python/numba/metadata.xml](dev-python/numba/metadata.xml)

## Support

You can ask for help on [Freenode IRC](https://www.gentoo.org/get-involved/irc-channels/) in [**#gentoo-science**](http://webchat.freenode.net/?channels=gentoo-science).   
Alternatively you can report bugs on the [GitHub issues page](https://github.com/gentoo/sci/issues).
