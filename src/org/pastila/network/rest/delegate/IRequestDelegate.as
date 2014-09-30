package org.pastila.network.rest.delegate {
	import org.pastila.network.rest.Request;
	import org.pastila.network.rest.parser.IRequestDataParser;
	/**
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public interface IRequestDelegate {
		function get request() : Request;

		function set request(request : Request) : void;

		function get parser() : IRequestDataParser;

		function set parser(parser : IRequestDataParser) : void;
		
		function run() : void;

		function destroy() : void;
	}
}
