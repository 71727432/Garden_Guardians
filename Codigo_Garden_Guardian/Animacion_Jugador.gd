extends KinematicBody2D

var Reducir_vIDA = false
var  state_machine
export var vida_maxima = 100
const ACCELERATION = 70
const MAX_SPEED = 300
const JUMP_H = -1020
const UP = Vector2(0, -1)
const gravity = 40
var Barra_de_vida 
onready var sprite = $Sprite

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")
	Barra_de_vida = $GUI/HP
var motion = Vector2()


func _physics_process(delta):
	Actualizar_Vida()
	motion.y += gravity
	var friction = false
	

	if Input.is_action_pressed("Derecha"):
		sprite.flip_h = false
		state_machine.travel("Caminando")
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		if Input.is_action_just_pressed("Derecha"):
			$Pasos.play()
			$Espada.stop()
			$Salto.stop()
	elif Input.is_action_pressed("Izquierda"):
		state_machine.travel("Caminando")
		sprite.flip_h = true
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		if Input.is_action_just_pressed("Izquierda"):
			$Pasos.play()
			$Espada.stop()
			$Salto.stop()
	elif Input.is_action_pressed("Atacar"):
		state_machine.travel("Ataque")
		motion.x = 350
		if Input.is_action_just_pressed("Atacar"):
			$Espada.play()
		if sprite.flip_h == true:
			motion.x = -350
			if Input.is_action_just_pressed("Atacar"):
				$Espada.play()
			if ($JG_Izquierda.is_colliding()):
				if (!Reducir_vIDA):
					if GlobalVar.Debilitar_esqueleto == true:
						GlobalVar.vida_Esqueleto -= 20
					if GlobalVar.Debilitar_Golem == true:
						GlobalVar.vida_Golem -= 200
					if GlobalVar.Debilitar_Duende == true:
						GlobalVar.Vida_Goblin -= 20
					if GlobalVar.Devilitar_Hongo == true:
						GlobalVar.Vida_Hongo -= 20
					Reducir_vIDA = true
					yield(get_tree().create_timer(1.2), "timeout")
					Reducir_vIDA = false
		if sprite.flip_h == false:
			if ($JG_Derecha.is_colliding()):
				print("Funciona")
				if (!Reducir_vIDA):
					if GlobalVar.Debilitar_esqueleto == true:
						GlobalVar.vida_Esqueleto -= 20
					if GlobalVar.Debilitar_Golem == true:
						GlobalVar.vida_Golem -= 50
					if GlobalVar.Debilitar_Duende == true:
						GlobalVar.Vida_Goblin -= 20
					if GlobalVar.Devilitar_Hongo == true:
						GlobalVar.Vida_Hongo -= 20
					Reducir_vIDA = true
					yield(get_tree().create_timer(1.2), "timeout")
					Reducir_vIDA = false
						
	else:
		state_machine.travel("Quieto")
		friction = true
		$Espada.stop()
		$Pasos.stop()

		
		
	if is_on_floor():
		
		$Salto.stop()
		
		if Input.is_action_just_pressed("Salto_Rapido"):
			motion.y = JUMP_H
			

		if friction == true:
			motion.x = lerp(motion.x, 0, 0.5)
			
		
		if Input.is_action_pressed("Salto_Rapido"):
			$Salto.play()
		
	else:
		state_machine.travel("Salto")
		if friction == true:
			state_machine.travel("Salto")
			motion.x = lerp(motion.x, 0, 0.01)
			

	if Input.is_action_just_pressed("ui_page_down"):
		queue_free()
			
	motion = move_and_slide(motion, UP)
	
	if(get_slide_collision(get_slide_count()-1) != null):
		var Detectar_coallision = get_slide_collision(get_slide_count()-1).collider
		if(Detectar_coallision.is_in_group("Trampa")):
			GlobalVar.vida_actual = 0
			
			
	if GlobalVar.vida_actual <= 0:
		get_tree().change_scene("res://Perdiste.tscn")
	
	if((GlobalVar.vida_Esqueleto <= 0) and (GlobalVar.vida_Golem <= 0) and (GlobalVar.Vida_Goblin <= 0) and (GlobalVar.Vida_Hongo <= 0)):
		get_tree().change_scene("res://Ganaste.tscn")
	

func Actualizar_Vida():
	Barra_de_vida.value = GlobalVar.vida_actual * Barra_de_vida.max_value / vida_maxima


	

