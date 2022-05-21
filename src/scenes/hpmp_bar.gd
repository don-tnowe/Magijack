tool
extends TextureProgress

export(Texture) var texture setget set_texture


func _ready():
  texture_progress = texture_progress.duplicate()
  texture_under = texture_under.duplicate()
  texture_over = texture_over.duplicate()
  set_texture(texture)


func set_texture(v):
  texture = v

  var frame_size = Vector2(v.get_width(), v.get_height() / 3)
  var offset = Vector2.ZERO if !v is AtlasTexture else v.region.position

  texture_progress.atlas = v
  texture_progress.region = Rect2(Vector2(0, 0) + offset, frame_size)
  
  texture_under.atlas = v
  texture_under.region = Rect2(Vector2(0, frame_size.y) + offset, frame_size)
  
  texture_over.atlas = v
  texture_over.region = Rect2(Vector2(0, frame_size.y * 2) + offset, frame_size)


func set_value(v):
	value = v


