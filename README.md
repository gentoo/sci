# The [Gentoo Science Project](https://wiki.gentoo.org/wiki/Project:Science) Repository    
[![pkgcheck](https://github.com/gentoo/sci/workflows/pkgcheck/badge.svg)](https://github.com/gentoo/sci/actions?query=workflow%3Apkgcheck)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg)](https://github.com/gentoo/sci#guide)
[![chat on libera](https://img.shields.io/badge/chat-on%20libera-brightgreen.svg)](https://web.libera.chat/#gentoo-science)

<table>
<tr>
<td width="69%">

**This is an official mirror of the Gentoo Science [ebuild repository](https://wiki.gentoo.org/wiki/Ebuild_repository), containing numerous scientific software packages.**

*See [Project:Science](https://wiki.gentoo.org/wiki/Project:Science) for more information on the project.*

</td>
<td width="27%" style="border-style:solid; border-radius:10px;">

### Contents

1. [Installation](#install)
  - [Eselect](#install-eselect)
  - [Manual](#install-manual)
  - [Layman](#install-layman)
2. [Usage](#usage)
3. [Contributing](#contributing)

</td>
</tr>
</table>

## Installation <a name="install"></a>

As per the current [Portage specification](https://dev.gentoo.org/~zmedico/portage/doc/man/portage.5.html), ebuild repositories (a.k.a. overlays) can be managed via file collections under `/etc/portage/repos.conf/`, via the new [plug-in sync system](https://wiki.gentoo.org/wiki/Project:Portage/Sync).

### Eselect-repository Install <a name="install-eselect"></a>

The overlay can be enabled via the `repository` extension of the Gentoo `eselect` utility.

```console
emerge --ask --noreplace --verbose eselect-repository
eselect repository enable science
```

### Eselect-repository Uninstall

To disable and remove the overlay, run:

```console
eselect repository disable science
eselect repository remove science
```

### Manual Install <a name="install-manual"></a>

To enable the overlay without the need for dedicated repository software, you need to have `git` installed:

```console
emerge --ask --noreplace --verbose dev-vcs/git
````

Then you can simply download the science repository configuration file, [science.conf](metadata/science.conf):

```console
wget https://gitweb.gentoo.org/proj/sci.git/plain/metadata/science.conf \
	-O /etc/portage/repos.conf/science
```

### Manual Uninstall

To disable and remove the overlay, run:

```console
rm /etc/portage/repos.conf/science
rm /var/db/repos/science -rf
```

### Layman Install <a name="install-layman"></a>

You can also install the overlay via the [layman](https://wiki.gentoo.org/wiki/Layman) overlay manager.

```console
emerge --ask --noreplace --verbose app-portage/layman
layman --add science
```

### Layman Uninstall

To delete the overlay, run:

```console
layman --delete science
```

### Using Packages from `::science`

To start using the overlay you now only need to get the newest files, via:

```console
emerge --sync science
```

To be able to install `::science` packages you need to make sure that you are accepting the `~${ARCH}` keyword for your respective architecture. This may already be the case globally on your system, and you can check whether this is the case by running:

```console
grep "~$(portageq envvar ARCH)" /etc/portage/make.conf
```

If the above returns empty, you will need to instruct Portage to accept `~${ARCH}` packages.

This can be done for `::science` specifically:

```console
mkdir -p /etc/portage/package.accept_keywords
printf '*/*::science ~%s' "$(portageq envvar ARCH)" >> /etc/portage/package.accept_keywords/science
```

If the above fails with `mkdir: cannot create directory ‘/etc/portage/package.accept_keywords’: File exists` this means you are using a file and not a directory, and you can instead run:

```console
printf '*/*::science ~%s' "$(portageq envvar ARCH)" >> /etc/portage/package.accept_keywords
```

Alternatively, and *only if you know what you are doing*, you can accept `~${ARCH}` packages globally:

```console
printf 'ACCEPT_KEYWORDS="~%s"' "$(portageq envvar ARCH)" >> /etc/portage/make.conf
```

The downside of this approach is potentially higher instability, the advantage is that often `::science` packages require `~${ARCH}` packages from `::gentoo` as well.


## Contributing <a name="contributing"></a>

*If you fork, we will merge!*   
We welcome new contributors and are happy to include new packages.

### Areas to contribute

- [Current open bugs](https://bugs.gentoo.org/buglist.cgi?no_redirect=1&quicksearch=[science+overlay])

### Resources

For a brief introduction please see our [contributing guide](CONTRIBUTING.md). Further helpful resources are:

- Gentoo Developers Manual - https://devmanual.gentoo.org/ (taking precedence over any other information found here)
- Contributing to Gentoo - https://wiki.gentoo.org/wiki/Contributing_to_Gentoo

Additionally, please make sure to add the Science Project as an additional maintainer to any new packages you submit. For an example, take a look at the metadata for the [Numba](dev-python/numba) package - [dev-python/numba/metadata.xml](dev-python/numba/metadata.xml)

## Support

You can ask for help on [Libera IRC](https://www.gentoo.org/get-involved/irc-channels/) in [**#gentoo-science**](https://web.libera.chat/#gentoo-science).
Alternatively you can report bugs on the [Gentoo Bugzilla](https://bugs.gentoo.org/).
