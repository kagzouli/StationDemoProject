import requests

import typer
import time

from loadtest.utils import prometheus

def main():
    # URL
    url: str = typer.Option("" , help="URL to make load tests"),
    # Number users
    nbr_users: int = typer.Option(10, help="Number of users"),
    # Duration
    duration: int = typer.Option(60 , "Duration of the test")
    # Wait time
    wait_time : float = typer.Option(1 , help="Wait time during the test"),
    # Token
    token : str = typer.Option("" , "The token for test")
    # Namespace name
    namespace_name : str = typer.Option("" , "The Namespace name")
    # container name
    container_name: str = typer.Option("", "The Container name")

    print("URL : " + str(url))
    print("Number users : " + str(nbr_users))
    print("Duration : " + str(duration))
    print("Wait time : " + str(wait_time))
    print("Token : " + str(token))
    print("Namespace name : " + str(namespace_name))
    print("Container name : " + str(container_name))

    start_time = int(time.time())
    end_time = int(time.time())

    prometheus.container_usage_memory(namespace_name , container_name , start_time , end_time , 1)




if __name__ == "__main__":
    main()