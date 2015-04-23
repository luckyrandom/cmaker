context("pkg name")

test_that("get package name", {
            print(getwd())
            expect_equivalent(pkg_name(system.file("examples/rcppexample", package = "cmaker")),
                              "rcppexample")
          })
