package org.pastila.network.rest.delegate {
	import org.pastila.network.rest.Request;
	import org.pastila.network.rest.error.RequestErrorData;
	import org.pastila.network.rest.error.RequestErrorMessage;
	import org.pastila.network.rest.parser.IRequestDataParser;
	import org.pastila.network.rest.rest_internal;
	import org.pastila.network.rest.util.RequestErrorUtil;

	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	/**
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public class AbstractRequestDelegate implements IRequestDelegate {
		protected var _request : Request;
		protected var _parser : IRequestDataParser;
		protected var _baseURI : String;
		protected var _requestMethod : String = URLRequestMethod.POST;
		protected var _running : Boolean;

		protected var loader : URLLoader;
		protected var _errored : Boolean;
		protected var _error : RequestErrorData;

		public function AbstractRequestDelegate(baseURI : String, request : Request = null, parser : IRequestDataParser = null) {
			_baseURI = baseURI;
			_parser = parser;
			_request = request;
		}

		public function get request() : Request {
			return _request;
		}

		public function set request(request : Request) : void {
			_request = request;
		}

		public function get parser() : IRequestDataParser {
			return _parser;
		}

		public function set parser(parser : IRequestDataParser) : void {
			_parser = parser;
		}

		public function destroy() : void {
			clear();

			_parser = null;
			_running = false;
		}

		protected function clear() : void {
			destroyRequest();
			destroyLoader();
		}

		public function run() : void {
			if (_running) {
				throw IllegalOperationError("Request delegation is already in progress.");
			}

			_errored = false;

			if (loader) destroyLoader();

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;

			loader.addEventListener(Event.OPEN, onOpen);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpResponseStatus);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.load(constructRequest());
		}

		protected function onSecurityError(event : SecurityErrorEvent) : void {
			if (_errored) {
				handleError(_error);
			} else {
				handleError(RequestErrorUtil.makeError(RequestErrorMessage.SECURITY_ERROR, event, request));
			}
			_running = false;
		}

		protected function onIoError(event : IOErrorEvent) : void {
			if (_errored) {
				handleError(_error);
			} else {
				handleError(RequestErrorUtil.makeError(RequestErrorMessage.IO_ERROR, event, request));
			}
			_running = false;
		}

		protected function onHttpResponseStatus(event : HTTPStatusEvent) : void {
			switch (event.status) {
				case 500:
					_errored = true;
					_error = RequestErrorUtil.makeError(RequestErrorMessage.IO_ERROR, "Internal server error (HTTP status: 500)", request);
					break;
				case 404:
					_errored = true;
					_error = RequestErrorUtil.makeError(RequestErrorMessage.IO_ERROR, "Internal server error (HTTP status: 500)", request);
					break;
				default:
					break;
			}
		}

		protected function onOpen(event : Event) : void {
			_running = true;
		}

		protected function onComplete(event : Event) : void {
			if (_errored) {
				handleError(_error);
			} else {
				const data : String = loader.data;
				const result : Object = parse(data);
				if (result is RequestErrorData) {
					handleError(result as RequestErrorData);
				} else {
					handleResult(result);
				}
			}

			_running = false;
		}

		protected function destroyRequest() : void {
			if (request) {
				request.destroy();
				request = null;
			}
		}

		protected function destroyLoader() : void {
			if (loader) {
				loader.removeEventListener(Event.OPEN, onOpen);
				loader.removeEventListener(Event.COMPLETE, onComplete);
				loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpResponseStatus);
				loader.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				try {
					if (_running) {
						loader.close();
					}
				} catch (e : Error) {
				}
			}
		}

		protected function handleResult(result : Object) : void {
			if (request) {
				request.rest_internal::handleResult(result);
			}

			clear();
		}

		protected function handleError(error : RequestErrorData) : void {
			if (request) {
				request.rest_internal::handleError(error);
			}

			clear();
		}

		protected function parse(data : String) : Object {
			throw new IllegalOperationError("Method parse() must be overriden");
		}

		protected function constructRequest() : URLRequest {
			throw new IllegalOperationError("Method constructRequest() must be overriden");
		}
	}
}
