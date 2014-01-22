#Contributions to the Gentoo Science Overlay

----
##Prerequisite

###Requiered

* Everybody who wants to contribute should own an account at [github](https://github.com/join). Please register yourself there.

###Recommended
* **Define echangelog user**

Make sure the ECHANGELOG_USER variable is present in your environment.

    echo 'export ECHANGELOG_USER="John Smith <john@smith.com>"' >> ~/.bashrc

###Optional
* **Setup commit signing**

Create a [gpg key](http://www.gossamer-threads.com/lists/gentoo/dev/268496?do=post_view_threaded) if you don't have one already and make git use it.

    git config --global user.signingkey <gpg-key-id>


* **Install [hub](http://hub.github.com/)**, the "command-line wrapper for git that makes you better at GitHub".

This file will use *hub* because of it's convenience when working with github.

    emerge dev-vcs/hub


----
##For Contributors


First clone the overlay

    hub clone gentoo-science/sci


    cd sci


It is always convenient for development as well as for the review and merging process, if the development is done in branches.

    git checkout -b my-feature master

Now you can work on you package of interest. Once you are finished you should _always_ use **[repoman](http://dev.gentoo.org/~zmedico/portage/doc/man/repoman.1.html)** to check, verify and commit your changes.

Static analysis can be done with

    repoman full

Once *all* reported problems are resolved, you can commit it

    echangelog "Here we write a comprehensible ChangeLog message"
    repoman -m "Here we write a comprehensible commit message" commit



----
##For Maintainers


---
This document is available under [Creative Commons Attribution ShareAlike 4.0](http://creativecommons.org/licenses/by-sa/4.0)

![ccsa-4 icon](http://i.creativecommons.org/l/by-sa/4.0/88x31.png)