
# Exporting from REDCap to Python
# I'm not a Python user, but some of us use it to troubleshoot, since Python3 (and the `http.client` package) is already on most Linux computers.

import http.client

conn = http.client.HTTPSConnection("www.redcapplugins.org")

payload = "-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"token\"\r\n\r\nD96029BFCE8FFE76737BFC33C2BCC72E\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"content\"\r\n\r\nrecord\r\n-----011000010111000001101001\r\nContent-Disposition: form-data; name=\"format\"\r\n\r\ncsv\r\n-----011000010111000001101001--"

headers = { 'content-type': "multipart/form-data; boundary=---011000010111000001101001" }

conn.request("POST", "/api/", payload, headers)

res = conn.getresponse()
data = res.read()

print(data.decode("utf-8"))
