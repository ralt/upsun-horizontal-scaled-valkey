import base64
from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os

import redis

# Get Valkey connection info from relationships
# Note: In Upsun, relationships are available via PLATFORM_RELATIONSHIPS
relationships = json.loads(base64.b64decode(
    os.environ.get('PLATFORM_RELATIONSHIPS', '{}')
))

# Connect to Valkey cluster
valkey_nodes = []
if 'valkey' in relationships:
    for instance in relationships['valkey'][0]['instance_ips']:
        valkey_nodes.append({
            'host': instance,
            'port': 6379  # Valkey port
        })

# Create Redis cluster client
if valkey_nodes:
    # For cluster mode, use RedisCluster
    from redis.cluster import RedisCluster
    redis_client = RedisCluster(
        startup_nodes=[
            {'host': node['host'], 'port': node['port']}
            for node in valkey_nodes
        ],
        decode_responses=True
    )
else:
    redis_client = None
    print("WARNING: No Valkey relationship found")

class RequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()

            html = "<h1>Python + Valkey Cluster</h1>"

            if redis_client:
                try:
                    # Test connection
                    redis_client.set('test_key', 'Hello from Valkey Cluster!')
                    value = redis_client.get('test_key')

                    # Get cluster info
                    cluster_info = redis_client.cluster_info()

                    html += f"<p>✅ Connected to Valkey Cluster!</p>"
                    html += f"<p>Test value: {value}</p>"
                    html += f"<h2>Cluster Info:</h2>"
                    html += f"<pre>{json.dumps(cluster_info, indent=2)}</pre>"
                except Exception as e:
                    html += f"<p>❌ Error connecting to Valkey: {str(e)}</p>"
            else:
                html += "<p>❌ Valkey not configured</p>"

            self.wfile.write(html.encode())

        elif self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'OK')
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        # Print logs to stdout
        print(f"{self.address_string()} - {format % args}")

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8888))
    server = HTTPServer(('0.0.0.0', port), RequestHandler)
    print(f"Python app listening on port {port}")
    print(f"Valkey nodes: {valkey_nodes}")
    server.serve_forever()
