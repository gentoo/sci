OBJS=bar.o bi.o boe.o bruch.o classical.o de.o di.o ff.o galois.o ga.o gra.o hash.o hiccup.o \
	io.o ko.o list.o lo.o ma.o mee.o mem.o mes.o mhe.o mhh.o mhm.o mhp.o mhs.o mmm.o mms.o \
	mod_dg_sbd.o mo.o mpp.o mps.o mse.o msh.o msm.o mss.o muir.o na.o nb.o nc.o nu.o part.o pee.o \
	peh.o pem.o perm.o pes.o phe.o phh.o phm.o phs.o plet.o pme.o pmh.o poly.o ppe.o pph.o ppm.o \
	ppp.o pps.o pr.o pse.o psh.o psm.o pss.o rest.o rh.o sab.o sb.o sc.o sr.o ta.o teh.o tem.o \
	tep.o tes.o the.o thm.o thp.o ths.o tme.o tmh.o tmp.o tms.o tpe.o tph.o tpm.o tps.o tse.o \
	tsh.o tsm.o tsp.o vc.o zo.o zykelind.o zyk.o
SHOBJS=bar.lo bi.lo boe.lo bruch.lo classical.lo de.lo di.lo ff.lo galois.lo ga.lo gra.lo hash.lo hiccup.lo \
	io.lo ko.lo list.lo lo.lo ma.lo mee.lo mem.lo mes.lo mhe.lo mhh.lo mhm.lo mhp.lo mhs.lo mmm.lo mms.lo \
	mod_dg_sbd.lo mo.lo mpp.lo mps.lo mse.lo msh.lo msm.lo mss.lo muir.lo na.lo nb.lo nc.lo nu.lo part.lo pee.lo \
	peh.lo pem.lo perm.lo pes.lo phe.lo phh.lo phm.lo phs.lo plet.lo pme.lo pmh.lo poly.lo ppe.lo pph.lo ppm.lo \
	ppp.lo pps.lo pr.lo pse.lo psh.lo psm.lo pss.lo rest.lo rh.lo sab.lo sb.lo sc.lo sr.lo ta.lo teh.lo tem.lo \
	tep.lo tes.lo the.lo thm.lo thp.lo ths.lo tme.lo tmh.lo tmp.lo tms.lo tpe.lo tph.lo tpm.lo tps.lo tse.lo \
	tsh.lo tsm.lo tsp.lo vc.lo zo.lo zykelind.lo zyk.lo
LIBS=-lm
CC?=gcc
CFLAGS?=-O1
FPICFLAG?=-fPIC
VERSION=2.0
DIRNAME=symmetrica-$(VERSION)
TARGETS=libsymmetrica.a libsymmetrica.so
PREFIX?=/usr

all: $(TARGETS)

 .c.o:
	$(CC) -c $(CFLAGS) -DFAST -DALLTRUE $<

.SUFFIXES: .lo
 .c.lo:
	$(CC) -c $(CFLAGS) $(FPICFLAG) -DFAST -DALLTRUE -o $@ $<


test: test.c $(OBJS)
	$(CC) -DALLTRUE -DFAST test.c $(OBJS) $(LIBS) -o test

libsymmetrica.a: $(OBJS)
	ar crs $@ $(OBJS)
	ranlib $@

libsymmetrica.so: $(SHOBJS)
	$(CC) $(CFLAGS) $(FPICFLAG) -shared -Wl,-soname,lib$(DIRNAME).so $(LIBS) -o lib$(DIRNAME).so $(SHOBJS)
	ln -s lib$(DIRNAME).so $@

install: all
	mkdir -p $(DESTDIR)$(PREFIX)/lib
	install -p lib$(DIRNAME).so libsymmetrica.a $(DESTDIR)$(PREFIX)/lib
	ln -s lib$(DIRNAME).so $(DESTDIR)$(PREFIX)/lib/libsymmetrica.so
	mkdir -p $(DESTDIR)$(PREFIX)/include/symmetrica
	install -p def.h macro.h $(DESTDIR)$(PREFIX)/include/symmetrica/

clean:
	rm -f $(OBJS) $(SHOBJS) $(TARGETS) test
