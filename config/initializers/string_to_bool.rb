class String
  def to_bool
    %w{ 1 true yes }.include? self.downcase
  end
end
