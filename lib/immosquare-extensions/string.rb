class String

  def to_boolean
    case downcase
    when "true"
      true
    when "false"
      false
    end
  end 

end