module RecordSelect
  # a write-once configuration object
  class Config
    def initialize(klass, options = {})
      @klass = klass

      @notify = block_given? ? proc : options[:notify]

      @per_page = options[:per_page]

      options[:search_on] = [options[:search_on]] if options[:search_on] and not options[:search_id].is_a? Array
      @search_on = options[:search_on]
    end

    # The model object we're browsing
    def model
      @model ||= klass.camelcase.constantize
    end

    # Records to show on a page
    def per_page
      @per_page ||= 10
    end

    # The method name or proc to notify of a selection event.
    # May not matter if the selection event is intercepted client-side.
    def notify
      @notify
    end

    # A collection of fields to search. This is essentially raw SQL, so you could search on "CONCAT(first_name, ' ', last_name)" if you wanted to.
    def search_on
      @search_on ||= self.model.columns.collect{|c| c.name if [:text, :string].include? c.type}.compact
    end

    protected

    # A singularized underscored version of the model we're browsing
    def klass
      @klass
    end
  end
end