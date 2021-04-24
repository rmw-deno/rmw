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
  console.log uuid.generate()

  udp1 = Udp()
  setTimeout(
    =>
      loop
        [data, remote] = await udp1.receive(
          new Uint8Array(1400)
        )
  )

  n = 0
  msg = []
  {encode} = new TextEncoder()
  while ++n<2048
    udp2 = Udp()
    msg.push n%10
    udp2.send(
      encode msg.join ''
      {
        hostname: "127.0.0.1"
        port:udp1.addr.port
        transport:"udp"
      }
    )
  console.log "done"
