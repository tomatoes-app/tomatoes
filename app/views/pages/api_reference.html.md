# API Reference

---

## Session

### POST /api/session

Creates a new session using a third party auth provider token.

If a user associated to the access token doesn't exist, a new user will be
created.

The response includes a Tomatoes API token that should be used to perform
authenticated requests.

Supported providers:

* GitHub

#### Request

```
POST /api/session
```

#### Request content

```json
{
  "provider": "github",
  "access_token": "348871aaaeec6e4fbf6506e609d71cca8d999e04"
}
```

#### Response

* `200 Ok`
* `400 Bad Request`, the selected provider is not supported
* `401 Unauthorized`, the access token provided is not valid

#### Response content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a"
}
```

### DELETE /api/session

Deletes all Tomatoes API active sessions for the current user.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a"
}
```

#### Response

* `204 No Content`
* `401 Unauthorized`, invalid token

---

## User

### GET /api/user

Returns current user's data.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a"
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token

#### Response content

```json
{
  "id": "57f9c7f57c8402cc74b2cc5c",
  "name": "Giovanni Cappellotto",
  "email": null,
  "image": "https://avatars.githubusercontent.com/u/153842?v=3",
  "time_zone": null,
  "color": "#000000",
  "volume": 2,
  "ticking": false,
  "work_hours_per_day": null,
  "average_hourly_rate": null,
  "currency": "USD",
  "currency_unit": "$",
  "tomatoes_counters": {
    "day": 0,
    "week": 0,
    "month": 2
  },
  "authorizations": [
    {
      "provider": "github",
      "uid": "153842",
      "nickname": "potomak",
      "image": "https://avatars.githubusercontent.com/u/153842?v=3"
    }
  ],
  "created_at": "2016-10-09T04:30:45.300Z",
  "updated_at": "2016-10-09T04:30:45.300Z"
}
```

### PUT/PATCH /api/user

Updates current user's attributes.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a",
  "user": {
    "name": "Giovanni",
    "email": "giovanni@tomato.es",
    "image": "http://tomato.es/giovanni.png",
    "time_zone": "Europe/Rome",
    "color": "#00ccff",
    "work_hours_per_day": 8,
    "average_hourly_rate": 50,
    "currency": "USD",
    "volume": 1,
    "ticking": false
  }
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token
* `422 Unprocessable Entity`, validation error

#### Successful response content

```json
{
  "id": "57f9c7f57c8402cc74b2cc5c",
  "name": "Giovanni",
  "email": "giovanni@tomato.es",
  "image": "http://tomato.es/giovanni.png",
  "time_zone": "Europe/Rome",
  "color": "#00ccff",
  "volume": 1,
  "ticking": false,
  "work_hours_per_day": 8,
  "average_hourly_rate": 50,
  "currency": "USD",
  "currency_unit": "$",
  "tomatoes_counters": {
    "day": 0,
    "week": 0,
    "month": 2
  },
  "authorizations": [
    {
      "provider": "github",
      "uid": "153842",
      "nickname": "potomak",
      "image": "https://avatars.githubusercontent.com/u/153842?v=3"
    }
  ],
  "created_at": "2016-10-09T04:30:45.300Z",
  "updated_at": "2016-10-09T04:30:45.300Z"
}
```

---

## Tomatoes

### GET /api/tomatoes

Returns a list of current user's tomatoes.

The list of tomatoes is ordered by descending creation date and it's paginated.
Each page contains 25 records, by default the first page is retuned, use the
`page` parameter to get any other page in the range [1, `total_pages`].

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a",
  "page": 1
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token

#### Response content

```json
{
  "tomatoes": [
    {
      "id": "57f9c9377c8402dd306d1c8b",
      "created_at": "2016-10-09T04:36:07.787Z",
      "updated_at": "2016-10-09T04:36:07.787Z",
      "tags": ["one", "two"]
    },
    {
      "id": "57f9c9187c8402dd306d1c88",
      "created_at": "2016-10-09T04:35:36.952Z",
      "updated_at": "2016-10-09T04:35:36.952Z",
      "tags": []
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_count": 2
  }
}
```

### GET /api/tomatoes/:id

Returns one of current user's tomatoes.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a"
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token
* `404 Not Found`

#### Response content

```json
{
  "id": "57f9c9187c8402dd306d1c88",
  "created_at": "2016-10-09T04:35:36.952Z",
  "updated_at": "2016-10-09T04:35:36.952Z",
  "tags": ["one", "two"]
}
```

### POST /api/tomatoes

Creates a new tomato.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a",
  "tomato": {
    "tag_list": "one, two"
  }
}
```

#### Response

* `201 Created`
* `401 Unauthorized`, invalid token
* `422 Unprocessable Entity`, validation error

#### Successful response content

```json
{
  "id": "57f9c9187c8402dd306d1c88",
  "created_at": "2016-10-09T04:35:36.952Z",
  "updated_at": "2016-10-09T04:35:36.952Z",
  "tags": ["one", "two"]
}
```

#### Failure response content

```json
{
  "base": ["Must not overlap saved tomaotes, please wait 24 minutes, 59 seconds"]
}
```

### PUT/PATCH /api/tomatoes/:id

Updates one of current user's tomatoes.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a",
  "tomato": {
    "tag_list": "one, two"
  }
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token
* `422 Unprocessable Entity`, validation error

#### Successful response content

```json
{
  "id": "57f9c9187c8402dd306d1c88",
  "created_at": "2016-10-09T04:35:36.952Z",
  "updated_at": "2016-10-09T04:35:36.952Z",
  "tags": ["one", "two"]
}
```

### DELETE /api/tomatoes/:id

Deletes one of current user's tomatoes.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a"
}
```

#### Response

* `204 No Content`
* `401 Unauthorized`, invalid token
* `404 Not Found`

---

## Projects

### GET /api/projects

Returns a list of current user's projects.

The list of projects is ordered by descending creation date and it's paginated.
Each page contains 25 records, by default the first page is retuned, use the
`page` parameter to get any other page in the range [1, `total_pages`].

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a",
  "page": 1
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token

#### Response content

```json
{
  "projects": [
    {
      "id": "57f9c9377c8402dd306d1c8b",
      "name": "Web app",
      "created_at": "2016-10-09T04:36:07.787Z",
      "updated_at": "2016-10-09T04:36:07.787Z",
      "tags": ["one", "two"],
      "money_budget": 1200,
      "time_budget": 120
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_count": 1
  }
}
```

### GET /api/projects/:id

Returns one of current user's projects.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a"
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token
* `404 Not Found`

#### Response content

```json
{
  "id": "57f9c9377c8402dd306d1c8b",
  "name": "Web app",
  "created_at": "2016-10-09T04:36:07.787Z",
  "updated_at": "2016-10-09T04:36:07.787Z",
  "tags": ["ruby", "acme"],
  "money_budget": 1200,
  "time_budget": 120
}
```

### POST /api/projects

Creates a new project.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a",
  "project": {
    "name": "Web app",
    "tag_list": "ruby, acme",
    "money_budget": 1200,
    "time_budget": 120
  }
}
```

#### Response

* `201 Created`
* `401 Unauthorized`, invalid token
* `422 Unprocessable Entity`, validation error

#### Successful response content

```json
{
  "id": "57f9c9377c8402dd306d1c8b",
  "name": "Web app",
  "created_at": "2016-10-09T04:36:07.787Z",
  "updated_at": "2016-10-09T04:36:07.787Z",
  "tags": ["ruby", "acme"],
  "money_budget": 1200,
  "time_budget": 120
}
```

#### Failure response content

```json
{
  "name": ["can't be blank"]
}
```

### PUT/PATCH /api/projects/:id

Updates one of current user's projects.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a",
  "project": {
    "name": "Web app",
    "tag_list": "ruby, acme",
    "money_budget": 1200,
    "time_budget": 120
  }
}
```

#### Response

* `200 Ok`
* `401 Unauthorized`, invalid token
* `422 Unprocessable Entity`, validation error

#### Successful response content

```json
{
  "id": "57f9c9377c8402dd306d1c8b",
  "name": "Web app",
  "created_at": "2016-10-09T04:36:07.787Z",
  "updated_at": "2016-10-09T04:36:07.787Z",
  "tags": ["ruby", "acme"],
  "money_budget": 1200,
  "time_budget": 120
}
```

### DELETE /api/projects/:id

Deletes one of current user's projects.

#### Request content

```json
{
  "token": "d994a295cf68342b99e3036827d3ef8a"
}
```

#### Response

* `204 No Content`
* `401 Unauthorized`, invalid token
* `404 Not Found`
