CC = gcc
CFLAGS = -O2 -std=c11 -Wall -pg
LDFLAGS = -pg -lm

all: scatter.png

clean:
	rm -f data.tsv scatter.png

scatter.png: data.tsv
	Rscript -e 'library(ggplot2); data <- read.delim("$<"); ggplot(data, aes(x = X, y = Y)) + geom_point() + labs(title = "Scatter Plot", x = "X-axis", y = "Y-axis") + ggsave("$@")'

data.tsv: lab_03_generate_data.r
	Rscript $<

.PHONY: all clean