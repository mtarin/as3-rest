package org.pastila.network.rest.error {
	/**
	 * @author Ilya Malanin [flashdeveloper(at)pastila.org]
	 */
	public class RequestErrorMessage {
		public static const WRONG_REQUEST : String = "Wrong request data: method name or arguments";
		public static const WRONG_ANSWER : String = "Wrong API answer";
		public static const IO_ERROR : String = "Network I/O error";
		public static const SECURITY_ERROR : String = "Security error";
		public static const MISSING_ANSWER_TYPE : String = "Missing [AnswerData] metadata-tag, or that class hasn't compiled in the application (it has no links in source code)";
		public static const NEED_INHERITANCE : String = "Request must be inherited, not used as pure class";
	}
}
