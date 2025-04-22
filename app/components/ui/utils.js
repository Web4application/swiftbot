/**
 * Hash a string using the Web Crypto API
 * @param {string} algorithm - The hashing algorithm to use (e.g., 'SHA-1').
 * @param {string} message - The message to hash.
 * @returns {Promise<Uint8Array>} - The hash as a Uint8Array.
 */
export async function hash(algorithm, message) {
  const msgUint8 = new TextEncoder().encode(message); // encode as (utf-8) Uint8Array
  const hashBuffer = await crypto.subtle.digest(algorithm, msgUint8); // hash the message
  return new Uint8Array(hashBuffer); // convert buffer to byte array
}
