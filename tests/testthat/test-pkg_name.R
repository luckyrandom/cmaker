context("pkg name")

test_that("get package name", {
            expect_equivalent(pkg_name(system.file("examples/rcppexample", package = "cmaker")),
                              "rcppexample")
          })
