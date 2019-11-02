class GameState
  def as_json(options = {})
    self.class.name
  end
end