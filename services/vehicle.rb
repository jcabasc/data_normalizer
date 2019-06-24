# frozen_string_literal: true

module Services
  class Vehicle # :nodoc:
    attr_reader :year, :make, :model, :trim

    VALID_YEARS = (1900..Time.now.year + 2).to_a
    VALID_MAKES = %w[chevrolet ford].freeze
    VALID_MODELS = %w[focus impala].freeze
    VALID_TRIMS = %w[se st].freeze

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

    %w[year trim make model].each do |attribute|
      define_method("valid_#{attribute}?") do
        if %w[year trim].include?(attribute)
          Kernel
            .const_get("#{self.class}::VALID_#{attribute.upcase}S")
            .include?(send("#{attribute}_criteria"))
        else
          !send('match_value',
                Kernel.const_get("#{self.class}::VALID_#{attribute.upcase}S"),
                send("#{attribute}_criteria")).nil?
        end
      end
    end

    %w[make model year].each do |attribute|
      define_method("normalized_#{attribute}") do
        if send("valid_#{attribute}?")
          return send("#{attribute}_criteria") if attribute == 'year'

          send('match_value',
               Kernel.const_get("#{self.class}::VALID_#{attribute.upcase}S"),
               send("#{attribute}_criteria")).capitalize
        else
          send(attribute)
        end
      end
    end

    def normalized_trim
      return if trim == 'blank'
      return model.upcase.split(' ')[1] if does_model_include_trim?

      valid_trim? ? trim.upcase : trim
    end

    def does_model_include_trim?
      model.split(' ').count > 1
    end

    def year_criteria
      year.to_i
    end

    def make_criteria
      make.downcase
    end

    def model_criteria
      model.downcase.split(' ')[0]
    end

    def trim_criteria
      trim.downcase
    end

    def match_value(collection, value)
      collection.detect { |valid_attribute| valid_attribute.match(/^#{value}/) }
    end
  end
end
