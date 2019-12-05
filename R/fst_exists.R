

fst_exists <- function(file_with_path) {
  
  .fst_path <- construct_fst_path(file_with_path)
  
  .fst_file.exists <- file.exists(.fst_path)
  
  return(.fst_file.exists)
}

construct_fst_path <- function(file_with_path) {
  .path <- dirname(file_with_path)
  .filename <- basename(file_with_path)
  .file_sans_ext <- tools::file_path_sans_ext(.filename)
  .fst_path <- file.path(.path, "fst")
  .fst_file_with_path <- file.path(.fst_path, paste0(.file_sans_ext, ".fst"))
  
  return(.fst_file_with_path)
}
