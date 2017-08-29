/**
 *  DOMString is a UTF-16 String. As JavaScript already uses such strings, DOMString
 *  is mapped directly to a String. Passing null to a method or parameter accepting
 *  a DOMString typically stringifies to "null".
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/DOMString
 */
typedef DOMString = String;