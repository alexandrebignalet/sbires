class InMemoryRepository
  def initialize
    @by_id = {}
  end

  def get(id)
    @by_id[id]
  end

  def add(entity)
    @by_id[entity.id] = entity
  end
end