from typing import Dict

from service.controllers.status import HealthResource, ReadyResource


class TestStatus:
    def test_health_check_successful(self):
        expected_response: Dict[str, str] = {"status": "OK"}

        response: Dict[str, str] = HealthResource().get()

        assert response == expected_response

    def test_ready_check_successful(self):
        expected_response: Dict[str, str] = {"status": "OK"}

        response: Dict = ReadyResource().get()

        assert response == expected_response
