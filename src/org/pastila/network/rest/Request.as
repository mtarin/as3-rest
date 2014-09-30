package org.pastila.network.rest {
	import org.pastila.error.AbstractMethodError;
	import org.pastila.network.rest.error.RequestErrorData;
	/**
	 * <p>REST-API Request<br>
	 * Base class for building your own REST-API requests.</p>
	 * 
	 * <p>The most appropriate use of this class is inheritance for your own requests. <strong>You must not use this class as pure!</strong><br>
	 * You always should remember to override getter method "answerType": 
	 * <listing>
	 * override public function get answerType() : Class {
	 * 		return AnswerData;
	 * }  
	 * </listing>
	 *  
	 * It is responsible for appropriate parsing of answer on your request.</p>
	 * <listing>
	 * package org.name.app.network.data {
	 * 	public class UserData {
	 * 		public var uid : String;
	 * 		public var userName : String;
	 * 		public var isGuest : Boolean;
	 * 		public var friends : Vector.<FriendData>;
	 * 	}
	 * }
	 * 
	 * package org.name.app.network.requests {
	 * 	public class GetUserDataRequest extends Request {
	 * 		import org.name.app.network.data.UserData;
	 * 		public static const METHOD : String = "authorize";
	 * 		
	 * 		public function GetUserDataRequest(userId : String) : void {
	 * 			super(METHOD, {userId: userId});
	 * 		}
	 * 		
	 * 		override public function get answerType() : Class {
	 * 			return UserData;
	 * 		}  
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public class Request {
		/**
		 * Request method name
		 */
		protected var _method : String;
		/**
		 * Request arguments
		 */
		protected var _arguments : Object;
		
		protected var _onComplete : Function;
		protected var _onError : Function;
		protected var _onSuccess : Function;

		public function Request(method : String, arguments : Object = null) {
			_method = method;
			_arguments = arguments || {};
			_arguments["r"] = String(Math.random());
		}
		
		/**
		 * Request method name
		 */
		public function get method() : String {
			return _method;
		}

		public function set method(method : String) : void {
			_method = method;
		}

		/**
		 * Request arguments
		 */
		public function get arguments() : Object {
			return _arguments;
		}

		public function set arguments(arguments : Object) : void {
			_arguments = arguments;
		}

		/**
		 * <p>Getter answerType defines the target Data-class, which will be created and configured as answer data for the request.</p>
		 * <p><strong>You should always remember to override it, without invoking of super.answerType</strong></p>
		 */
		public function get answerType() : Class {
			throw new AbstractMethodError(Object(this).constructor.toString(), "answerType");
		}
		/**
		 * <p>Callback function will be called only if request was succeed. It takes parsed answer data as parameter.</p>
		 * 
		 * <listing>
		 * const request : Request = api.request(
		 * 		new LifeRequest("The Ultimate Question of Life")
		 * 		.onSuccess(onUltimateQuestionAnswer)
		 * )
		 * 
		 * function onUltimateQuestionAnswer(data : LifeData) {
		 * 	logger.info("Ultimate Question of Life Answer: " + data.answer);
		 * }
		 * </listing>
		 */
		public function onSuccess(handler : Function) : Request {
			_onSuccess = handler;
			return this;
		}

		/**
		 * <p>Callback function will be called only if request was not succeed. It takes <code>RequestErrorData</code> as parameter.</p>
		 * 
		 * <listing>
		 * const request : Request = api.request(
		 * 		new LifeRequest("The Ultimate Question of Life")
		 * 		.onError(onUltimateQuestionError)
		 * );
		 * 
		 * function onUltimateQuestionError(error : RequestErrorData) {
		 * 	logger.error("A wild error appears: ", error); 
		 * }
		 * </listing>
		 * 
		 * @see org.pastila.net.rest.error.RequestErrorData 
		 */
		public function onError(handler : Function) : Request {
			_onError = handler;
			return this;
		}

		/**
		 * <p>Callback function will be called in any case. It takes two parameters, the first one is result of request and the second is <code>RequestErrorData</code>.
		 * Only one of this parameters will be passed, depends on request result.</p>
		 * 
		 * <listing>
		 * const request : Request = api.request(
		 * 		new LifeRequest("The Ultimate Question of Life")
		 * 		.onComplete(onUltimateQuestionRequestComplete)
		 * 	);
		 * 
		 * function onUltimateQuestionRequestComplete(data : LifeData, error : RequestErrorData) {
		 * 	if (error) {
		 * 		logger.error("A wild error appears: ", error);
		 * 	} else {
		 * 		logger.info("Ultimate Question of Life Answer: " + data.answer);
		 * 	} 
		 * }
		 * </listing>
		 * 
		 * @see org.pastila.net.rest.error.RequestErrorData 
		 */
		public function onComplete(handler : Function) : Request {
			_onComplete = handler;
			return this;
		}

		public function destroy() : void {
			_onComplete = null;
			_onError = null;
			_onSuccess = null;
		}

		rest_internal function handleResult(result : Object) : void {
			if (_onSuccess != null) _onSuccess(result);
			if (_onComplete != null) _onComplete(result, null);
		}

		rest_internal function handleError(error : RequestErrorData) : void {
			if (_onError != null) _onError(error);
			if (_onComplete != null) _onComplete(null, error);
		}
	}
}
