"""
This example shows two ways to redirect flows to another server.
"""
from mitmproxy import http
from mitmproxy import ctx
import time

def request(flow: http.HTTPFlow) -> None:
    # pretty_host takes the "Host" header of the request into account,
    # which is useful in transparent mode where we usually only have the IP
    # otherwise.
    if flow.request.pretty_host == "base.micro.server.matocloud.com":
        ctx.log.error('''
            --------------------------------
            \   ^__^
            \  (oo)\_______
            (__)\       )\/
            ||----w |
            ||     ||
            
            Time: %s
            Request:%s
            param:%s
            --------------------------------\n''' % (time.strftime('%Y.%m.%d %H:%M:%S',time.localtime(time.time())), flow.request, flow.request.text))
        flow.request.host = "base.micro.server.matocloud.com"
    elif flow.request.pretty_host == "mitm.it":
        flow.request.host = "mitm.it"
    else:
        flow.kill()
