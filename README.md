---
title: "Discourse API wrapper"
---


A simple API wrapper around the [Discourse API](https://docs.discourse.org), specifically to make some common operations simpler and easier to automate.

See GitHub for the [project repo](https://github.com/sellorm/discourse_api_wrapper).

For more information on releasing new versions of the API, see the bottom of this document.

For the API to work, it requires three **environment variables** be set:

* DISCOURSE_API_KEY - API key obtained from the admin panel
* DISCOURSE_USERNAME - The username assocaited with the API key
* DISCOURSE_URL - The URL of the Discourse instance


---

# Endpoints

## Add user to group

**Endpoint**: `/addtogroup`

**Method**: PUT

**Payload**: `{"username":"exampleuser","group_id":58}`

You must use the numeric group ID of the specified group. For example, a group called "r-admin-training" might have the numeric ID of 58. Check the values for the groups you're interested in within your particular discourse instance.

**curl**:

This example assume the API is hosted on RStudio Connect and that your Connect API key is stored in an environment variable called `CONNECT_API_KEY`.

```
curl -X PUT \
  -H "Content-Type: application/json" \
  -H "Authorization: Key ${CONNECT_API_KEY}" \
  --data '{"username":"exampleuser","group_id":58}' \
  https://API_URL/addtogroup
```

**httr**:

This example assume the API is hosted on RStudio Connect and that your Connect API key is stored in an environment variable called `CONNECT_API_KEY`.

```
httr::PUT(
    "https://API_URL/addtogroup",
    body = list(username = "exampleuser",
                  group_id  = 58),
    encode = "json",
    httr::add_headers(
        "Authorization" = paste("Key", Sys.getenv("CONNECT_API_KEY"))
        )
    )
```

**Return codes**:

| Code | Meaning |
|------|---------|
| 200  | User successfully added to group |
| 422  | User already a member of specified group |

**Returns**

Example:

```
{"status":[422],"message":["Already a member"]}
```


## Version info

**Endpoint**: `/__version__`

**Method**: GET

**Returns**

Example:

```
{"api_version":["1.1.8"]}
```


---

# Releasing a new version

The project ships with a Makefile that is used to prepare a release.

For instance, to increment the patch version and update manifest.json, run:

```
make release_patch
```

For other options, run `make help`.
