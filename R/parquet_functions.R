
parquet_exists <- function(file_with_path) {
  .parquet_path <- construct_parquet_path(file_with_path)
  .parquet_file_exists <- file.exists(.parquet_path)
  return(.parquet_file_exists)
}

construct_parquet_path <- function(file_with_path) {
  .path <- dirname(file_with_path)
  .filename <- basename(file_with_path)
  .file_sans_ext <- tools::file_path_sans_ext(.filename)
  .parquet_path <- file.path(.path, "parquet")
  .parquet_file_with_path <- file.path(.parquet_path, paste0(.file_sans_ext, ".parquet"))
  return(.parquet_file_with_path)
}

write_parquet_file <- function(file, path) {
  
  parquet_path <- construct_parquet_path(path)
  parquet_dir <- dirname(parquet_path)
  
  if (isFALSE(dir.exists(parquet_dir))) {
    dir.create(parquet_dir)
  }
  
  arrow::write_parquet(file, parquet_path)
}