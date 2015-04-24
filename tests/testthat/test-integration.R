context("Integration test")

test_that("build package", {
              build_dir <- tempfile("build_")
              dir.create(build_dir)
              in_dir <- devtools::in_dir
              in_dir(build_dir, {
                         expect_true({ #expect_no_error
                             file.copy(system.file("examples/rcppexample", package = "cmaker"),
                                       to = ".", recursive = TRUE)
                             add_cmake("rcppexample")
                             generate_project("rcppexample", "CodeLite - Ninja")
                             in_dir("rcppexample/proj",
                                    system_check(cmaker_command_path("ninja")))
                             load_asis("rcppexample")
                             TRUE
                         })
                         expect_equal(rcpp_hello_world(),
                               list(c(3, 5, 8),
                                    3))
                         unload("rcppexample")
                     })
          })
