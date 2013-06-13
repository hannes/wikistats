package nl.cwi.da.wikistat;

import java.io.IOException;
import java.net.URLDecoder;

import org.apache.pig.EvalFunc;
import org.apache.pig.data.Tuple;

public class UrlDecode extends EvalFunc<String> {
	public String exec(Tuple input) throws IOException {
		if (input == null || input.size() == 0)
			return null;
		try {
			String str = (String) input.get(0);
			return URLDecoder.decode(str, "UTF-8");
		} catch (Exception e) {
			return ":";
		}
	}
}