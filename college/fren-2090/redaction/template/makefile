redaction: redaction.tex
	pdflatex redaction.tex
	mv redaction.log redaction.aux .tex

read: 
	zathura redaction.pdf &> /dev/null & 

count:
	texcount redaction.tex

spellcheck:
	aspell -c redaction.tex -d fr
