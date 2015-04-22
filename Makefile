mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

index.html: _src/index.md
	R --script -e "rmarkdown::render('$<', output_file = '$@', output_dir = '$(mkfile_dir)')"
