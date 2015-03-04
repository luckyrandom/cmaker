.PHONY: doc
doc:
	Rscript -e 'library(devtools); document(reload=TRUE);'

.PHONY: prebuild
prebuild: doc


