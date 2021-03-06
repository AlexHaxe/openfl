package openfl.desktop;

#if !flash

#if !openfljs
@:enum abstract ClipboardTransferMode(Null<Int>)
{
	public var CLONE_ONLY = 0;
	public var CLONE_PREFERRED = 1;
	public var ORIGINAL_ONLY = 2;
	public var ORIGINAL_PREFERRED = 3;

	@:from private static function fromString(value:String):ClipboardTransferMode
	{
		return switch (value)
		{
			case "cloneOnly": CLONE_ONLY;
			case "clonePreferred": CLONE_PREFERRED;
			case "originalOnly": ORIGINAL_ONLY;
			case "originalPreferred": ORIGINAL_PREFERRED;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : ClipboardTransferMode)
		{
			case ClipboardTransferMode.CLONE_ONLY: "cloneOnly";
			case ClipboardTransferMode.CLONE_PREFERRED: "clonePreferred";
			case ClipboardTransferMode.ORIGINAL_ONLY: "originalOnly";
			case ClipboardTransferMode.ORIGINAL_PREFERRED: "originalPreferred";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract ClipboardTransferMode(String) from String to String
{
	public var CLONE_ONLY = "cloneOnly";
	public var CLONE_PREFERRED = "clonePreferred";
	public var ORIGINAL_ONLY = "originalOnly";
	public var ORIGINAL_PREFERRED = "originalPreferred";
}
#end
#else
typedef ClipboardTransferMode = flash.desktop.ClipboardTransferMode;
#end
