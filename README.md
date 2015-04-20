# cmaker

Powered by `CMake`, `cmaker` setups C/C++ develop environment for R
package, to enjoy auto-complete, debug, parallel compiling and other
features of IDE. Not convinced? Watch Xcode in action and give it a
try. If not satisfied, just delete `CMakeList.txt`, `proj/` and
`cmake`. Testing, suggestion, and pull request are welcome.
![](https://raw.githubusercontent.com/luckyrandom/cmaker/master-src/gifs/xcode-rcpp.gif)

## Usage

__The IDE project generated by `cmaker` is for development
only. Always check package following CRAN document before release.__
- `ls_IDEs()` to get recommend IDEs for your system.
- `add_cmake("pkg_dir")` to generate cmake files for the R package.
- `generate_project("pkg_dir", "IDE_name")` to generate project for your preferred IDE.
- Open IDE and enjoy.
- When you are ready, build within IDE.
- Call `load_asis("pkg_dir")` to load the package. `load_asis` works
  the same way as `devtools::load_all`, but assuming the dynamic
  library has been built properly.

## Install

### Windows is not supported yet
Will be supported soon. Please stay tuned.

### System requirements

`cmaker` depends on [CMake](http://www.cmake.org) and
[ninja](https://martine.github.io/ninja/). The newest version is
recommended.

- Mac users may install them
through [MacPorts](https://www.macports.org/) or
[Homebrew](http://brew.sh/), with command
```bash
port install cmake ninja
```
or
```
brew install cmake ninja
```
- Linux users may install them through package management tools. You
  may need [PPA](https://launchpad.net/ubuntu/+ppas) or something similar to install the newest version.

### Install the package

`cmaker` require `devtools (>= 1.7.0.9000)`, which is not on CRAN
yet. Install newest `devtools` from github, and then install `cmaker`
from github. You can run the following R script to install them
automatically.

### Mac and Linux
```r
if (! "devtools" %in% installed.packages())
  install.packages("devtools")
if (packageVersion("devtools") < "1.7.0.9000") {
  ## The head of master branch is borken at time of writting. Install
  ## devtools 1.7.0.9000
  devtools::install_github("hadley/devtools", "4d0964a1")
}
devtools::install_github("luckyrandom/cmaker")
```
