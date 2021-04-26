#!/usr/bin/env coffee

import {extractXml,utf8Decode,utf8Encode} from './deps.js'

M_SEARCH = utf8Encode """M-SEARCH * HTTP/1.1
HOST:239.255.255.250:1900
MAN:"ssdp:discover"
MX:3
ST:urn:schemas-upnp-org:device:InternetGatewayDevice:1""".replace(/\n/g, "\r\n")

Udp = =>
  udp = Deno.listenDatagram {
    port: 0
    transport: "udp"
    hostname: "0.0.0.0"
  }

  {addr} = udp
  {transport,hostname,port} = addr
  #console.log "#{transport}://#{hostname}:#{port}"
  udp


_control_url = (url)=>
  xml = await (await fetch(url)).text()
  URLBase = extractXml.one(xml, 'URLBase')
  for i from extractXml.li(xml, 'service')
    console.log i

do =>
  udp = Udp()

  udp.receive(new Uint8Array(1472)).then(
    ([msg,remote])=>
      msg = utf8Decode msg
      msg = msg.replace(/\r/g,'').split("\n")
      for i from msg
        if i.startsWith("LOCATION:")
          url = i.slice(9).trim()
          break
      if url
        _control_url url

    (err)=>
      console.log err
  )


  console.log await udp.send(
    M_SEARCH
    {
      hostname:"239.255.255.250"
      port:1900
      transport:"udp"
    }
  )
  await new Promise(=>)
