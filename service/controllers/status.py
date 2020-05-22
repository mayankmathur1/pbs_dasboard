from flask_restx import Resource, Namespace
from typing import Dict

OK_STATUS: str = "OK"
BAD_STATUS: str = "Table cannot be reached"
HEALTH_SUCCESS_200_DOC: str = '{"status": "OK"}'

status_namespace: Namespace = Namespace("status", path="/", description="service status resources")


@status_namespace.route("/health")
class HealthResource(Resource):
    @status_namespace.response(200, HEALTH_SUCCESS_200_DOC)
    def get(self) -> Dict[str, str]:
        """
        Endpoint to make sure that the application has started

        :return: Dict object with status
        """
        status: Dict[str, str] = {"status": "OK"}
        return status


@status_namespace.route("/ready")
class ReadyResource(Resource):
    @status_namespace.response(200, HEALTH_SUCCESS_200_DOC)
    def get(self) -> Dict[str, str]:
        """
        Endpoint to make sure that the application is ready

        :return: Readiness of dependencies
        """
        status: Dict[str, str] = {"status": "OK"}
        return status


