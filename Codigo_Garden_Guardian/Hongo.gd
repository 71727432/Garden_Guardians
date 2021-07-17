extends KinematicBody2D

onready var timer_movimiento = $Timer
onready var sprite = $Sprite
var origen = 0
var rango = 450
var paso =  4
var direccion = 1
var jugador = true
var lastimar_jugador = false




# Called when the node enters the scene tree for the first time.
func _ready():
	timer_movimiento.start()
	origen = self.position.x
	
	
func _physics_process(delta):

	if $Hongo_Derecha.is_colliding() and jugador :
		jugador = $Hongo_Derecha .get_collider()
		$Sprite .flip_h = false 
		if (!lastimar_jugador) :
			$AnimationPlayer .play("Ataque")
			GlobalVar .vida_actual -=7
			GlobalVar.Devilitar_Hongo = true 	
			lastimar_jugador = true 
			yield(get_tree().create_timer(1.1), "timeout")
			lastimar_jugador = false

	elif $Hongo_izquierda.is_colliding()  and jugador :
		jugador = $Hongo_izquierda .get_collider()
		$Sprite .flip_h = true
		if (!lastimar_jugador) :
			$AnimationPlayer .play("Ataque")
			GlobalVar .vida_actual -=	7 
			GlobalVar.Devilitar_Hongo = true	
			lastimar_jugador = true 
			yield(get_tree().create_timer(1.1), "timeout")
			lastimar_jugador = false
			
	else:
		_on_Timer_timeout()
		
	if GlobalVar.Vida_Hongo <= 0:
		$AnimationPlayer.play("Muerte")
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()



func _on_Timer_timeout():
	if((!$Hongo_Derecha.is_colliding()) and (!$Hongo_izquierda.is_colliding())):
		$AnimationPlayer.play("Caminar")
		GlobalVar.Devilitar_Hongo = false
		self.position.x += paso * direccion
		if self.position.x >= rango + origen or self.position.x < origen - rango:
			direccion *= -1
		if direccion == -1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
