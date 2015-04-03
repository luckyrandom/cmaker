context("command exist")

os_type <- .Platform$OS.type

test_that("Simple command", {
  expect_true(command_exist("echo"))
  if (os_type == "unix") {
    expect_true(command_exist("ls"))
    expect_true(command_exist("mkdir", paste0("test_create_dir", floor(runif(1) * 1e10))))
    expect_true(command_exist("make", "--version"))
  } else {  ## Windows
    expect_true(command_exist("dir"))
  }
})
