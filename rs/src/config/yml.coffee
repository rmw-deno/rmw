#!/usr/bin/env coffee

import { join } from "https://deno.land/std/path/mod.ts"
import { existsSync, ensureDirSync } from "https://deno.land/std/fs/mod.ts"
import { parse, stringify } from "https://deno.land/std/encoding/yaml.ts"

import DATA from '../const/dir/data'

{readTextFileSync,writeTextFileSync} = Deno


CONFIG_YML = join DATA, "config.yml"


if existsSync(CONFIG_YML)
  CONFIG = parse readTextFileSync(CONFIG_YML)
else
  CONFIG = {}
  ensureDirSync(DATA)

export default new Proxy(
  CONFIG
  {

  get:(self, attr)=>
    self[attr]

  set:(self, attr, val)=>
    if val == undefined
      if val of self
        delete self[attr]
      else
        return self
    else if val != self[attr]
      self[attr] = val
    else
      return self

    writeTextFileSync(
      CONFIG_YML
      stringify self
    )
    return self

  }
)
