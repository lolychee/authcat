# frozen_string_literal: true

module Dummy
  class FormBuilder < ActionView::Helpers::FormBuilder
    def error_messages(method, **options)
      return unless @object.errors.include?(method)

      messages = @object.errors.full_messages_for(method)
      limit = options.delete(:limit)
      messages = messages.take(limit) if limit

      tag_options = {
        class: "errors"
      }
      tag_options.merge!(options)

      @template.content_tag(:ul, **tag_options) do
        messages.map { |message| block_given? ? yield(messages) : @template.content_tag(:li, message) }.safe_join
      end
    end

    def field_group(method, tag = :div, **options)
      if @object.errors.include?(method)
        error_class = "has-error"
        case options[:class]
        when Array
          options[:class] << error_class
        when String
          options[:class] += " #{error_class}"
        else
          options[:class] = error_class
        end
      end

      @template.content_tag(tag, **options) do
        yield
      end
    end
  end
end
