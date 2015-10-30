#NeuroGentoo Overlay

NeuroGentoo is a persistent fork of the science overlay, and augments the Gentoo ecosystem by helping you get neuroscience software not (yet) provided by [Gentoo Science](http://wiki.gentoo.org/wiki/Project:Science/Overlay).
This repository is the cornerstone of the NeuroGentoo initiative, which was first described on [Chymeric Tutorials](http://tutorials.chymera.eu/blog/2013/10/02/neurogentoo/).

Our ebuilds are functional (we use them for our own neuroscience work), though occasionally unstable, and often bundled with cruft from upstream - but we are **fast**:
Our users have - for instance - been able to get working AFNI, SPM and FSL distributions *since 2013*!
SPM and FSL took almost 2 years to get into Gentoo Science, while AFNI is still not available on Gentoo Science - or any other overlay for that matter.
The same holds true for many other packages.

##Install

As per the [current Portage specifications](https://dev.gentoo.org/~zmedico/portage/doc/man/portage.5.html), overlays should be managed via `/etc/portage/repos.conf/`.
To enable our overlay make sure you are using a recent Portage version (at least `2.2.14`), and crate an `/etc/portage/repos.conf/neurogentoo` file containing precisely:

```
[neurogentoo]
location = /usr/local/portage/neurogentoo
sync-type = git
sync-uri = https://github.com/TheChymera/neurogentoo.git
priority=8888
```

Afterwards, simply run `emerge --sync`, and Portage should seamlessly make all our ebuilds available.
Many of our packages are available as live (`*-9999`) ebuilds, and also need manual unmasking in `/etc/portage/package.accept_keywords` before they can be emerged.

---
Please fork! We will merge! See [this](https://github.com/gentoo-science/sci/blob/master/CONTRIBUTING.md) document for more instructions.

Project lead by Horea Christian, please direct all email correspondence to h.chr@mail.ru.

If reporting issues, please check whether the respective neuroscience software is alreay available in Gentoo Science. If so, report [upstream, on Gentoo Science](https://github.com/gentoo-science/sci/issues), and add @TheChymera in the text.
