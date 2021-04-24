#!/usr/bin/env coffee

import {uuid} from './deps.js'
import getNetworkAddr from './local_ip.js'
export {join} from "https://deno.land/std@0.95.0/path/mod.ts"


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

do =>
  console.log await getNetworkAddr()
  #console.log uuid.generate()


  udp = Udp()

  decoder = new TextDecoder()
  decode = decoder.decode.bind(decoder)
  udp.receive(new Uint8Array(1472)).then(
    ([msg,remote])=>
      console.log remote
      console.log decode msg
    (err)=>
      console.log err
  )

  {encode} = new TextEncoder()

  buf = encode """M-SEARCH * HTTP/1.1
HOST:239.255.255.250:1900
MAN:"ssdp:discover"
MX:3
ST:urn:schemas-upnp-org:device:InternetGatewayDevice:1""".replace(/\n/g, "\r\n")

  console.log new TextDecoder().decode(buf)
  console.log await udp.send(
    buf
    {
      hostname:"239.255.255.250"
      port:1900
      transport:"udp"
    }
  )
  await new Promise(=>)
