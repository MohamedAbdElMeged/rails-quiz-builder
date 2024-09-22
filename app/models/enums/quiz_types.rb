# frozen_string_literal: true

class QuizTypes
  MAPPING = {
    'single_answer' => 0,
    'multiple_answer' => 1
  }.freeze
  INVERSE_MAPPING = MAPPING.invert.freeze
  class << self
    # Takes application-scope value and converts it to how it would be
    # stored in the database. Converts invalid values to nil.
    def mongoize(object)
      MAPPING[object]
    end

    # Get the value as it was stored in the database, and convert to
    # application-scope value. Converts invalid values to nil.
    def demongoize(object)
      INVERSE_MAPPING[object]
    end

    # Converts the object that was supplied to a criteria and converts it
    # into a query-friendly form. Returns invalid values as is.
    def evolve(object)
      MAPPING.fetch(object, object)
    end
  end
end
