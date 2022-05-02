# Contributions to the Gentoo Science Overlay

This guide summarizes the contribution and merging procedures for the Gentoo Science overlay on Github. For more information please visit the [Science Project page](https://wiki.gentoo.org/wiki/Project:Science/Contributing) in the [Gentoo wiki](https://wiki.gentoo.org/).

----
## Prerequisite
For the most convenient way to work with the overlay you should fulfill all prerequisites.

### Required

* **Install git**

The Science overlay is controlled by [git](http://git-scm.com/). You can install it with

    emerge dev-vcs/git

Familiarize yourself with git and visit [http://git-scm.com/documentation](http://git-scm.com/documentation) for documentation.

* **Account at [github](https://github.com/join)**

Everybody who wants to contribute needs to own an account @ [Github](http://github.com/). Please register yourself [there](https://github.com/join).

### Recommended
* **Define the echangelog user**

Make sure the ECHANGELOG_USER variable is present in your environment.

    echo 'export ECHANGELOG_USER="John Smith <john@smith.com>"' >> ~/.bashrc

### Optional
* **Setup commit signing**

Create a [gpg key](http://www.gossamer-threads.com/lists/gentoo/dev/268496?do=post_view_threaded) if you don't have one already and make git use it.

    git config --global user.signingkey <gpg-key-id>

Now git will sign your commits to the overlay by using the gpg key.

* **Install [pkgdev](https://github.com/pkgcore/pkgdev)**, *A repository commit helper*

*pkgdev* sanitizes your commit in a convenient way and runs QA checks.

    emerge dev-util/pkgdev

---
## Contributing ebuilds

### Fork the overlay
In order to send pull request and ask for inclusion of your changes you need to have your own fork of the overlay on github. You can do this by clicking the "Fork" button in the top right of our GitHub page.

### Clone the overlay

Create a local checkout of your fork, where `USERNAME` is your GitHub username.

    git clone git@github.com:USERNAME/sci.git

To conveniently update your fork later, add the main repository as a second remote

    git remote add upstream git@github.com:gentoo/sci.git

### Branch out for contribution
It is always convenient for development as well as for the review and merging process, if the development is done in branches. Let's branch the overlay into a local branch named PACKAGE_NAME.

    git checkout -b PACKAGE_NAME master

For the fastest process during merging it is best to have a single branch per package.

### Work on the package
Now you are ready to work on your package of interest. Once you are finished you should _always_ use **[pkgcheck](https://pkgcore.github.io/pkgcheck/man/pkgcheck.html)** to do a static analysis of your work.

This can be done with

    pkgcheck scan --net

### Commit your work
Once *all* reported problems are resolved, you can commit it

    pkgdev commit --all

### Push to GitHub and make a pull request
In order to facilitate potential reverts of mistakes, we prefer to keep the git history as linear as possible. For this, always rebase your changes on the latest remote changes.

    git pull --rebase=merges upstream master

Next we push back the changes in the PACKAGE_NAME branch to our fork.

    pkgdev push YOUR_GITHUB_USER PACKAGE_NAME

Now we are ready to create a Pull Request, go to your GitHub fork and press "Contribute" --> "Open pull request".

Lastly you need to wait for review comments and the merge of your work. If you feel that they are slacking, don't hesitate to ping them again. In case you need to include some improvements, just commit your work again using `pkgdev commit` and push it again to your fork. No need to send another pull-request as your new changes will be added to the original one.

### What's next?
If you would like to get direct access to the overlay, prove some contribution and ping us via sci@gentoo.org or on irc in #gentoo-science @ Libera. If you would like to become a dev yourself, prove some more contributions and again, contact us. We are always looking for new candidates.

----
## Ebuild recommendations
As the Gentoo Science overlay is a constant work-in-progress, we have some recommendations for prospective contributors:

* **Aim for writing EAPI=8 ebuilds.** For certain eclasses, `EAPI=8` is not allowed yet. In such cases you may use `EAPI=7`. We will not accept `EAPI<=6` ebuilds.
* **Version bumps should always follow the latest guidelines.** For instance, a version bump of an ebuild that still employs autotools-utils.eclass should be avoided. Instead, drop 'autotools-utils', move to 'autotools' and call `default` followed by `eautoreconf` in src_prepare().

----
## Merging contributions

**It is important, that if you merge a pull request, you should feel as responsible as if you have written the commits yourself!**

### Prerequisite

Install `app-portage/pram`

### Review process

In the beginning you should review the pull request on GitHub directly and recommend as much improvements as possible. By this you train the new contributor towards becoming a new dev, which should be our final goal.

#### Checking out the pull-request as local branch
Once everything is fine or you like to fix the rest yourself, simply use the following command to get the pull-request in a new branch in your repo.

    pram -r gentoo/sci PULLREQUEST-NUMBER

#### Testing and pkgcheck check
Now check the package by building and installing it, and run *pkgcheck* in the package directory. Remember, when merging a pull request you take the responsibility for the quality of the commit.

---
#### Contribution to the document
Sebastien Fabbro <bicatali@gentoo.org>

Justin Lecher <jlec@gentoo.org>

This document is available under [Creative Commons Attribution ShareAlike 4.0](http://creativecommons.org/licenses/by-sa/4.0)

![ccsa-4 icon](http://i.creativecommons.org/l/by-sa/4.0/88x31.png)
