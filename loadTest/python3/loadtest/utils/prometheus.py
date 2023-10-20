

PROMETHEUS_API_URL = "http://prometheus.exakaconsulting.org/api/v1"

# Method for container usage memory
def container_usage_memory(namespace_name: str, container_name : str , start_time : int, end_time : int , step : int):

    url : str= (
    f"{PROMETHEUS_API_URL}/query_range?query=sum(container_memory_working_set_bytes" +
    "{namespace=%22" + f"{namespace_name}%22, container=%22{container_name}%22" +
    "}" +
    f")&start={start_time}&end={end_time}&step={step}"
    )

    print("URL : " + url)
