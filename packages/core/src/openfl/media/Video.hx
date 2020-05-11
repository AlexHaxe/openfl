package openfl.media;

#if !flash
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.net.NetStream;

/**
	The Video class displays live or recorded video in an application without
	embedding the video in your SWF file. This class creates a Video object
	that plays either of the following kinds of video: recorded video files
	stored on a server or locally, or live video captured by the user. A Video
	object is a display object on the application's display list and
	represents the visual space in which the video runs in a user interface.
	When used with Flash Media Server, the Video object allows you to send
	live video captured by a user to the server and then broadcast it from the
	server to other users. Using these features, you can develop media
	applications such as a simple video player, a video player with multipoint
	publishing from one server to another, or a video sharing application for
	a user community.

	Flash Player 9 and later supports publishing and playback of FLV files
	encoded with either the Sorenson Spark or On2 VP6 codec and also supports
	an alpha channel. The On2 VP6 video codec uses less bandwidth than older
	technologies and offers additional deblocking and deringing filters. See
	the openfl.net.NetStream class for more information about video playback
	and supported formats.

	Flash Player 9.0.115.0 and later supports mipmapping to optimize runtime
	rendering quality and performance. For video playback, Flash Player uses
	mipmapping optimization if you set the Video object's `smoothing` property
	to `true`.

	As with other display objects on the display list, you can control various
	properties of Video objects. For example, you can move the Video object
	around on the Stage by using its `x` and `y` properties, you can change
	its size using its `height` and `width` properties, and so on.

	To play a video stream, use `attachCamera()` or `attachNetStream()` to
	attach the video to the Video object. Then, add the Video object to the
	display list using `addChild()`.

	If you are using Flash Professional, you can also place the Video object
	on the Stage rather than adding it with `addChild()`, like this:

	1. If the Library panel isn't visible, select Window > Library to display
	it.
	2. Add an embedded Video object to the library by clicking the Options menu
	on the right side of the Library panel title bar and selecting New Video.
	3. In the Video Properties dialog box, name the embedded Video object for
	use in the library and click OK.
	4. Drag the Video object to the Stage and use the Property Inspector to
	give it a unique instance name, such as `my_video`. (Do not name it
	Video.)

	In AIR applications on the desktop, playing video in fullscreen mode
	disables any power and screen saving features (when allowed by the
	operating system).

	**Note:** The Video class is not a subclass of the InteractiveObject
	class, so it cannot dispatch mouse events. However, you can call the
	`addEventListener()` method on the display object container that contains
	the Video object.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Video extends DisplayObject
{
	/**
		Indicates the type of filter applied to decoded video as part of
		post-processing. The default value is 0, which lets the video
		compressor apply a deblocking filter as needed.
		Compression of video can result in undesired artifacts. You can use
		the `deblocking` property to set filters that reduce blocking and, for
		video compressed using the On2 codec, ringing.

		_Blocking_ refers to visible imperfections between the boundaries of
		the blocks that compose each video frame. _Ringing_ refers to
		distorted edges around elements within a video image.

		Two deblocking filters are available: one in the Sorenson codec and
		one in the On2 VP6 codec. In addition, a deringing filter is available
		when you use the On2 VP6 codec. To set a filter, use one of the
		following values:

		* 0—Lets the video compressor apply the deblocking filter as needed.
		* 1—Does not use a deblocking filter.
		* 2—Uses the Sorenson deblocking filter.
		* 3—For On2 video only, uses the On2 deblocking filter but no
		deringing filter.
		* 4—For On2 video only, uses the On2 deblocking and deringing
		filter.
		* 5—For On2 video only, uses the On2 deblocking and a
		higher-performance On2 deringing filter.

		If a value greater than 2 is selected for video when you are using the
		Sorenson codec, the Sorenson decoder defaults to 2.

		Using a deblocking filter has an effect on overall playback
		performance, and it is usually not necessary for high-bandwidth video.
		If a user's system is not powerful enough, the user may experience
		difficulties playing back video with a deblocking filter enabled.
	**/
	public var deblocking(get, set):Int;

	/**
		Specifies whether the video should be smoothed (interpolated) when it
		is scaled. For smoothing to work, the runtime must be in high-quality
		mode (the default). The default value is `false` (no smoothing).
		For video playback using Flash Player 9.0.115.0 and later versions,
		set this property to `true` to take advantage of mipmapping image
		optimization.
	**/
	public var smoothing(get, set):Bool;

	/**
		An integer specifying the height of the video stream, in pixels. For
		live streams, this value is the same as the `Camera.height` property
		of the Camera object that is capturing the video stream. For recorded
		video files, this value is the height of the video.
		You may want to use this property, for example, to ensure that the
		user is seeing the video at the same size at which it was captured,
		regardless of the actual size of the Video object on the Stage.
	**/
	public var videoHeight(get, never):Int;

	/**
		An integer specifying the width of the video stream, in pixels. For
		live streams, this value is the same as the `Camera.width` property of
		the Camera object that is capturing the video stream. For recorded
		video files, this value is the width of the video.
		You may want to use this property, for example, to ensure that the
		user is seeing the video at the same size at which it was captured,
		regardless of the actual size of the Video object on the Stage.
	**/
	public var videoWidth(get, never):Int;

	/**
		Creates a new Video instance. If no values for the `width` and
		`height` parameters are supplied, the default values are used. You can
		also set the width and height properties of the Video object after the
		initial construction, using `Video.width` and `Video.height`. When a
		new Video object is created, values of zero for width or height are
		not allowed; if you pass zero, the defaults will be applied.
		After creating the Video, call the `DisplayObjectContainer.addChild()`
		or `DisplayObjectContainer.addChildAt()` method to add the Video
		object to a parent DisplayObjectContainer object.

		@param width  The width of the video, in pixels.
		@param height The height of the video, in pixels.
	**/
	public function new(width:Int = 320, height:Int = 240):Void
	{
		if (_ == null)
		{
			_ = new _Video(width, height);
		}
	}

	/**
		Specifies a video stream from a camera to be displayed within the
		boundaries of the Video object in the application.
		Use this method to attach live video captured by the user to the Video
		object. You can play the live video locally on the same computer or
		device on which it is being captured, or you can send it to Flash
		Media Server and use the server to stream it to other users.

		**Note:** In an iOS AIR application, camera video cannot be displayed
		when the application uses GPU rendering mode.

		@param camera A Camera object that is capturing video data. To drop
					  the connection to the Video object, pass `null`.
	**/
	// function attachCamera(camera : Camera) : Void;

	/**
		Specifies a video stream to be displayed within the boundaries of the
		Video object in the application. The video stream is either a video
		file played with `NetStream.play()`, a Camera object, or `null`. If
		you use a video file, it can be stored on the local file system or on
		Flash Media Server. If the value of the `netStream` argument is
		`null`, the video is no longer played in the Video object.
		You do not need to use this method if a video file contains only
		audio; the audio portion of video files is played automatically when
		you call `NetStream.play()`. To control the audio associated with a
		video file, use the `soundTransform` property of the NetStream object
		that plays the video file.

		@param netStream A NetStream object. To drop the connection to the
						 Video object, pass `null`.
	**/
	public function attachNetStream(netStream:NetStream):Void
	{
		_.attachNetStream(netStream);
	}

	/**
		Clears the image currently displayed in the Video object (not the
		video stream). This method is useful for handling the current image.
		For example, you can clear the last image or display standby
		information without hiding the Video object.

	**/
	public function clear():Void
	{
		_.clear();
	}

	// Get & Set Methods

	@:noCompletion private function get_deblocking():Int
	{
		return _.deblocking;
	}

	@:noCompletion private function set_deblocking(value:Int):Int
	{
		return _.deblocking = value;
	}

	@:noCompletion private function get_smoothing():Bool
	{
		return _.smoothing;
	}

	@:noCompletion private function set_smoothing(value:Bool):Bool
	{
		return _.smoothing = value;
	}

	@:noCompletion private function get_videoHeight():Int
	{
		return _.videoHeight;
	}

	@:noCompletion private function get_videoWidth():Int
	{
		return _.videoWidth;
	}
}
#else
typedef Video = flash.media.Video;
#end