from flask import Flask
import logging

from typing import Type

from service.config import Config
from service.structured_message import StructuredMessage
from service.restx import api
from service.controllers.status import status_namespace

LOG = logging.getLogger(__name__)
LOG.setLevel(logging.INFO)

stream_handler = logging.StreamHandler()
stream_formatter = logging.Formatter(
    "{'time':'%(asctime)s', 'name': '%(name)s', 'level': '%(levelname)s', 'log': '%(message)s'}"
)
stream_handler.setFormatter(stream_formatter)
LOG.addHandler(stream_handler)


def create_app() -> Flask:
    """
    Function used to start the application. Will create the app and map the
    endpoints appropriately.

    :return: Flask application
    """
    app = Flask(__name__)
    app.logger.info(StructuredMessage(message="Starting application"))
    app_config: Type[Config] = Config
    app.config.from_object(app_config)
    _setup_endpoints(app)
    return app


def _setup_endpoints(app):
    """
    Used to register a Resource for a given API Namespace
    """
    api.init_app(app)
    api.add_namespace(status_namespace)
