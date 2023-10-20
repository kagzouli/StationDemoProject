import typer
from loadtest import cli


def main():
    typer.run(cli.main)


if __name__ == "__main__":
    main()
