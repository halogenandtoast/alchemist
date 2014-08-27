module Alchemist
  class ModuleBuilder
    def initialize category
      @category = category
    end

    def build
      build_module do |category_module|
        define_inspect_method(category_module)
        define_unit_methods(category_module)
      end
    end

    private
    attr_reader :category

    def build_module(&block)
      Module.new do
        def self.define_unit_method(names)
          names.each do |name|
            define_method(name.to_sym) { Alchemist.measure self, name.to_sym }
          end
        end
      end.tap &block
    end

    def define_inspect_method(category_module)
      category_module.class_eval %(def self.inspect() "#<Module(#{category})>" end)
    end

    def define_unit_methods(category_module)
      category_module.class_eval category_methods
    end

    def library
      Alchemist.library
    end

    def category_methods
      unit_names.map do |name|
        %(define_method("#{name}") { Alchemist.measure self, :#{name} }) + "\n" + prefixed_methods(name)
      end.join("\n")
    end

    def unit_names
      library.unit_names(category)
    end

    def prefixes_with_value(name)
      if library.si_units.include?(name.to_s)
        library.unit_prefixes
      else
        []
      end
    end

    def prefixed_methods(name)
      prefixes_with_value(name).map do |prefix, value|
        %(define_method("#{prefix}#{name}") { Alchemist.measure_prefixed self, :#{prefix}, :#{name}, #{value} })
      end.join("\n")
    end
  end
end
