package org.pastila.network.rest {
	import org.casalib.core.Destroyable;
	import org.pastila.network.rest.delegate.AbstractRequestDelegate;
	import org.pastila.network.rest.parser.IRequestDataParser;

	public class RestService extends Destroyable {
		protected var _baseURI : String;
		protected var _parser : IRequestDataParser;

		public function RestService(baseURI : String = null, parser : IRequestDataParser = null) {
			_baseURI = baseURI;
			_parser = parser;
		}

		public function get baseURI() : String {
			return _baseURI;
		}

		public function set baseURI(baseURI : String) : void {
			_baseURI = baseURI;
		}

		public function get parser() : IRequestDataParser {
			return _parser;
		}

		public function set parser(parser : IRequestDataParser) : void {
			_parser = parser;
		}

		public function request(request : Request) : Request {
			return new AbstractRequestDelegate(baseURI, request, _parser).request;
		}
	}
}
