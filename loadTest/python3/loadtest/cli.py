import datetime
import time
from dateutil.relativedelta import relativedelta
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
        token: str = typer.Option(default="token", help="The token for test"),
        namespace_name: str = typer.Option(default="", help="The Namespace name"),
        container_name: str = typer.Option(default="", help="The Container name"),
        load_file : str=typer.Option(default="data.txt" , help = "The load files for the data.")
):

    # Start the timer before the test
    start_time = int(time.time())

    # Launch the test with k6
    k6.run_test(url , nbr_users , duration , wait_time  , token, load_file )

    # End the timer after the test + 30 seconds
    today_date = datetime.datetime.now(datetime.UTC)
    end_date_datetime = today_date + relativedelta(second=30)
    end_time = get_epochtime_ms((end_date_datetime))

    print(f"Start time : {start_time} , End time : {end_time}")

    prometheus.container_usage_memory(namespace_name, container_name, start_time, end_time, 1)


def get_epochtime_ms(date_time : datetime):
    epochtime = int(round(date_time.timestamp()))
    return epochtime