extends CharacterBody2D 

# Constantes de configuración física 
const SPEED: float = 100.0 
const JUMP_VELOCITY: float = -400.0 

# Referencias directas a nodos hijos 
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D 

# Variable para almacenar las monedas recolectadas 
var monedas: int = 0 

func _physics_process(delta: float) -> void: 
	# 1. Aplicación de gravedad en el aire 
	if not is_on_floor(): 
		velocity += get_gravity() * delta 

	# 2. Control de salto 
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY 

	# 3. Lectura de entrada horizontal 
	var direction := Input.get_axis("ui_left", "ui_right") 
	if direction != 0: 
		velocity.x = direction * SPEED 
		# Inversión de orientación: 
		# Debido a que el arte base mira hacia la izquierda, 
		# volteamos horizontalmente solo cuando avanza a la derecha (direction > 0). 
		sprite.flip_h = direction < 0 
	else: 
		velocity.x = move_toward(velocity.x, 0, SPEED) 

	# 4. Actualización del estado de animación 
	actualizar_animaciones(direction) 

	# 5. Ejecución del movimiento físico 
	move_and_slide() 

func actualizar_animaciones(direction: float) -> void: 
	if not is_on_floor(): 
		sprite.play("jump") 
	elif direction != 0: 
		sprite.play("run")
	else: 
		sprite.play("idle") 

func sumar_moneda() -> void: 
	monedas += 1 
	# Actualiza el HUD si existe en el árbol de nodos 
	var texto_monedas: Label = get_tree().root.find_child("ContadorMonedas", true, false) 
	if texto_monedas: 
		texto_monedas.text = "Monedas: " + str(monedas)
