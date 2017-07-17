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

* **Install [hub](http://hub.github.com/)**, the *command-line wrapper for git that makes you better at GitHub*.

*hub* can be used equivalent to to *git* and upstream even recommends *"alias git='hub'*.

    emerge dev-vcs/hub

* **Install [repo-commit](https://bitbucket.org/gentoo/repo-commit/)**, *A repository commit helper*

*repo-commit* sanitizes your commit in a convenient way.

    emerge app-portage/repo-commit

---
## Contributing ebuilds

### Clone the overlay

Create a local checkout of the overlay

    hub clone gentoo-science/sci

### Fork the overlay
In order to send pull request and ask for inclusion of your changes you need to have your own fork of the overlay on github. You can do this by issuing

    cd sci
    hub fork

### Branch out for contribution
It is always convenient for development as well as for the review and merging process, if the development is done in branches. Let's branch the overlay into a local branch named PACKAGE_NAME.

    git checkout -b PACKAGE_NAME master

For the fastest process during merging it is best to have a single branch per package.

### Work on the package
Now you are ready to work on your package of interest. Once you are finished you should _always_ use **[repoman](http://dev.gentoo.org/~zmedico/portage/doc/man/repoman.1.html)** to do a static analysis of your work.

This can be done with

    repoman full

### Commit your work
Once *all* reported problems are resolved, you can commit it

    repo-commit "Here we write a comprehensible commit message"

### Push to Github and make a pull request
In order to facilitate potential reverts of mistakes, we prefer to keep the git history as linear as possible. For this, always rebase your changes on the latest remote changes.

    hub pull --rebase=preserve github master

Next we push back the changes in the PACKAGE_NAME branch to our fork and send a pull-request to the overlay maintainers.

    hub push YOUR_GITHUB_USER PACKAGE_NAME
    hub pull-request

Lastly you need to wait for review comments and the merge of your work. If you feel that they are slacking, don't bother to ping them again. In case you need to include some improvements, just commit your work again using *repo-commit* and push it again to your fork. No need to send another pull-request as your new changes will be added to the original one.

### What's next?
If you would like to get direct access to the overlay, prove some contribution and ping us via sci@gentoo.org or on irc in #gentoo-science @ freenode. If you would like to become a dev yourself, prove some more contributions and again, contact us. We are always looking for new candidates.

----
## Ebuild recommendations
As the Gentoo Science overlay is a constant work-in-progress, we have some recommendations for prospective contributors:

* **Aim for writing EAPI=6 ebuilds.** For certain eclasses, EAPI=6 is not allowed yet. In such cases you may use EAPI=5. We will not accept EAPI<5 ebuilds.
* **Version bumps should always follow the latest guidelines.** For instance, a version bump of an ebuild that still employs autotools-utils.eclass should be avoided. Instead, drop 'autotools-utils', move to 'autotools' and call `default` followed by `eautoreconf` in src_prepare().

----
## Merging contributions

**It is important, that if you merge a pull request, you should feel as responsible as if you have written the commits yourself!**



### Prerequisite

Make sure you have both repos (github & gentoo.org) as remotes defined.

    git remote -v

should give

>github	git@github.com:gentoo-science/sci.git (fetch)
>
>github	git@github.com:gentoo-science/sci.git (push)
>
>origin	git+ssh://git@git.overlays.gentoo.org/proj/sci.git (fetch)
>
>origin	git+ssh://git@git.overlays.gentoo.org/proj/sci.git (push)


### Review process

In the beginning you should review the pull request on github directly and recommend as much improvements as possible. By this you train the new contributor towards becoming a new dev, which should be our final goal.

#### Checking out the pull-request as local branch
Once everything is fine or you like to fix the rest yourself, simply use the following command to get the pull-request in a new branch in your repo.

    hub checkout https://github.com/gentoo-science/sci/pull/PULLREQUEST-NUMBER

#### Testing and repoman check
Now check the package by building and installing it, and run *repoman* in the package dir. Remember, when merging a pull request you take the responsibility for the quality of the commit.

#### Merge the pull-request branch into master
If this is also fine, merge the branch into the master

    git checkout master
    git merge USER-BRANCH

#### Merging the two remote HEADs
Finally use the script **merge-dualHEAD** from the *scripts* directory to merge the github and gentoo.org remote repo.


---
#### Contribution to the document
Sebastien Fabbro <bicatali@gentoo.org>

Justin Lecher <jlec@gentoo.org>

This document is available under [Creative Commons Attribution ShareAlike 4.0](http://creativecommons.org/licenses/by-sa/4.0)

![ccsa-4 icon](http://i.creativecommons.org/l/by-sa/4.0/88x31.png)
