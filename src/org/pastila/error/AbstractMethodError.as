package org.pastila.error {
	public class AbstractMethodError extends Error {
		public static const MESSAGE : String = "Method should be overriden in subclass";

		public function AbstractMethodError(subClassName : String, methodName : String) {
			super(MESSAGE + " [class=" + subClassName + ", methodName=" + methodName + "]", 0);
		}
	}
}
