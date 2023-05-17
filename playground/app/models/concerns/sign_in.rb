# frozen_string_literal: true

class SignIn < ExtraAction::Builder
  def build_concern!
    super
    concern.attr_accessor :auth_method
  end

  def auth_methods
    @auth_methods ||= []
  end

  def auth_method(name, **opts, &block)
    auth_methods << AuthMethod.new(self, name, **opts, &block)
  end

  def define_state_machine!
    concern.included do |base|
      base.attr_accessor :auth_method
      base.enum :state, %i[identifying authenticating approved closed]

      base.state_machine :state, initial: :identifying do
        transition from: :identifying, to: :authenticating, on: :identify, if: lambda { |record|
                                                                                 record.valid?(:identify)
                                                                               }
        transition from: :authenticating, to: :approved, on: :authenticate, if: lambda { |record|
                                                                                  record.valid?(:authenticate)
                                                                                }
        transition from: any, to: :closed, on: :close, if: lambda { |record|
                                                             record.valid?(:close)
                                                           }
      end
    end
  end

  def define_concern!
    define_state_machine!
    super
  end

  class AuthMethod
    attr_reader :name, :action, :identifiers, :verifiers

    def initialize(action, name, **opts)
      @action = action
      @name = name
      extract_options(opts)
      setup!
    end

    def extract_options(opts)
      @identifiers =
        if opts.key?(:identifier)
          Array(opts.delete(:identifier))
        else
          []
        end
      @verifiers =
        if opts.key?(:verifier)
          Array(opts.delete(:verifier))
        else
          []
        end
    end

    def setup!
      name = self.name.to_s
      if_proc = -> { auth_method.to_s == name }

      identifiers.each do |identifier|
        action.concern.included do |base|
          base.validates identifier, identify: true, if: if_proc, on: action.action_name
        end
      end
      verifiers.each do |verifier|
        action.concern.included do |base|
          base.validates verifier, challenge: true, if: if_proc, on: action.action_name
        end
      end

      super
    end
  end
end
