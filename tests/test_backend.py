"""Unit tests for JSON encoding used by the demo API."""

import json
import unittest

from backend.app import message_payload


class ResponseEncodingTests(unittest.TestCase):
    def test_normal_message(self):
        self.assertEqual(json.loads(message_payload("Hello")), {"message": "Hello"})

    def test_quote_and_unicode(self):
        message = 'Qrasann says "Привет" \\ done'
        result = message_payload(message)
        self.assertEqual(json.loads(result.decode("utf-8")), {"message": message})


if __name__ == "__main__":
    unittest.main()
