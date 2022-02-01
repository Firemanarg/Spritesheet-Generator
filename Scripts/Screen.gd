extends PanelContainer


var generated_spritesheet = null

onready var o_button_direction = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/HBoxContainer/CheckButtonDirection"
)
onready var o_label_count = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/LabelCount"
)
onready var o_line_edit_count = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer2/LineEditCount"
)
onready var o_button_generate = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/CenterContainer/HBoxContainer2/ButtonGenerate"
)
onready var o_button_export = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer/CenterContainer/HBoxContainer2/ButtonExport"
)
onready var o_button_open = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer2/HBoxContainer/TextureButtonOpen"
)
onready var o_images_list = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/VBoxContainer2/TextEditImagesList"
)
onready var o_preview_rect = get_node(
	"MarginContainer/VBoxContainer/HBoxContainer/Panel/MarginContainer/PreviewRect"
)
onready var o_file_dialog = get_node("FileDialog")


func _ready():
	_disable_generation()
	_disable_export()


func select_images() -> Array:
	o_file_dialog.clear_filters()
	o_file_dialog.add_filter("*.png ; PNG Images")
	o_file_dialog.popup_centered(Vector2(600, 400))
	return []


func _enable_export():
	o_button_export.disabled = false


func _disable_export():
	o_button_export.disabled = true


func _enable_generation():
	o_button_generate.disabled = false


func _disable_generation():
	o_button_generate.disabled = true


func _on_TextureButtonOpen_pressed():
	select_images()


func _on_FileDialog_files_selected(paths):
	var text = ""
	for path in paths:
		text += path
		text += '\n'
	o_images_list.text = text
	Global.selected_images = paths
	if not Global.selected_images.empty():
		_enable_generation()


func _on_LineEditCount_text_changed(new_text):
	if new_text.empty():
		o_line_edit_count.text = "1"
	else:
		var caret_pos = o_line_edit_count.caret_position
		var text = ""
		for i in range(len(new_text)):
			if new_text[i].is_valid_integer():
				text += new_text[i]
		o_line_edit_count.text = text
		o_line_edit_count.caret_position = caret_pos
	Global.count = int(o_line_edit_count.text)


func _on_ButtonGenerate_pressed():
	generated_spritesheet = Global.generate_spritesheet()
	if generated_spritesheet:
		var texture = ImageTexture.new()
		texture.create_from_image(generated_spritesheet)
		o_preview_rect.texture = texture
		print("Preview size: ", o_preview_rect.texture.get_size())
		_enable_export()


func _on_CheckButtonDirection_toggled(button_pressed):
	if button_pressed:
		o_label_count.text = "Row Count"
		Global.direction = Global.VERTICAL
	else:
		o_label_count.text = "Column Count"
		Global.direction = Global.HORIZONTAL
