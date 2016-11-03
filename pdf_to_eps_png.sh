# crop to remove blank space
# get pdfcrop from
# sudo apt-get install texlive-extra-utils
pdfcrop fig.pdf

# pdf to ps
pdf2ps fig-crop.pdf

# ps to eps; 
# note: -s change size, 1000x1000 is just a large size to cover the whole figure
        -O keep orientation
        -g use internal bounding box in the ps file
        -f force overwrite eps file
ps2eps -s 1000x1000 -g -f fig-crop.ps

# ps to png; imagemagic
convert -density 72 -rotate 90 -background white -render -antialias -flatten fig.ps fig.png

