source("02_build/src/build_and_tune.R")

t02_built_models <- list(
  tar_target(
    model_tune, 
    build_and_tune(train_test)
  ), 
  tar_target(
    ensemble, 
    {
      f <- function(x) {
        stacks::stacks() |> 
          stacks::add_candidates(x) |> 
          stacks::blend_predictions() |> 
          stacks::fit_members()
      }
      ensemble <- f(model_tune)
    }
  )
)