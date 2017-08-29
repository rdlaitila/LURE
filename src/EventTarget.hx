/**
 *  EventTarget is an interface implemented by objects that can receive events
 *  and may have listeners for them. Element, document, and window are the most
 *  common event targets, but other objects can be event targets too, for example
 *  XMLHttpRequest, AudioNode, AudioContext, and others. Many event targets
 *  (including elements, documents, and windows) also support setting event
 *  handlers via on... properties and attributes.
 *
 *  https://developer.mozilla.org/en-US/docs/Web/API/EventTarget
 */
 @:expose
class EventTarget {
    /**
     *  constructor
     */
    public function new() {
    }

    /**
     *  The EventTarget.addEventListener() method adds the specified EventListener-
     *  compatible object to the list of event listeners for the specified event
     *  type on the EventTarget on which it's called. The event target may be an
     *  Element in a document, the Document itself, a Window, or any other object
     *  that supports events (such as XMLHttpRequest).
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
     *  @param type -
     */
    public function addEventListener(type:DOMString, listener:Any):Void {
        throw Exceptions.NotImplemented;
    }

    /**
     *  Dispatches an Event at the specified EventTarget, invoking the affected
     *  EventListeners in the appropriate order. The normal event processing rules
     *  (including the capturing and optional bubbling phase) also apply to events
     *  dispatched manually with dispatchEvent().
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/dispatchEvent
     *  @return void
     */
    public function dispatchEvent():Void {
        throw Exceptions.NotImplemented;
    }

    /**
     *  The EventTarget.removeEventListener() method removes from the EventTarget
     *  an event listener previously registered with EventTarget.addEventListener().
     *  The event listener to be removed is identified using a combination of the
     *  event type, the event listener function itself, and various optional
     *  options that may affect the matching process; see Matching event listeners
     *  for removal
     *
     *  https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener
     *  @return void
     */
    public function removeEventListener():Void {
        throw Exceptions.NotImplemented;
    }
}