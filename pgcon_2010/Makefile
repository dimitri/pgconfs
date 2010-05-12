SRC = $(wildcard *.txt)
PNG = $(patsubst %.txt,%.png,$(SRC))

DITAA ?= ~/recup/ditaa0_9.jar

all: $(PNG)

clean:
	rm -f $(PNG)

%.png: %.txt
	java -jar $(DITAA) -o $<

.PHONY: all