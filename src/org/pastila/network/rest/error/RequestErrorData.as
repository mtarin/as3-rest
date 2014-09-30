package org.pastila.network.rest.error {
	import org.pastila.utils.json.formatJSON;
	/**
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public class RequestErrorData {
		/**
		 * Request method
		 */
		public var method : String;
		/**
		 * Request arguments
		 */
		public var arguments : Object;
		/**
		 * Error message
		 */
		public var message : String;
		/**
		 * Answer data, if present.
		 */
		public var data : Object;

		public function RequestErrorData() {
		}

		
		public function toString() : String {
			return [
				'[RequestErrorData(',
				'message = ' + message + ',',
				'method = "' + method + '",',
				'arguments = \n' + formatJSON(JSON.stringify(arguments), true) + ',',
				'data = \n' + formatJSON(JSON.stringify(data), true),
				")]"
			].join("\n");
		}
		
	}
}
