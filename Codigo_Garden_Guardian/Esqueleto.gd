extends KinematicBody2D

onready var timer_movimiento = $Timer
onready var sprite = $Sprite
var Jugador = KinematicBody2D
var Lastimar_Jugador = false
var poder = 30
var origen = 0
var rango = 700
var paso =  4
var direccion = 1



# Called when the node enters the scene tree for the first time.
func _ready():
	timer_movimiento.start()
	origen = self.position.x

func _physics_process(delta):

	if $Izquierda.is_colliding() and Jugador:
			Jugador = $Izquierda.get_collider()
			$Sprite.flip_h = true
			if (!Lastimar_Jugador):
				$AnimationPlayer.play("Ataque")
				GlobalVar.vida_actual -=  2
				GlobalVar.Debilitar_esqueleto = true
				Lastimar_Jugador = true
				yield(get_tree().create_timer(1.2), "timeout")
				Lastimar_Jugador = false
			
	elif $Derecha.is_colliding() and Jugador:
			Jugador = $Derecha.get_collider()
			$Sprite.flip_h = false
			if (!Lastimar_Jugador):
				$AnimationPlayer.play("Ataque")
				GlobalVar.vida_actual  -= 2
				GlobalVar.Debilitar_esqueleto = true
				Lastimar_Jugador = true
				yield(get_tree().create_timer(0.5), "timeout")
				Lastimar_Jugador = false
	
	else:
		_on_Timer_timeout()
		
		
	if GlobalVar.vida_Esqueleto <= 0:
		$AnimationPlayer.play("Muerte")
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()


	

func _on_Timer_timeout():
	if((!$Derecha.is_colliding()) and (!$Izquierda.is_colliding())):
		$AnimationPlayer.play("Caminar")
		GlobalVar.Debilitar_esqueleto = false
		self.position.x += paso * direccion
		if self.position.x >= rango + origen or self.position.x < origen - rango:
			direccion *= -1
		if direccion == -1:
			sprite.flip_h = true

		else:
			sprite.flip_h = false
		


