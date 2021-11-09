module Statistics
  def win_percentage(wins, losses)
    win_percentage = (wins)/ (wins + losses)
  end

  def best_key(hash)
    hash.max_by {|key, value| value}.first
  end

  def worst_key(hash)
    hash.min_by {|key, value| value}.first
  end
end
