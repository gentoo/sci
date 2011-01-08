#
# Unix/Linux GCC Makefile for Levenberg - Marquardt minimization
# Under windows, use Makefile.vc for MSVC
#

CONFIGFLAGS=#-ULINSOLVERS_RETAIN_MEMORY
#ARCHFLAGS=-march=pentium4 # YOU MIGHT WANT TO UNCOMMENT THIS FOR P4
LIBOBJS=lm.o Axb.o misc.o lmlec.o lmbc.o lmblec.o lmbleic.o
LIBSRCS=lm.c Axb.c misc.c lmlec.c lmbc.c lmblec.c lmbleic.c
DEMOBJS=lmdemo.o
DEMOSRCS=lmdemo.c
AR=ar
RANLIB=ranlib

LIBS=$(LAPACKLIBS)

all: liblevmar.a lmdemo

liblevmar.a: $(LIBOBJS)
	$(AR) crv liblevmar.a $(LIBOBJS)
	$(RANLIB) liblevmar.a

lmdemo: $(DEMOBJS) liblevmar.a
	$(CC) $(LDFLAGS) $(DEMOBJS) -o lmdemo liblevmar.a $(LIBS) -lm

lm.o: lm.c lm_core.c levmar.h misc.h compiler.h
Axb.o: Axb.c Axb_core.c levmar.h misc.h
misc.o: misc.c misc_core.c levmar.h misc.h
lmlec.o: lmlec.c lmlec_core.c levmar.h misc.h
lmbc.o: lmbc.c lmbc_core.c levmar.h misc.h compiler.h
lmblec.o: lmblec.c lmblec_core.c levmar.h misc.h
lmbleic.o: lmbleic.c lmbleic_core.c levmar.h misc.h

lmdemo.o: levmar.h

clean:
	@rm -f $(LIBOBJS) $(DEMOBJS)

cleanall: clean
	@rm -f lmdemo
	@rm -f liblevmar.a

depend:
	makedepend -f Makefile $(LIBSRCS) $(DEMOSRCS)

# DO NOT DELETE THIS LINE -- make depend depends on it.

