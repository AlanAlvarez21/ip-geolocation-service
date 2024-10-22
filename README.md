
# Ruby exercise
Alan Daniel Alvarez Castro 21/10/2024

Example Deployed into Fly.io service:  https://ip-geolocation-wild-haze-5733.fly.dev/



## RESTful API for geolocation using IP & URL´s

# 1. Pre-requisites
In order to run locally you must install **Docker** and **Devcontainers**
- **Docker** https://www.docker.com/
- **Devcontainers** https://github.com/devcontainers/cli 


    Using NPM:
    ```bash
      npm install -g @devcontainers/cli or with NPX:  npx install -g @devcontainers/cli 
    ```
    using NPX:
    ```bash
      npx install -g @devcontainers/cli 
    ```   


# 2. Build the container:


```bash
bin/build_container
```

# 3. Run the container in a local enviroment:

```bash
bin/dev
```

# 3. Runing the test

```bash
rspec spec/
```

# 4. Endpoints

The API in deployed in these example URL 
https://ip-geolocation-wild-haze-5733.fly.dev/

### First create an user and login into the API
 - Create an User

```http
curl -X POST https://ip-geolocation-wild-haze-5733.fly.dev/users \
-H "Content-Type: application/json" \
-d '{
  "user": {
    "name": "test",
    "email": "sss@example.com",
    "password": "abcd1234"
  }
}'
```
 - Then login into the API with the created user 

```http
curl -X POST https://ip-geolocation-wild-haze-5733.fly.dev/auth/login -H "Content-Type: application/json" -d '{
  "email": "admin@example.com",
  "password": "abcd1234"
}'
```


#### POST Geolocation

  POST /api/v1/geolocations

```http  
  curl -X POST "https://ip-geolocation-wild-haze-5733.fly.dev/api/v1/geolocations" \
  -H "Content-Type: application/json" \
  -H "Authorization: user_token_here" \
  -d '{"geolocation": {"input": "https://chatgpt.com"}}'
```

| Parameter | Type     | Description                          |
| :-------- | :------- | :------------------------------------|
| `input`   | `string` | **Required**. Can be an URL or an IP |


#### Get one Geolocation

  GET /api/v1/geolocations/${id}

```http  
  curl -X GET https://ip-geolocation-wild-haze-5733.fly.dev/api/v1/geolocations/4 \api/v1/geolocations/11 \
  -H "Authorization: user_token_here"
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of the geolocation |

#### Get all Geolocations

  GET /api/v1/geolocations/${id}

```http  
  curl -X GET https://ip-geolocation-wild-haze-5733.fly.dev/api/v1/geolocations \
  -H "Authorization: user_token_here"
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of the geolocation |

#### Delete Geolocation

  DELETE /api/v1/geolocations/${id}

```http  
  curl -X DELETE "https://ip-geolocation-wild-haze-5733.fly.dev/api/v1/geolocations/13" \
  -H "Content-Type: application/json" \
  -H "Authorization: user_token_here"
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of the geolocation |


