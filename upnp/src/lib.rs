use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn hash(v: Vec<u8>) -> Vec<u8> {
  return blake3::hash(&v).as_bytes().to_vec();
}

