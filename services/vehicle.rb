# require 'active_model'

module Services
  class Vehicle
    attr :year, :make, :model, :trim

    VALID_YEARS = (1900..Time.now.year + 2).to_a
    VALID_MAKES = %w{chevrolet ford}
    VALID_MODELS = %w{focus impala}
    VALID_TRIMS = %w{se st}

    def initialize(attributes)
      attributes.each do |name, value|
        instance_variable_set("@#{name}", value)
      end
    end

    def normalized
      {
        year: normalized_year,
        make: normalized_make,
        model: normalized_model,
        trim: normalized_trim
      }
    end

    private

    def valid_year?
      VALID_YEARS.include?(year.to_i)
    end

    def valid_make?
      !match_value(VALID_MAKES, make.downcase).nil?
    end

    def valid_model?
      !match_value(VALID_MODELS, model.downcase.split(' ')[0]).nil?
    end

    def valid_trim?
      VALID_TRIMS.include?(trim.downcase)
    end

    def does_model_include_trim?
      model.split(' ').count > 1
    end

    def normalized_year
      valid_year? ? year.to_i : year
    end

    def normalized_make
      if valid_make?
        match_value(VALID_MAKES, make.downcase).capitalize
      else
        make
      end
    end

    def normalized_model
      if valid_model?
        match_value(VALID_MODELS, model.downcase.split(' ')[0]).capitalize
      else
        model
      end
    end

    def match_value(collection, value)
      collection.detect{|valid_attribute| valid_attribute.match(/^#{value}/) }
    end

    def normalized_trim
      return if trim == 'blank'

      return trim.upcase if valid_trim?

      return model.upcase.split(' ')[1] if does_model_include_trim?

      trim
    end
  end
end