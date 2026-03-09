module Translatable
  module DSL
    def with_locale_context(prefix)
      define_singleton_method :locale_context, -> { @locale_context ||= prefix }
    end

    def locale_context
      @locale_context ||= ''
    end

    def t(key, *args, **kwargs)
      # Allow for keys to use ../ syntax to climb back up the tree and use higher level keys
      tkey = kwargs.delete(:__tkey) || 0
      context = self.locale_context.split('.')
      context.pop(tkey)
      context = context.join('.')

      if key.start_with?('../')
        new_key = key[3..]
        t(new_key, *args, **kwargs.merge(__tkey: tkey + 1))
      else
        I18n.t("#{context}.#{key}", *args, **kwargs)
      end
    end
  end

  def self.included(base)
    # Allow including class to use the DSL
    # with_locale_context 'top.level.i18n.keys'
    base.extend(DSL)
  end

  def t(key, *args, **kwargs)
    # Allow t() to be used as an instance method - it's a shorthand, after all.
    self.class.t(key, *args, **kwargs)
  end
end
