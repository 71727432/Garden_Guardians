extends KinematicBody2D

onready var timer_movimiento = $Timer
onready var sprite = $Sprite
var origen = 0
var rango = 700
var paso =  4
var direccion = 1
var jugador = true
var lastimar_jugador = false




# Called when the node enters the scene tree for the first time.
func _ready():
	timer_movimiento.start()
	origen = self.position.x
	
	
func _physics_process(delta):

	if $Golem_derecha.is_colliding() and jugador :
		jugador = $Golem_derecha .get_collider()
		$Sprite .flip_h = false 
		if (!lastimar_jugador) :
			$AnimationPlayer .play("Ataque_Enemigo")
			GlobalVar .vida_actual -=10
			GlobalVar.Debilitar_Golem = true 	
			lastimar_jugador = true 
			yield(get_tree().create_timer(1.1), "timeout")
			lastimar_jugador = false

	elif $Golem_Izquierda.is_colliding()  and jugador :
		jugador = $Golem_Izquierda .get_collider()
		$Sprite .flip_h = true
		if (!lastimar_jugador) :
			$AnimationPlayer .play("Ataque_Enemigo")
			GlobalVar .vida_actual -=10 
			GlobalVar.Debilitar_Golem = true	
			lastimar_jugador = true 
			yield(get_tree().create_timer(1.1), "timeout")
			lastimar_jugador = false
			
	else:
		_on_Timer_timeout()
		
	if GlobalVar.vida_Golem <= 0:
		$AnimationPlayer.play("Enemigo_Death")
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()
		
		

func _on_Timer_timeout():
	if((!$Golem_derecha.is_colliding()) and (!$Golem_Izquierda.is_colliding())):
		$AnimationPlayer.play("Enemy_Caminando")
		GlobalVar.Debilitar_Golem = false
		self.position.x += paso * direccion
		if self.position.x >= rango + origen or self.position.x < origen - rango:
			direccion *= -1
		if direccion == -1:
			sprite.flip_h = true
		else:
			sprite.flip_h = false

