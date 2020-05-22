import pytest
import os

from service import create_app


@pytest.fixture(scope="session", autouse=True)
def app():
    """Creates test app and mocks all dynamo calls"""
    os.environ["FLASK_ENV"] = "unittest"
    yield create_app()


@pytest.fixture
def test_client(app):
    """Creates a test client."""
    yield app.test_client()
