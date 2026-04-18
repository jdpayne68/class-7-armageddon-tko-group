# ----------------------------------------------------------------
# SAO PAULO RANDOMIZERS - Naming Suffix Generator
# ----------------------------------------------------------------

resource "random_string" "suffix" {
  length  = 5
  special = false
}

# ---------------------------------------------------------------
# SAO PAULO RANDOMIZERS - Random Hex ID (Suffix) 
# ---------------------------------------------------------------
#For globally unique S3 bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}