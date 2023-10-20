import time
import typer
from loadtest.utils import prometheus
from loadtest.utils.k6 import k6


def url_callback(value: str):
    if value[:4] != "http":
        raise typer.BadParameter("URL must start with http or https")
    return value


def main(
        url: str = typer.Argument(default="", help="URL to make load tests", callback=url_callback),
        nbr_users: int = typer.Option(default=10, help="Number of users"),
        duration: int = typer.Option(default=60, help="Duration of the test"),
        wait_time: float = typer.Option(default=1, help="Wait time during the test"),
        token: str = typer.Option(default="", help="The token for test"),
        namespace_name: str = typer.Option(default="", help="The Namespace name"),
        container_name: str = typer.Option(default="", help="The Container name"),
        load_file : str=typer.Option(default="data.txt" , help = "The load files for the data.")
):

    # Launch the test
    k6.run_test(url , nbr_users , duration , wait_time  , token, load_file )

    start_time = int(time.time())
    end_time = int(time.time())

    prometheus.container_usage_memory(namespace_name, container_name, start_time, end_time, 1)
