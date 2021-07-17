extends KinematicBody2D

var paso =  1
var direccion = 1
var origen = 0
var rango = 700
var Jugador = true
var Lastimar_Jugador = false

# Called when the node enters the scene tree for the first time.
func _ready():
	origen = self.position.x


func _physics_process(delta):
	
	if $Duende_Izquierda.is_colliding() and Jugador:
		Jugador = $Duende_Izquierda.get_collider()
		$Sprite.flip_h = true
		if (!Lastimar_Jugador):
			$AnimationPlayer.play("Ataque")
			GlobalVar.Debilitar_Duende = true
			GlobalVar.vida_actual -=  4
			Lastimar_Jugador = true
			yield(get_tree().create_timer(1.2), "timeout")
			Lastimar_Jugador = false
			
	elif $Duende_Derecha.is_colliding() and Jugador:
			Jugador = $Duende_Derecha.get_collider()
			$Sprite.flip_h = false
			if (!Lastimar_Jugador):
				$AnimationPlayer.play("Ataque")
				GlobalVar.Debilitar_Duende = true
				GlobalVar.vida_actual  -= 4
				Lastimar_Jugador = true
				yield(get_tree().create_timer(0.5), "timeout")
				Lastimar_Jugador = false
	
	else:
		_on_Timer_timeout()
		
		
	if GlobalVar.Vida_Goblin <= 0:
		$AnimationPlayer.play("Atauque")
		yield(get_tree().create_timer(0.7), "timeout")
		queue_free()
	
	_on_Timer_timeout()
	

func _on_Timer_timeout():
	if((!$Duende_Derecha.is_colliding()) and (!$Duende_Izquierda.is_colliding())):
		$AnimationPlayer.play("Correr")
		GlobalVar.Debilitar_Duende = false
		self.position.x += paso * direccion
		if self.position.x >= rango + origen or self.position.x < origen - rango:
			direccion *= -1
		if direccion == -1:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
