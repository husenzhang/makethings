plot:   data/otu_tax.biom  data/map.txt data/group data/rep_set.tre
	toJson.sh
	sumTax.sh
	./scripts/plot.r
	./scripts/adiv.r
	./scripts/bdiv.sh
	./scripts/pcoa.R
	stackPlot.r
	rm -rf out/samplebytax
	rm -rf out/taxbysample
	zip -r out out/


pj3:	data/L3.txt data/map.txt
	pj3.sh
	Rscript ~/Dropbox/makeThings/pj3FC.R

.PHONY: clean
clean:
	rm -rf out; mkdir out
