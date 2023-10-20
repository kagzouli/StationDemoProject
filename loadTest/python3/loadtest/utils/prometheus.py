import requests
from typing import List

PROMETHEUS_API_URL = "http://prometheus.exakaconsulting.org/api/v1"


# Method for container usage memory
def container_memory_usage(namespace_name: str, container_name: str, start_time: int, end_time: int,
                           step: int) -> List[float]:
    url_memory_usage: str = (
            f"{PROMETHEUS_API_URL}/query_range?query=sum(container_memory_working_set_bytes" +
            "{namespace=%22" + f"{namespace_name}%22, container=%22{container_name}%22" +
            "}" +
            f")&start={start_time}&end={end_time}&step={step}"
    )

    # Lancement requete
    response = requests.get(url_memory_usage, verify=False)
    # Si c ok
    if response.status_code == 200:
        result_json = response.json()
        values = [
            byte_to_megabytes(int(data[1])) for data in result_json["data"]["result"][0]["values"]
                 ]
    else:
        raise Exception(f"Erreur lors de l'appel container_usage_memory avec un status code : {response.status_code}")

    # Return values
    return values


# Method for container usage cpu
def container_cpu_usage(namespace_name: str, container_name: str, start_time: int, end_time: int,
                        step: int) -> List[float]:
    url_cpu_usage: str = (
            f"{PROMETHEUS_API_URL}/query_range?query=sum(" +
            f"node_namespace_pod_container:container_cpu_usage_seconds_total:sum_irate" +
            "{namespace=%22" + f"{namespace_name}%22, container=%22{container_name}%22" +
            "}" +
            f")&start={start_time}&end={end_time}&step={step}"
    )

    # Lancement requete
    response = requests.get(url_cpu_usage, verify=False)
    if response.status_code == 200:
        result_json = response.json()
        values = [
            float(data[1]) for data in result_json["data"]["result"][0]["values"] if float(data[1]) > 0.001
        ]
    else:
        raise Exception(f"Erreur lors de l'appel container_usage_memory avec un status code : {response.status_code}")

    # Return values
    return values


def byte_to_megabytes(value: int):
    return value/1048576
