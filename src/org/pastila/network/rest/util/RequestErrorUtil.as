package org.pastila.network.rest.util {
	import org.pastila.network.rest.Request;
	import org.pastila.network.rest.error.RequestErrorData;
	/**
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public class RequestErrorUtil {
		public static function makeError(type : String, data : Object, request : Request) : RequestErrorData {
			var result : RequestErrorData = new RequestErrorData();
			result.message = type;

			result.method = request.method;
			result.arguments = request.arguments;

			result.data = data;

			return result;
		}
	}
}
