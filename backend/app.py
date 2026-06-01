import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(os.getenv("PORT", "5000"))
MESSAGE = os.getenv("MESSAGE", "Hello from backend")

class Handler(BaseHTTPRequestHandler):
	def do_GET(self):
		if self.path == "/api/":
			self.send_response(200)
			self.send_header("Content-type","application/json")
			self.end_headers()
			self.wfile.write(f'{{"message": "{MESSAGE}"}}\n' .encode())

		elif self.path == "/health":
			self.send_response(200)
			self.send_header("Content-type", "text/plain")
			self.end_headers()
			self.wfile.write(b"OK\n")

		else:
			self.send_response(404)
			self.end_headers()

server = HTTPServer(("0.0.0.0" , PORT), Handler)
server.serve_forever()
