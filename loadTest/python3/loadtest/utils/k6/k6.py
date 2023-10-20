import os
import subprocess


def run_test(url: str, nbr_users: int, duration: int, wait_time: float,  token: str, load_file: str):

    subprocess.run(
        [
            os.path.join(os.path.dirname(__file__), "k6"),
            "run",
            f"--vus={nbr_users}",
            f"--duration={duration}s",
            "-e",
            f"LOAD_FILE_TEST={load_file}"
            "-e",
            f"TOKEN={token}",
            "-e",
            f"WAIT_TIME={wait_time}",
            "-e",
            f"URL={url}",
            os.path.join(os.path.dirname(__file__), "script.js"),
        ]
    )
