package org.pastila.network.rest.parser {
	import org.osflash.vanilla.extract;
	import org.pastila.network.rest.Request;
	import org.pastila.network.rest.error.RequestErrorData;
	import org.pastila.network.rest.error.RequestErrorMessage;
	import org.pastila.network.rest.util.RequestErrorUtil;
	/**
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public class BaseRequestDataParser implements IRequestDataParser {
		protected var _dataField : String;

		public function BaseRequestDataParser() {
		}
		
		public function parse(data : Object, request : Request) : Object {
			const validationResult : RequestErrorData = validateAnswer(data, request);
			
			if (validationResult) return validationResult;

			const requestType : Class = Object(request).constructor as Class;
			const answerType : Class = request.answerType;

			if (requestType == Request) {
				return RequestErrorUtil.makeError(RequestErrorMessage.NEED_INHERITANCE, data, request);
			}

			if (!answerType) {
				return RequestErrorUtil.makeError(RequestErrorMessage.MISSING_ANSWER_TYPE, data, request);
			}

			var result : Object = extract(_dataField ? data[_dataField] : data, answerType);
			trace(JSON.stringify(data));
			return result;
		}

		public function get dataField() : String {
			return _dataField;
		}

		public function set dataField(dataField : String) : void {
			_dataField = dataField;
		}

		protected function validateAnswer(data : Object, request : Request) : RequestErrorData {
			if (!data) return RequestErrorUtil.makeError(RequestErrorMessage.WRONG_ANSWER, data, request);

			return null;
		}
	}
}
