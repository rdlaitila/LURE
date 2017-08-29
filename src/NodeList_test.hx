import haxe.unit.TestCase;

class NodeList_test extends haxe.unit.TestCase {
    public function test_item_returns_expected_element() {
        var list = new NodeList();
        var node = new Node();

        list.add(node);

        assertEquals(node, list.item(0));
    }

    public function test_item_returns_null_when_no_such_index() {
        var list = new NodeList();
        assertEquals(null, list.item(0));
    }

    public function test_item_throws_TypeError_when_null_index_arg() {
        var list = new NodeList();

        try {
            list.item(null);
        } catch(ex:TypeError) {
            assertTrue(ex != null);
            assertEquals("index cannot be null in call to item", ex.message);
        }
    }

    public function test_arrayaccess_returns_expected_element() {
        var list = new NodeList();
        var node = new Node();

        list.add(node);

        assertEquals(node, list[0]);
    }

    public function test_arrayaccess_returns_expected_length() {
        var list = new NodeList();
        var node = new Node();

        list.add(node);

        assertEquals(1, list.length);
    }

    public function test_entries_throws_not_implemented() {
        try {
            var list = new NodeList();
            list.entries();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

     public function test_forEach_throws_not_implemented() {
        try {
            var list = new NodeList();
            list.forEach();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

    public function test_keys_throws_not_implemented() {
        try {
            var list = new NodeList();
            list.keys();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }

     public function test_values_throws_not_implemented() {
        try {
            var list = new NodeList();
            list.values();
        }
        catch(err:String) {
            assertEquals(Exceptions.NotImplemented, err);
        }
    }
}
