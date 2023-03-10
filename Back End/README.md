# Habit Tracker API

# Authentication Endpoints - api/auth.php

### **Login**

- Method: GET
- Parameters: `username` (string), `password` (string)
- Returns: JSON object with user data and a session token if successful
- Throws: Exception if no results found
- HTTP Response Codes:
    - 200 if successful
    - 204 if no results found
    - 400 if parameters are missing or invalid

Example Request:

```
GET /auth.php?username=johndoe&password=pass123
```

Example Response:

```
[
   {
      "id":"1",
      "username":"johndoe",
      "email":"johndoe@example.com",
      "admin":"0",
      "created":"2022-12-31 23:59:59",
      "session":"9tAKsZ7rxW2s8Yr7TjTbTcJTjVgsTtJ4hKj4D4PmDKZztOeI1jYw1mJlKTlLNMb"
   }
]
```

### **Register**

- Method: POST
- Parameters: `username` (string), `password` (string), `email` (string)
- Returns: "Created" message if successful
- HTTP Response Codes:
    - 200 if successful
    - 400 if parameters are missing or invalid, or username or email already in use

Example Request:

```
POST /auth.php?username=johndoe&password=pass123&email=johndoe@example.com
```

Example Response:

```
Created
```

### **Get User Info**

- Method: PUT
- Parameters: `session` (string)
- Returns: JSON object with user data if session is valid and not expired
- HTTP Response Codes:
    - 200 if successful
    - 400 if parameters are missing or invalid
    - 401 if session is expired

Example Request:

```
PUT /auth.php?session=9tAKsZ7rxW2s8Yr7TjTbTcJTjVgsTtJ4hKj4D4PmDKZztOeI1jYw1mJlKTlLNMb
```

Example Response:

```
[
   {
      "id":"1",
      "username":"johndoe",
      "email":"johndoe@example.com",
      "admin":"0",
      "created":"2022-12-31 23:59:59"
   }
]
```

# CRUD Endpoints - api/crud.php

### Creating a habit

- Method: POST
- Parameters: `session` (string), `task` (string), `tag` (string), `start` (string), `end`(string)
- Date Format: `yyyy-mm-dd`
- Returns: "Created" message if successful
- HTTP Response Codes:
    - 200 if successful
    - 400 if parameters are missing or invalid

Example request:

```
POST /crud.php?session=9tAKsZ7rxW2s8Yr7TjTbTcJTjVgsTtJ4hKj4D4PmDKZztOeI1jYw1mJlKTlLNMb&task=Read%20a%20book&tag=Reading&start=2022-01-01&end=2022-01-31
```

Example response:

```
HTTP/1.1 200 OK
Content-Length: 7

Created
```

### Retrieving habits

- Method: GET
- Parameters: `session` (string)
- Returns: JSON object with habit data if session is valid and not expired
- HTTP Response Codes:
    - 200 if successful
    - 400 if parameters are missing or invalid

Example request:

```
GET /crud.php?session=9tAKsZ7rxW2s8Yr7TjTbTcJTjVgsTtJ4hKj4D4PmDKZztOeI1jYw1mJlKTlLNMb
```

Example response:

```
[
  {
    "id": "1",
    "uid": "123",
    "task": "Read a book",
    "tag": "Reading",
    "start": "2022-01-01",
    "end": "2022-01-31"
  }
]
```

### Updating a habit

- Method: PUT
- Parameters: `session` (string), `id` (string), `task` (string - Optional), `tag` (string - Optional), `start` (string - Optional), `end`(string - Optional)
- Date Format: `yyyy-mm-dd`
- Returns: "Updated" message if successful
- HTTP Response Codes:
    - 200 if successful
    - 400 if parameters are missing or invalid

Example request:

```
PUT /crud.php?session=9tAKsZ7rxW2s8Yr7TjTbTcJTjVgsTtJ4hKj4D4PmDKZztOeI1jYw1mJlKTlLNMb&id=1&task=Read%20two%20books
```

Example response:

```
HTTP/1.1 200 OK
Content-Length: 7

Updated
```

### Deleting a habit

- Method: DELETE
- Parameters: `session` (string), `id` (string)
- Returns: "Deleted" message if successful
- HTTP Response Codes:
    - 200 if successful
    - 400 if parameters are missing or invalid

Example request:

```
DELETE /crud.php?session=9tAKsZ7rxW2s8Yr7TjTbTcJTjVgsTtJ4hKj4D4PmDKZztOeI1jYw1mJlKTlLNMb&id=1
```

Example response:

```
HTTP/1.1 200 OK
Content-Length: 7

Deleted
```

# Search Endpoint - api/search.php

### Search habits

- Method: GET
- Parameters: `session` (string), `task` (string - Optional), `tag` (string - Optional), `start` (string - Optional), `end`(string - Optional)
- Date Format: `yyyy-mm-dd`
- Returns: JSON object with habit data if session is valid and not expired
- HTTP Response Codes:
    - 200 if successful
    - 400 if parameters are missing or invalid

Example request:

```
GET /search.php?session=9tAKsZ7rxW2s8Yr7TjTbTcJTjVgsTtJ4hKj4D4PmDKZztOeI1jYw1mJlKTlLNMb&id=1&task=Read%20two%20books
```

Example response:

```
[
  {
    "id": "1",
    "uid": "123",
    "task": "Read a book",
    "tag": "Reading",
    "start": "2022-01-01",
    "end": "2022-01-31"
  }
]
```
