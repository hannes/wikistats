package nl.cwi.da.wikistat.test;

import static org.junit.Assert.assertEquals;

import java.io.IOException;

import nl.cwi.da.wikistat.UrlDecode;

import org.apache.pig.data.DefaultTuple;
import org.apache.pig.data.Tuple;
import org.junit.Test;

public class UrlDecodeTest {
	@Test
	public void urlDecodeTest() throws IOException {
		Tuple t = new DefaultTuple();
		t.append("asdf%20asdf");

		String decoded = new UrlDecode().exec(t);
		assertEquals("asdf asdf", decoded);
	}
}
