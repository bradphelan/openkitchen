require 'delegate'

class Apotomo::StatefulOption < SimpleDelegator
end

class ActionController::Base
  def remember val

    Apotomo::StatefulOption.new(val) unless val.blank?
  end
end
