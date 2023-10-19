import requests

def main():

    url_test = "https://petstore.swagger.io/v2/pet/findByStatus?status=available"

    params = {}
    headers = { "Content-Type" : "application/json"}
    # Make a get request with the parameters.
    response = requests.get(url_test, params=params, headers=headers)

    print(response.status_code)
    print(response.json()) 


if __name__ == "__main__":
    main()