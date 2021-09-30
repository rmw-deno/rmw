#!/usr/bin/env coffee

# 参考资料: [UPNP自动端口映射的实现](https://blog.csdn.net/zfrong/article/details/3305738)

console.log(location.href)
a = localStorage.getItem "A"
console.log typeof(a),a
console.log localStorage.setItem "A",1

import {encode} from 'utf8'
import __dirname from '~/__dirname.js'
console.log __dirname
console.log Deno.execPath()
console.log new URL(import.meta.url).pathname

###
import {Xml,utf8Decode,utf8Encode} from './deps.js'

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


fetch_xml = (url, options={})=>
  Xml await (await fetch(url, options)).text()

export local_ip = (hostname, port)=>
  # https://github.com/denoland/deno/issues/10519
  # Deno.connect not support transport:"udp"
  socket = await Deno.connect({
    port
    hostname
  })
  socket.close()
  return socket.localAddr.hostname

_control_url = (url)=>
  xml = await fetch_xml url
  url = new URL(url)
  #console.log xml.$

  URLBase = xml.one('URLBase')
  if not URLBase
    URLBase = url.origin

  for x from xml.li('service')
    x = Xml x

    serviceType = x.one('serviceType')
    #r = x.dict ['serviceId','serviceType','controlURL']
    if [
      "urn:schemas-upnp-org:service:WANIPConnection:1"
      "urn:schemas-upnp-org:service:WANPPPConnection:1"
    ].indexOf(serviceType) + 1
      controlURL = URLBase+x.one('controlURL')
      break

  if controlURL
    ip = await local_ip(
      url.hostname
      parseInt(url.port or 80)
    )
    console.log ip

    action = "GetGenericPortMappingEntry"
    r = await fetch_xml(
      controlURL
      {
        method:'POST'
        headers:
          "Content-Type": "text/xml"
          "SOAPAction":"#{serviceType}##{action}"
        body:"""<?xml version="1.0"?>
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:#{action} xmlns:u="#{serviceType}"><NewPortMappingIndex>0</NewPortMappingIndex></u:#{action}></s:Body></s:Envelope>"""
      }
    )
    console.log r.one('u:GetGenericPortMappingEntryResponse')


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


  await udp.send(
    M_SEARCH
    {
      hostname:"239.255.255.250"
      port:1900
      transport:"udp"
    }
  )
  await new Promise(=>)
###
