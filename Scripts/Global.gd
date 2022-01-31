extends Node


enum {
	HORIZONTAL,
	VERTICAL
}

var selected_images = []
var direction = HORIZONTAL
var count = 1


func generate_spritesheet() -> Image:
	if selected_images.empty():
		return null

	var images = _load_selected_images()
	var largest_size = _get_largest_size(images)

	if direction == HORIZONTAL:
		return _generate_horizontal_spritesheet()
	else:
		return Image.new()


func _load_selected_images() -> Array:
	var images = []
	for path in selected_images:
		var image = Image.new()
		image.load(path)
		images.append(image)
#		print("Loaded image from path '", path, "'")
	return images


func _get_largest_size(images: Array) -> Vector2:
	var largest_size = Vector2(0, 0)
	for image in images:
		var size = image.get_size()
		if size.x > largest_size.x:
			largest_size.x = size.x
		if size.y > largest_size.y:
			largest_size.y = size.y
	return largest_size


func _get_sheet_size() -> Vector2:
	var sheet_size

	if direction == VERTICAL:
		sheet_size = Vector2(
			count,
			ceil(selected_images.size() / float(count))
		)

	return sheet_size

#
#func _copy_image(src: Image, dst: Image, dst_x: int = 0, dst_y: int = 0):
#	var src_size = src.get_size()
#	var dst_size = dst.get_size()
#	for row in range(src_size.x):
#		for col in range(src_size.y):
#			if row < dst_size.x and col < dst_size.y:
#				var pixel = src.get_pixel(row, col)
#				dst.set_pixel(row + dst_x, col + dst_y, pixel)

func _generate_horizontal_spritesheet() -> Image:
	var images = _load_selected_images()
	var largest_size = _get_largest_size(images)
	var spritesheet = Image.new()

	var sheet_size = Vector2(
		count,
		ceil(selected_images.size() / float(count))
	)
	print("Sheet size: ", sheet_size)
	var i = 0
	for row in range(sheet_size.y):
		var sheet_row = Image.new()
		for col in range(sheet_size.x):
			var data
			if i < images.size():
				data = images[i].get_data()
			else:
				data = Image.new()
				data.create(largest_size.x, largest_size.y, false, images[0].get_format())
				data = data.get_data()
			sheet_row.create_from_data(
				(col + 1) * largest_size.x,
				largest_size.y,
				false,
				images[0].get_format(),
				sheet_row.get_data() + data
			)
			i += 1
		print("Test: ", (row + 1) * largest_size.y)
		return sheet_row
#		spritesheet.create_from_data(
#			sheet_size.x * largest_size.x,
#			(row + 1) * largest_size.y,
#			false,
#			images[0].get_format(),
#			spritesheet.get_data() + sheet_row.get_data()
#		)

#	for i in range(images.size()):
#		spritesheet.create_from_data(
#			size.x * largest_size.x,
#			size.y * largest_size.y,
#			false,
#			images[i].get_format(),
#			spritesheet.get_data() + images[i].get_data()
#		)
#		if col >= count:
#			col = 0
#			row += 1
#			size.y += 1
#		if size.x < count:
#			size.x += 1
#
#		pass

#	var sheet_size = Vector2(
#		count,
#		int(selected_images.size() / float(count))
#	)
#	var i = 0
#	print("Sheet size: ", sheet_size)
#	for row in range(int(sheet_size.y)):
#		for col in range(int(sheet_size.x)):
#			if i >= images.size():
#				return spritesheet
#			print("R: ", row, " | C: ", col)
#			spritesheet.create_from_data(
#				(col + 1) * largest_size.x,
#				(row + 1) * largest_size.y,
#				false,
#				images[i].get_format(),
#				spritesheet.get_data() + images[i].get_data()
#			)
#			print("Spritesheet generated from data. Size: ", spritesheet.get_size())
#			i += 1
##			_copy_image(images[i], spritesheet, row * largest_size.x, col * largest_size.y)
	return spritesheet
