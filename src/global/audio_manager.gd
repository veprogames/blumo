extends AudioStreamPlayer


func play_stream(audio_stream: AudioStream, db: float = 0.0, pitch: float = 1.0) -> void:
	play()
	var playback: AudioStreamPlaybackPolyphonic = get_stream_playback()
	if !playback:
		return
	playback.play_stream(audio_stream, db, pitch)
