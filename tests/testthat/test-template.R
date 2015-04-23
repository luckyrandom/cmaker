context("template")

test_that("template content", {
            expect_equal(
              template("Hello @@user@@!",
                       list(user = "world")),
              "Hello world!")
            expect_equal(
              template("Hello user!",
                       list(user = "world")),
              "Hello user!")
})
