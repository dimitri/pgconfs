SRC = $(wildcard *tex)
PDF = $(SRC:.tex=.pdf)

all: $(PDF)

pgq.pdf: pgq.png

%.pdf : %.tex
	pdflatex $<

clean:
	 find . \
            -type f              \
            -not -name "*.tex"   \
         -a -not -name "*.pdf"   \
         -a -not -name "*.png*"  \
         -a -not -name "Makefile" | xargs rm -f