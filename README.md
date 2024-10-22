
# Ruby exercise
Alan Daniel Alvarez Castro 21/10/2024

Example Deployed into Render.io service:  https://app-geolocation-service.onrender.com/



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

**Add .env file with the IP stack API Key, is an example in the repositorie**

# 2. Build the container:


```bash
bin/build_container
```

# 3. Run the container in a local enviroment:

```bash
bin/dev
```

# Runing the tests

```bash
rspec spec/
```

<img width="618" alt="Captura de pantalla 2024-10-22 a la(s) 3 25 20 p m" src="https://github.com/user-attachments/assets/5557e20d-764f-48bd-9cf8-480294743071">


# 5. User Auth 

The API is not available to the public, you must be logged in to use it, it is also displayed in these example URLs: https://app-geolocation-service.onrender.com/

### First create an user and login into the API
 - Create an User

```bash
    curl -X POST https://app-geolocation-service.onrender.com/users \
    -H "Content-Type: application/json" \
    -d   '{
      "user": {
        "name": "test",
        "email": "test@test.com",
        "password": "abcd1234"
      }
    }'
```
 - Then login into the API with the created user:

```bash
curl -X POST https://app-geolocation-service.onrender.com/auth/login -H "Content-Type: application/json" -d '{
  "email": "test@test.com",
  "password": "abcd1234"
}'
```

# 5. Geolocation Endpoints

#### Geolocation Object Example

<img width="467" alt="Captura de pantalla 2024-10-22 a la(s) 3 33 36 p m" src="https://github.com/user-attachments/assets/2218aad8-7c7c-4081-b056-31b33837fb9a">

#### POST Geolocation

  POST /api/v1/geolocations

```bash  
  curl -X POST "https://app-geolocation-service.onrender.com/api/v1/geolocations" \
  -H "Content-Type: application/json" \
  -H "Authorization: user_token_here" \
  -d '{"geolocation": {"input": "https://chatgpt.com"}}'
```

| Parameter | Type     | Description                          |
| :-------- | :------- | :------------------------------------|
| `input`   | `string` | **Required**. Can be an URL or an IP |

- Response: 
<img width="475" alt="Captura de pantalla 2024-10-22 a la(s) 3 37 01 p m" src="https://github.com/user-attachments/assets/a43cb235-7628-4167-a82b-fc52d0ad40bf">

#### Get one Geolocation

  GET /api/v1/geolocations/${id}

```bash  
  curl -X GET https://app-geolocation-service.onrender.com/api/v1/geolocations/4 \api/v1/geolocations/11 \
  -H "Authorization: user_token_here"
```

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of the geolocation |

#### Get all Geolocations

  GET /api/v1/geolocations

```bash  
  curl -X GET https://app-geolocation-service.onrender.com/api/v1/geolocations \
  -H "Authorization: user_token_here"
```

#### Delete Geolocation

  DELETE /api/v1/geolocations/${id}

```bash  
  curl -X DELETE "https://app-geolocation-service.onrender.com/api/v1/geolocations/5" \
  -H "Content-Type: application/json" \
  -H "Authorization: user_token_here"
```

-Succes response: "Geolocation deleted successfully"

| Parameter | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `id`      | `string` | **Required**. Id of the geolocation |


