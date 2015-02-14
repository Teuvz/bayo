package com.ukuleledog.games.bayo.elements;
import haxe.Timer;
import motion.Actuate;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.TimerEvent;

/**
 * ...
 * @author matt
 */
class Tamogoro extends Ennemy
{

	private var loopTimer:openfl.utils.Timer;
	private var loopCounter:UInt = 0;
	
	public function new( _hp:UInt ) 
	{
		super();
		hp = _hp;
			
		bmd = Assets.getBitmapData('img/ennemy.png');
		
		createAnimation( 'idle', 0, 64, 4, 16, 64, 0.2 );
		createAnimation( 'damage', 256, 64, 1, 16, 64 );
		createAnimation( 'attack', 0, 192, 5, 25, 64, 0.1, false );
		
		animate();
		
		loopTimer = new openfl.utils.Timer( 200 );
		loopTimer.addEventListener( TimerEvent.TIMER, loop );
		
		addEventListener( Event.ADDED_TO_STAGE, init );
	}
	
	private function init( e:Event )
	{
		loopTimer.start();
	}
	
	override public function die()
	{
		setAnimation( 'damage' );
		this.alpha = 0.6;
		Timer.delay( function() { 
			dispatchEvent( new Event( Event.COMPLETE ) ); 
		}, 300 );
	}
	
	public function loop( e:TimerEvent )
	{		
		this.y += Math.sin( loopCounter++ ) * ( ( Math.ceil( Math.random() * 10 ) ) );
	}
	
	override public function attack()
	{
		setAnimation( 'attack' );
		attacking = true;
		Actuate.tween( this, 0.2, { y: 180 } );
	}
	
}