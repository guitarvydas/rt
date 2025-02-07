
import socket
import json
import sys
import struct
import base64
import hashlib
import random

def live_update(key, value):
    """Send live update through websocket 8966
    
    Args:
        key: String key (e.g., "Live", "Info", "✗")
        value: String value to send
    """
    try:
        # Create socket connection
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect(('localhost', 8966))
        
        # Generate random 16-byte key for handshake
        websocket_key = base64.b64encode(bytes([random.randint(0, 255) for _ in range(16)])).decode()
        
        # Send handshake request
        handshake = (
            f"GET / HTTP/1.1\r\n"
            f"Host: localhost:8966\r\n"
            f"Upgrade: websocket\r\n"
            f"Connection: Upgrade\r\n"
            f"Sec-WebSocket-Key: {websocket_key}\r\n"
            f"Sec-WebSocket-Version: 13\r\n"
            f"\r\n"
        )
        sock.send(handshake.encode())
        
        # Wait for handshake response
        response = sock.recv(1024).decode()
        if "101 Switching Protocols" not in response:
            raise Exception("WebSocket handshake failed")

        # Create mevent object with key-value pair
        mevent = [{key: value}]
        json_mev = json.dumps(mevent)
        
        # Create WebSocket frame
        header = bytearray()
        payload_len = len(json_mev)
        
        # First byte: FIN=1, RSV1-3=0, Opcode=1 (text) -> 0x81
        header.append(0x81)
        
        # Second byte: Mask bit and payload length
        if payload_len < 126:
            header.append(0x80 | payload_len)
        elif payload_len < 65536:
            header.append(0x80 | 126)
            header.extend(struct.pack('>H', payload_len))
        else:
            header.append(0x80 | 127)
            header.extend(struct.pack('>Q', payload_len))
            
        # Add masking key (4 bytes)
        mask_key = bytes([0x01, 0x02, 0x03, 0x04])
        header.extend(mask_key)
        
        # Mask the payload
        payload = bytearray(json_mev.encode())
        for i in range(len(payload)):
            payload[i] ^= mask_key[i % 4]
        
        # Send the frame
        sock.send(header + payload)
        
        # Wait briefly for any response
        sock.settimeout(0.1)
        try:
            sock.recv(1024)
        except socket.timeout:
            pass
            
        sock.close()
        
    except Exception as e:
        print(f"Error in live_update: {e}", file=sys.stderr)

# def test_update ():
#     live_update ("Live", "hello")
