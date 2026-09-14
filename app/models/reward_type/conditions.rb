class RewardType::Conditions
  CONJUNCTION_MAP = { 'and' => :all?, 'or' => :any? }.freeze

  attr_reader :config, :errors
  private :config

  def initialize(config)
    @config = config.deep_symbolize_keys
    @errors = []
  end

  def call(sources = {})
    enriched_variables = variables.map { |v| [v.name, v.enrich(sources)] }.to_h
    checks = operations.map { |o| o.check(enriched_variables) }

    checks.send(conjunction)
  end

  def valid?
    return true if config.empty?

    validate!

    @errors.empty?
  end

  def validate!
    @errors << 'Must have at least one variable' unless variables.any?
    @errors << 'Must have at least one operation' unless operations.any?
    @errors << 'Invalid variables' unless variables.all?(&:valid?)
    @errors << 'Invalid operations' unless operations.all? { |o| o.valid?(variables) }
  end

  def variables
    @variables ||= config[:variables].map(&Variable)
  rescue StandardError => e
    @errors << e.message
    @variables = []
  end

  def operations
    @operations ||= config[:operations].map(&Operation)
  rescue StandardError => e
    @errors << e.message
    @operations = []
  end

  def conjunction
    @conjunction ||= CONJUNCTION_MAP.fetch(config[:conjunction], :all?)
  end

  class Variable
    attr_reader :name, :source, :method_chain, :value, :enriched

    def initialize(name:, source:, method_chain: [], value: nil)
      @name = name
      @source = source
      @method_chain = method_chain
      @value = value
      @enriched = false
    end

    def self.to_proc
      ->(attributes) { new(**attributes) }
    end

    def enrich(sources = {})
      return if enriched
      @source = sources.fetch(source.to_sym) unless source == 'static'
      @value = source.send_chain(method_chain) if method_chain.any?
      @enriched = true
      self
    end

    def valid?
      return false unless method_chain.any? || value.present?

      true
    end
  end

  class Operation
    OPERANDS = {
      gt: :>,
      gte: :>=,
      lt: :<,
      lte: :<=,
      eq: :==,
      not: :!=,
    }.freeze

    attr_reader :op, :arg1, :arg2

    def initialize(op:, arg1:, arg2:)
      @op = OPERANDS[op.to_sym]
      @arg1 = arg1
      @arg2 = arg2
    end

    def self.to_proc
      ->(attributes) { new(**attributes) }
    end

    def check(variables = {})
      @arg1 = variables.fetch(arg1).value
      @arg2 = variables.fetch(arg2).value

      arg1.send(op.to_sym, arg2)
    end

    def valid?(variables = [])
      return false unless op && arg1 && arg2
      return false unless args.all? { |arg| variables.map(&:name).include?(arg) }

      true
    end

    def args
      [arg1, arg2]
    end
  end
end
