class_name Inventory extends Node

var wood_qty: int = 0
var gold_qty: int = 0
var meat_qty: int = 0

signal inventory_changed

func collect(item: Node2D) -> void:
	if item is Wood:
		wood_qty += 1
		
	if item is Gold:
		gold_qty += 1
		
	if item is Meat:
		meat_qty += 1
		
	inventory_changed.emit()
