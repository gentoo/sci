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


In order to send pull request and ask for inclusion of your changes you need to have your own fork of the overlay on github. You can do this by

    cd sci
    hub fork

Now you are ready to start your work.

It is always convenient for development as well as for the review and merging process, if the development is done in branches.

    git checkout -b my-feature master

Now you can work on you package of interest. Once you are finished you should _always_ use **[repoman](http://dev.gentoo.org/~zmedico/portage/doc/man/repoman.1.html)** to check, verify and commit your changes.

Static analysis can be done with

    repoman full

Once *all* reported problems are resolved, you can commit it

    echangelog "Here we write a comprehensible ChangeLog message"
    repoman -m "Here we write a comprehensible commit message" commit

Next we push back the changes to our fork and send a pull-request to the overlay maintainers.

    hub push YOUR_GITHUB_USER
    hub pull-request

Lastly you need to wait for review comments and the merge of your work. In case you need to include some improvements, just commit your work again using repoman and push it again to your fork.

----
##For Maintainers

**The merging of pull request should only be done by gentoo developers.**

If you feel that they are slacking, don't bother to ping them again.

###Prerequisite

Make sure you have both repos (github & gentoo.org) as remotes defined.

    git remote -v

should give

> github	git@github.com:gentoo-science/sci.git (fetch)
>
> github	git@github.com:gentoo-science/sci.git (push)
>
> origin	git+ssh://git@git.overlays.gentoo.org/proj/sci.git (fetch)
>
> origin	git+ssh://git@git.overlays.gentoo.org/proj/sci.git (push)

In the beginning you should review the pull request on github directly and recommend as much improvements as possible. Once everything is fine or you like to fix the rest yourself, you can use the follow command to get the pull-request in a new branch in you repo.

    hub checkout https://github.com/gentoo-science/sci/pull/176

Now check the package by building and installing it, and run *repoman* in the package dir. If this is also fine, merge the branch into the master

    git checkout master
    git merge USER-BRANCH

Finally use the script **merge-dualHEAD** from the *scripts* directory to merge the github and gentoo.org remote repo.


---
####.
This document is available under [Creative Commons Attribution ShareAlike 4.0](http://creativecommons.org/licenses/by-sa/4.0)

![ccsa-4 icon](http://i.creativecommons.org/l/by-sa/4.0/88x31.png)
