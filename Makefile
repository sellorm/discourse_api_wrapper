all: help

release_patch:  ## Update the patch version and prepare a release
	Rscript release.R

release_minor:  ## Update the minor version and prepare a release
	Rscript release.R minor

release_major:  ## Update the major version and prepare a release
	Rscript release.R major

serve:  ## Serve the API locally on port 8000
	R -e 'plumber::pr_run(plumber::pr("plumber.R"), host="127.0.0.1", port = 8000)'

clean:  ## Cleans up any unrequired files
	-rm *.html

help:  ## Show this help menu
	@grep -E '^[0-9a-zA-Z_-]+:.*?##.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?##"; OFS="\t\t"}; {printf "\033[36m%-30s\033[0m %s\n", $$1, ($$2==""?"":$$2)}'

.PHONY: all help serve release_patch release_minor, release_major
