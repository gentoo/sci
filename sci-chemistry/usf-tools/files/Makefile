SUBDIRS = aconio ave cello coma comap comdem crave dataman essens \
findncs flood imp lsqman mama mapfix mapman mappage mave moleman \
moleman2 ncs6d o2d odbman oops oops2 prof seaman site2rt sod solex \
spancsi ssencs voidoo xpand xplo2d

SUBDIRS_MAKERULE = \
        @+for d in $(SUBDIRS) ""; do \
                if test -d "$$d" -a ! -z "$$d"; then \
                        echo === $$d ===; \
                        $(MAKE) -C $$d || exit $$?; \
                fi; \
        done

all: gklib/libkley.so  $(SUBDIRS)
	$(SUBDIRS_MAKERULE)

gklib/libkley.so:
	$(MAKE) -C gklib
