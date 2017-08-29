
/**
 *  The DOMTokenList interface represents a set of space-separated tokens.
 *  Such a set is returned by Element.classList, HTMLLinkElement.relList,
 *  HTMLAnchorElement.relList or HTMLAreaElement.relList. It is indexed beginning
 *  with 0 as with JavaScript Array objects. DOMTokenList is always case-sensitive.
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList
 */
 @:keep
abstract DOMTokenList(Array<DOMString>) {
    /**
     *  constructor
     */
    public function new() {
        this = new Array<DOMString>();
    }
}