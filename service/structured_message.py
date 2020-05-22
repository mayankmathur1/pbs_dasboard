import json


class StructuredMessage(object):

    def __init__(self, **kwargs):
        self.kwargs = kwargs

    def __str__(self):
        return json.dumps(self.kwargs, default=str)
