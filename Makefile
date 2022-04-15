DESTDIR =
PREFIX = /usr
BINDIR = /bin
CONFDIR = /etc

PROG = doasedit
SOURCEDIR = bin
TARGETDIR = out

all: $(TARGETDIR)/$(PROG)

$(TARGETDIR)/$(PROG): $(SOURCEDIR)/$(PROG)
	install -Dm 755 $(SOURCEDIR)/$(PROG) -t $(TARGETDIR)
	sed -i 's#%DESTDIR%#$(DESTDIR)#' $(TARGETDIR)/$(PROG)
	sed -i 's#%PREFIX%#$(PREFIX)#' $(TARGETDIR)/$(PROG)
	sed -i 's#%BINDIR%#$(BINDIR)#' $(TARGETDIR)/$(PROG)
	sed -i 's#%CONFDIR%#$(CONFDIR)#' $(TARGETDIR)/$(PROG)

install: $(TARGETDIR)/$(PROG)
	install -Dm 755 $(TARGETDIR)/$(PROG) -t $(DESTDIR)$(PREFIX)$(BINDIR)

uninstall:
	rm -f $(DESTDIR)$(PREFIX)$(BINDIR)/$(PROG)

clean:
	rm -dfr $(TARGETDIR)

.PHONY: all install uninstall clean
