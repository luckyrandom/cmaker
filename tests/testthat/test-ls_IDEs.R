context("ls IDEs")

test_that("unsupported IDEs", {
            expect_warning(
              local({
                environment(cmake_help)$out_cache <- "Xcode"
                ls_IDEs()
                environment(cmake_help)$out_cache <- NULL
              }),
              "`cmake` on your system is too old")
          })

