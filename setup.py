import setuptools
import pathlib


with open("README.md", "r") as fh:
    long_description = fh.read()


def read_requirements(filename):
    return pathlib.Path('requires', filename).read_text().split('\n')


setuptools.setup(
    name='service',
    version='0.0.1',
    author='Coupa',
    author_email='air-pillar@coupa.com',
    description='Template flask service',
    install_requires=read_requirements('requirements.txt'),
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/coupa/cts_flask_service",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3.7",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.7',
)
