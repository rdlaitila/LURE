import haxe.unit.TestCase;

class EventTarget_test extends haxe.unit.TestCase {
    public function test_addEventListener_throws_not_implemented() {
         try {
            var eventTarget = new EventTarget();
            eventTarget.addEventListener(null, null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_dispatchEvent_throws_not_implemented() {
         try {
            var eventTarget = new EventTarget();
            eventTarget.dispatchEvent();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_removeEventListener_throws_not_implemented() {
         try {
            var eventTarget = new EventTarget();
            eventTarget.removeEventListener();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }
}