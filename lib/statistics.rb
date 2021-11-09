module Statistics
  def best_key(hash)
    hash.max_by {|key, value| value}.first
  end

  def worst_key(hash)
    hash.min_by {|key, value| value}.first
  end
end
