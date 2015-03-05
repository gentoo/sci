#NeuroGentoo Overlay

A fork of the science overlay, augmenting the Gentoo ecosystem with neuroscience ebuilds.
This is the core of the NeuroGentoo initiative, documented in some greater length on [Chymeric Tutorials](http://chymeric.eu/blog/2013/10/02/neurogentoo/).
This overlay helps you get neuroscience software not (yet) provided by [Gentoo Science](http://wiki.gentoo.org/wiki/Project:Science/Overlay).

Our overlays are functional, though experimental, and often bundled with cruft from upstream - but we are *fast*:
Our users have been able to get working AFNI and FSL distributions since 2013 - now, over 2 years later, these programs are still not available on Gentoo Science, or any other overlay for that matter.

##Install

As per the [corrent portage specifications](https://dev.gentoo.org/~zmedico/portage/doc/man/portage.5.html) overlays should be managed via `/etc/portage/repos.conf/`.
To enable our overlay make sure you are using a recent portage version (at least `2.2.14`), and add crate an `/etc/portage/repos.conf/neurogentoo` file containing precisely:

```
[neurogentoo]
location = /usr/local/portage/neurogentoo
sync-type = git
sync-uri = https://github.com/TheChymera/neurogentoo.git
priority=8888
```

---
Please fork! We will merge! See [this](https://github.com/gentoo-science/sci/blob/master/CONTRIBUTING.md) document for more instructions.

Ask for help on irc in #gentoo-science @ freenode.

Report bugs on the [github issues site](https://github.com/gentoo-science/sci/issues)
