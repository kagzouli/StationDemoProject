from setuptools import setup
import ssl
ssl._create_default_https_context = ssl._create_unverified_context

setup(
    name='loadtest',
    version='1.0.0',
    description='Library for load test',
    author='Exaka Consulting',
    author_email='exa@exaka.com',
    license="Unlicensed",
    packages=["loadtest"],
    python_requires=">=3.11",
    install_requires=[
        "requests", "kubernetes" , "typer[all]"
    ], #external packages as dependencies
    entry_points={
        "console_scripts": [
            "loadtest=loadtest.__main__:main"
        ]
    },
    include_package_data=True,
    package_data={"" : ["utils/*"]},
    zip_safe=False
)