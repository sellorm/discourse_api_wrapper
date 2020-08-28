# Team Admin Training RStudio Community Registration API

library(httr)
library(plumber)

#* @apiTitle Add a RStudio Community User to a specific group


# Helper functions
check_url <- function (x)
{
  tmp <- if (is.null(x))
    Sys.getenv("DISCOURSE_URL", "")
  else x
  if (tmp == "")
    stop("need a Discourse url")
  else tmp
}

check_key <- function (x)
{
  tmp <- if (is.null(x))
    Sys.getenv("DISCOURSE_API_KEY", "")
  else x
  if (tmp == "")
    stop("need an API key for Discourse")
  else tmp
}

check_user <- function (x)
{
  tmp <- if (is.null(x))
    Sys.getenv("DISCOURSE_USERNAME", "")
  else x
  if (tmp == "")
    stop("need a Discourse username")
  else tmp
}

## Read version info on startup
api_version <- readLines("version.txt")[2]


# Main functions

add_user_to_group <- function(username, group_id, url = NULL, key = NULL, user = NULL){
  api_response <- httr::PUT(
    paste0(
      check_url(url),
      sprintf("/groups/%d/members.json", group_id)
      ),

    body   = list(usernames = username),

    encode = "json",

    httr::add_headers("Api-Key"      = check_key(key),
                      "Api-Username" = check_user(user))
  )

  api_response
}


# The "r-admin-training" group has id 58
group_id <- 58


#* Add the user to the specified group
#* @put /addtogroup
function(req, username, group_id, res) {
  community_response <- add_user_to_group(username, group_id)

  output_msg <- switch(as.character(community_response$status),
    "200" = "Success",
    "422" = "Already a member",
    "403" = "Forbidden",
    "Unknown"
  )
  res$status <- community_response$status
  list(
    status = community_response$status,
    message = output_msg
  )
}

#* Useful information and docs
#* @get /
function(req, res){
  plumber::include_md("README.md", res, format = NULL)
}



#* version
#* @get /__version__
function(){
  list(api_version = api_version)
}
