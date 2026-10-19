"""Tiny standard-library backend used by the reverse-proxy lab."""

import json
import os
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PORT = int(os.getenv("PORT", "5000"))
MESSAGE = os.getenv("MESSAGE", "Hello from backend")


def message_payload(message: str) -> bytes:
    """Return valid UTF-8 JSON even when a message contains quotes or Unicode."""
    return (json.dumps({"message": message}, ensure_ascii=False) + "\n").encode("utf-8")


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/api/":
            body = message_payload(MESSAGE)
            content_type = "application/json; charset=utf-8"
        elif self.path == "/health":
            body = b"OK\n"
            content_type = "text/plain; charset=utf-8"
        else:
            self.send_error(404, "Not found")
            return

        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    server = ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
    server.serve_forever()
