# README

This api has been created to fulfill Babbel's coding challenge. See `echo.md` for requirements.
It was a fun challenge to fulfill!

Given more time I would:
- add tests for the service
- add proper api documentation with swagger, re-using the json schema files used for schema validation
- dockerize the application
- investigate how to handle less common HTTP verb (CONNECT OPTIONS TRACE)

## How to run the application
### Dependencies
- ruby 3.1.2
- rails 7.0.3
- postgresql

### Get the application running
- Install dependencies
    ```bash
    bundle install
    ```
- Configure database (copy sample file and replace values)
    ```bash
    cp config/database.sample.yml config/database.yml
    ```
- Create and migrate database
  ```bash
  rails db:create rails db:migrate
  ```
- Get the server running
  ```bash
  rails s
  ```

### Running the tests
```bash
bundle exec rspec
```

### Getting the api token
- create a master.key file
  ```bash
  touch config/master.key
  ```
- insert shared_master_key in file
  ```bash
  echo <shared_master_key> >> config/master.key
  ```
- get the api_token from a rails console
  ```bash
  Rails.application.credentials.api_token
  ```

## The API
### Authorization

All API requests require the use of an API key.
To authenticate an API request, you should provide your API key in the `Authorization` header as a bearer token.
e.g. `"Bearer asdwvwq-wer-xc4-34534-12312"`

### The endpoints

<details>
  <summary>List endpoints</summary>
  <markdown>
#### Request

    GET v1/endpoints HTTP/1.1
    Accept: application/vnd.api+json

#### Response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": [
            {
                "type": "endpoints",
                "id": "12345",
                "attributes": [
                    "verb": "GET",
                    "path": "/greeting",
                    "response": {
                      "code": 200,
                      "headers": {},
                      "body": "\"{ \"message\": \"Hello, world\" }\""
                    }
                ]
            }
        ]
    }
  </markdown>
</details>

<details>
  <summary>Create endpoint</summary>
  <markdown>
#### Request

    POST v1/endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### Response

    HTTP/1.1 201 Created
    Location: http://localhost:3000/greeting
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/greeting",
                "response": {
                  "code": 200,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Update endpoint</summary>
  <markdown>
#### Request

    PATCH v1/endpoints/12345 HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345"
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }


#### Response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "POST",
                "path": "/greeting",
                "response": {
                  "code": 201,
                  "headers": {},
                  "body": "\"{ \"message\": \"Hello, everyone\" }\""
                }
            }
        }
    }
  </markdown>
</details>

<details>
  <summary>Delete endpoint</summary>
  <markdown>
#### Request

    DELETE v1/endpoints/12345 HTTP/1.1
    Accept: application/vnd.api+json

#### Response

    HTTP/1.1 204 No Content
  </markdown>
</details>

<details>
  <summary>Error response</summary>
  <markdown>
In case client makes unexpected response or server encountered an internal
problem, the api will provide an error response.

#### Request

    DELETE v1/endpoints/1234567890 HTTP/1.1
    Accept: application/vnd.api+json

#### Response

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested Endpoint with ID `1234567890` does not exist"
            }
        ]
    }
  </markdown>
</details>

<details open>
  <summary>Sample scenario</summary>
  <markdown>

#### 1. Client requests non-existing path

    > GET /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

#### 2. Client creates an endpoint

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json
    
    {
         "data": {
             "type": "endpoints",
             "attributes": {
                 "verb": "GET",
                 "path": "/hello",
                 "response": {
                     "code": 200,
                     "headers": {
                         "Content-Type": "application/json"
                     },
                     "body": "\"{ \"message\": \"Hello, world\" }\""
                 }
             }
         }
     }

    HTTP/1.1 201 Created
    Location: http://localhost:3000/hello
    Content-Type: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "id": "12345",
            "attributes": {
                "verb": "GET",
                "path": "/hello",
                "response": {
                    "code": 200,
                    "headers": {
                        "Content-Type": "application/json"
                    },
                    "body": "\"{ \"message\": \"Hello, world\" }\""
                }
            }
        }
    }

#### 3. Client requests the recently created endpoint

    GET /hello HTTP/1.1
    Accept: application/json

    HTTP/1.1 200 OK
    Content-Type: application/json

    { "message": "Hello, world" }

#### 4. Client requests the endpoint on the same path, but with different HTTP verb

The server responds with HTTP 404 because only `GET /hello` endpoint is defined.

    > POST /hello HTTP/1.1
    > Accept: application/vnd.api+json

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/hello` does not exist"
            }
        ]
    }

  </markdown>
</details>
