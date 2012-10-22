# We use ditaa to producte graphics from ascii art
# http://ditaa.org/
# http://ditaa.sourceforge.net/
# http://ditaa-addons.sourceforge.net/

SRC = $(wildcard *.txt)
PNG = $(patsubst %.txt,%.png,$(SRC))
PDF = $(patsubst %.txt,%.pdf,$(SRC))

#DITAA ?= ~/recup/ditaa0_9.jar
DITAA ?= ~/Downloads/ditaa0_9/ditaa0_9.jar
DITAE ?= ~/Downloads/DitaaEps/DitaaEps.jar

all: png

png: $(PNG)
pdf: $(PDF)

clean:
	rm -f $(PNG)

%.png: %.txt
	java -jar $(DITAA) -o $<

%.eps: %.txt
	java -jar $(DITAE) -o $<

%.pdf: %.eps
	epstopdf $<

.PHONY: all
