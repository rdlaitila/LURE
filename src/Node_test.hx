import haxe.unit.TestCase;

class Node_test extends haxe.unit.TestCase {
    public function test_appendChild_throws_not_implemented() {
        try {
            var node = new Node();
            node.appendChild(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_cloneNode_throws_not_implemented() {
        try {
            var node = new Node();
            node.cloneNode(false);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_compareDocumentPosition_throws_not_implemented() {
        try {
            var node = new Node();
            node.compareDocumentPosition(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_contains_throws_not_implemented() {
        try {
            var node = new Node();
            node.contains(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_hasChildNodes_throws_not_implemented() {
        try {
            var node = new Node();
            node.hasChildNodes();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_insertBefore_throws_not_implemented() {
        try {
            var node = new Node();
            node.insertBefore(null, null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_isDefaultNamespace_throws_not_implemented() {
        try {
            var node = new Node();
            node.isDefaultNamespace(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_isEqualNode_throws_not_implemented() {
        try {
            var node = new Node();
            node.isEqualNode(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_isSameNode_throws_not_implemented() {
        try {
            var node = new Node();
            node.isSameNode(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_lookupNamespaceURI_throws_not_implemented() {
        try {
            var node = new Node();
            node.lookupNamespaceURI(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_lookupPrefix_throws_not_implemented() {
        try {
            var node = new Node();
            node.lookupPrefix();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_normalize_throws_not_implemented() {
        try {
            var node = new Node();
            node.normalize();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_removeChild_throws_not_implemented() {
        try {
            var node = new Node();
            node.removeChild(null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_replaceChild_throws_not_implemented() {
        try {
            var node = new Node();
            node.replaceChild(null, null);
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }
}