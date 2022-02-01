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


func _copy_image(src: Image, dst: Image, dst_x: int = 0, dst_y: int = 0):
	var src_size = src.get_size()
	dst.lock()
	src.lock()
	for x in range(src.get_width()):
		for y in range(src.get_height()):
			var pixel = src.get_pixel(x, y)
			dst.set_pixel(x + dst_x, y + dst_y, pixel)
	src.unlock()
	dst.unlock()
#	var src_size = src.get_size()
#	var dst_size = dst.get_size()
#	for x in range(src_size.x):
#		for y in range(src_size.y):
#			if x < dst_size.x and col < dst_size.y:
#				var pixel = src.get_pixel(row, col)
#				dst.set_pixel(row + dst_x, col + dst_y, pixel)

func _generate_horizontal_spritesheet() -> Image:
	var images = _load_selected_images()
	var image_size = _get_largest_size(images)
	var format = images[0].get_format()
	var spritesheet = Image.new()
	spritesheet.create(image_size.x * images.size(), image_size.y, false, format)
	spritesheet.lock()
	spritesheet.fill(Color.transparent)
	spritesheet.unlock()

	spritesheet.lock()
	for i in range(images.size()):
		var image: Image = images[i]
		print("Copying image ", i)
		image.lock()
		for x in range(image.get_width()):
			for y in range(image.get_height()):
				var pixel = image.get_pixel(x, y)
				spritesheet.set_pixel(x + (image_size.x * i), y, pixel)
		image.unlock()
		print("Finished copying image ", i)
	spritesheet.unlock()

	return spritesheet

