import haxe.Timer;

class StopWatch{
    public var ms: Float;
    public var seconds(get_seconds,null):Float;
    private var timer: Timer;
    private var startTime:Int;
    private var preText:String;
    private var lastStamp:Float;
    
    public inline function new(preText:String='')
    {
        timer = new Timer(1);
        timer.run();
        this.preText = preText;
        lastStamp = 0;
    }
    
    public inline function stop():String
    {
        timer.stop();
        ms = getStamp();
        return(preText+" "+Std.string(ms)+" ms.");
    }
    
    public inline function get_seconds():Float
    {
        return ms/1000;
    }
    
    public inline function getStamp():Float{
        var s:Float = Timer.stamp() - lastStamp;
        lastStamp = Timer.stamp();
        return s;
    }
    
    public inline function toString():String
    {
        return(preText+" "+Std.string(ms));
    }
}