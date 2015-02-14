package com.ukuleledog.games.bayo.elements;
import com.ukuleledog.games.core.AnimatedObject;
import openfl.Assets;
import openfl.events.Event;
import openfl.media.Sound;

/**
 * ...
 * @author matt
 */
class Ennemy extends AnimatedObject
{

	public var hp:UInt;
	private var attacking:Bool = false;
	private var hitSound:Sound;
	
	public function new() 
	{
		super();
		
		hitSound = Assets.getSound( 'snd/EnemyDamageSound.mp3' );
	}
	
	public function hit():Bool
	{
		hitSound.play();
		return ( --hp <= 0 );		
	}
	
	public function die()
	{
		dispatchEvent( new Event( Event.COMPLETE ) );
	}
	
	public function isAttacking() : Bool
	{
		return attacking;
	}
	
	public function attack()
	{
		setAnimation( 'attack' );
		attacking = true;
	}
	
	public function stopAttacking()
	{
		attacking = false;
		setAnimation( 'idle' );
	}
	
}