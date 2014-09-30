package org.pastila.network.rest.parser {
	import org.pastila.network.rest.Request;
	/**
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public interface IRequestDataParser {
		function parse(data : Object, request : Request) : Object;
	}
}
