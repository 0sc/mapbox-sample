class Museum
  attr_reader :name, :postcode

  def initialize(name: , postcode:)
    @name = name
    @postcode = postcode
  end
end
